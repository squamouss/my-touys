--[[
    MOD EXPERIMENT GENERATOR (mod_experiment_generator.lua)
    
    This is a self-contained module that hooks into the 'preprocess'
    phase of world generation. It intercepts requests to make
    experiments and generates them using your CGE.
    
    It does NOT override any vanilla functions.
    
    This version is MINIMAL and adds NO TOKENS. It only
    runs the CGE, replaces the token, and adds a description.
]]

-- Log function for debugging
local function script_log(...)
    -- Using _G.log as defined in main init.lua
    if _G.log then
        _G.log(...)
    end
end

script_log("MOD_EXPERIMENT_GENERATOR: Loading (Minimal Hook)...")

-- ===========================================================================
-- REQUIREMENTS
-- ===========================================================================

-- 1. Load our config
-- [FIXED] Corrected path. Lua's 'require' caches this, so it won't reload
-- if init.lua already loaded it, but it will get us the config_data table.
local success_config, config_data = pcall(require, "experiments.experiment_config")
if not success_config then
    script_log("MOD_EXPERIMENT_GENERATOR: FATAL ERROR! Could not load 'experiments.experiment_config'.", tostring(config_data))
    return
end

-- 2. Load the user's Creature Generator Engine (CGE)
local success_cge, cge_module = pcall(require, "creature_generator_engine")
if not success_cge then
    script_log("MOD_EXPERIMENT_GENERATOR: FATAL ERROR! Could not load user's 'creature_generator_engine.lua'.", tostring(cge_module))
    return
end

-- Get variables from our config
local LOG_CURRENT_ENTRY = config_data.LOG_CURRENT_ENTRY
local MOD_GENERATED_EXPERIMENT_TOKENS = config_data.MOD_GENERATED_EXPERIMENT_TOKENS
local MOD_ARCHETYPE_MAP = config_data.MOD_ARCHETYPE_MAP
local MOD_EXPERIMENT_RECIPES = config_data.MOD_EXPERIMENT_RECIPES

-- ===========================================================================
-- HELPER FUNCTIONS
-- ===========================================================================
-- ... existing helper functions ...
-- Hierarchy for size logic
local size_tag_hierarchy = { "MICRO", "MINIMAL", "SMALL", "LESSER", "MEDIUM", "LARGE", "HUGE", "GIANT", "TITANIC" }
local size_tag_to_index = {}
for i, tag in ipairs(size_tag_hierarchy) do
    size_tag_to_index[tag] = i
end

--- Finds the archetype for a given creature definition.
local function get_creature_archetype(creature_def)
    if not creature_def then return "UNKNOWN" end

    -- 1. Check for archetype_class field (from your CGE configs)
    if creature_def.archetype_class and MOD_ARCHETYPE_MAP[creature_def.archetype_class] then
        return MOD_ARCHETYPE_MAP[creature_def.archetype_class]
    end

    -- 2. Check token
    if creature_def.token and MOD_ARCHETYPE_MAP[creature_def.token] then
        return MOD_ARCHETYPE_MAP[creature_def.token]
    end
    
    -- 3. Fallback: check token prefixes
    if creature_def.token then
        for token_prefix, archetype in pairs(MOD_ARCHETYPE_MAP) do
            -- Use string.match to check for prefix
            if creature_def.token:match("^" .. token_prefix) then
                return archetype
            end
        end
    end

    script_log("MOD_EXPERIMENT_GENERATOR: Could not find archetype for creature: ", creature_def.token or "NIL")
    return "UNKNOWN"
end

-- Helper to get size tags (e.g., "MEDIUM", "LARGE") from a creature definition
local function get_creature_size_tags(creature_def)
    local size_tags = {}
    if not creature_def or not creature_def.caste then
        return size_tags
    end
    
    -- Check all castes for size classes
    for _, caste in pairs(creature_def.caste) do
        if caste.creature_class then
            for class_token, is_present in pairs(caste.creature_class) do
                if is_present then
                    -- Match "SIZE_MEDIUM" and extract "MEDIUM"
                    local size_tag = class_token:match("^SIZE_(.+)")
                    if size_tag then
                        -- Add the tag if it's not already in our list
                        local found = false
                        for _, existing_tag in ipairs(size_tags) do
                            if existing_tag == size_tag then
                                found = true
                                break
                            end
                        end
                        if not found then
                            table.insert(size_tags, size_tag)
                        end
                    end
                end
            end
        end
    end
    
    if #size_tags > 0 then
        script_log("MOD_EXPERIMENT_GENERATOR: Found subject size tags:", table.concat(size_tags, ", "))
    else
        script_log("MOD_EXPERIMENT_GENERATOR: WARNING: Could not find size tags for subject creature.")
    end
    
    return size_tags
end

-- Helper to check if a creature has all required tags
local function check_required_tags(creature_tags, required_tags)
    if not required_tags or #required_tags == 0 then
        return true -- No tags are required, so it's a match.
    end
    
    if not creature_tags or #creature_tags == 0 then
        return false -- Tags are required, but the creature has none.
    end

    for _, req_tag in ipairs(required_tags) do
        local found = false
        for _, cr_tag in ipairs(creature_tags) do
            if cr_tag == req_tag then
                found = true
                break
            end
        end
        if not found then
            -- A required tag was missing.
            return false
        end
    end
    
    return true -- All required tags were found.
end


--- [MODIFIED] Finds a matching recipe from our config table based on all subject criteria
local function find_matching_recipe(experimenter_arch, subject_arch, experiment_type, subject_tags)
    script_log("MOD_EXPERIMENT_GENERATOR: Finding recipe for: (Experimenter: " .. experimenter_arch .. ") + (Subject Arch: " .. subject_arch .. ") + (Subject Tags: " .. table.concat(subject_tags, ", ") .. ") -> (Type: " .. experiment_type .. ")")
    
    for _, recipe in ipairs(MOD_EXPERIMENT_RECIPES) do
        local exp_match = (recipe.experimenter_archetype == experimenter_arch or recipe.experimenter_archetype == "ANY")
        local sub_match = (recipe.subject_archetype == subject_arch or recipe.subject_archetype == "ANY")
        local type_match = (recipe.experiment_type == experiment_type or recipe.experiment_type == "ANY")
        
        -- [NEW] Check if the subject has all the required tags (which includes archetype and size)
        local tags_match = check_required_tags(subject_tags, recipe.required_subject_tags)

        if exp_match and sub_match and type_match and tags_match then
            script_log("MOD_EXPERIMENT_GENERATOR: Found matching recipe.")
            return recipe
        end
    end
    
    script_log("MOD_EXPERIMENT_GENERATOR: WARNING! No recipe found. This should not happen if a fallback exists.")
    return nil
end

--- Requirement 3: Custom description function to inject our legends string
local function build_custom_experiment_description(lines, options, recipe)
    local ropar = random_object_parameters
    local end_str = ""
    local add_desc = function(str) end_str = end_str .. str end

    if ropar.experimenter_hf then
        add_desc(" This night creature was first created ")
        if options.failed_experiment then
            add_desc("accidentally ")
        end
        add_desc("by the ")
        
        local ip = ropar.experimenter_hf.profile and ropar.experimenter_hf.profile.interaction_profile
        if ip and ip.uwss_display_name_sing ~= "" then
            add_desc(ropar.experimenter_race_adj .. " " .. ip.uwss_display_name_sing)
        else
            add_desc(ropar.experimenter_race_name)
        end
        add_desc(" ")
        add_desc(ropar.experimenter_hf.name.translated)
        
        if ropar.experimenter_capital_st then
            add_desc(" of ")
            add_desc(ropar.experimenter_capital_st.name.translated)
        end
        
        -- CUSTOM LOGIC INJECTION (Requirement 3)
        add_desc(" " .. (recipe.legends_string or "after horrible experiments") .. " ")
        
        if ropar.experimenter_source_hfid ~= -1 or ropar.experimenter_source_race ~= -1 then
            if options.amalgam_experiment then add_desc("from multitudes")
            elseif ropar.experimenter_source_hfid ~= -1 then
                add_desc("from the ")
                if ropar.experiment_hf and ropar.experiment_source_race_adj then
                    add_desc(ropar.experiment_source_race_adj)
                else 
                    add_desc("an unknown creature")
                end
            elseif ropar.experimenter_source_race ~= -1 then
                add_desc("from " .. ropar.experiment_source_race_name_plural)
            end
        end

        if ropar.experimenter_create_st then
            add_desc(" in " .. ropar.experimenter_create_st.name.translated)
        end
        add_desc(" in the year " .. tostring(world.year) .. ".")
    end

    return end_str
end

-- ===========================================================================
-- MASTER GENERATOR HOOK
-- ===========================================================================

local function run_experiment_generation_hook()
    local ropar = random_object_parameters
    
    -- 1. CHECK IF THE GAME WANTS AN EXPERIMENT
    local experiment_type = ropar.making_experiment
    if not experiment_type then
        -- This is not an experiment call, do nothing.
        return
    end

    script_log("MOD_EXPERIMENT_GENERATOR: Intercepted experiment request: ", experiment_type)

    -- 2. MANUALLY CONSTRUCT THE CREATURE TOKEN
    -- The game passes 'tok' to the vanilla function, but we are in a hook
    -- and must build it from ropar data.
    local tok_prefix = ropar.token_prefix or "HFEXP_MOD" -- Fallback prefix
    local exp_count = (ropar.experimenter_experiment_count or 0) + 1
    local new_game_token = tok_prefix .. "_" .. string.upper(experiment_type) .. "_" .. tostring(exp_count)
    
    -- 3. IDENTIFY THE ACTORS (Requirement 1)
    local experimenter_arch = get_creature_archetype(ropar.experimenter_creature)
    local subject_arch = get_creature_archetype(ropar.experimenter_source_creature)
    
    -- [NEW] Get all tags from the subject for matching
    local subject_size_tags = get_creature_size_tags(ropar.experimenter_source_creature)
    local all_subject_tags = {}
    table.insert(all_subject_tags, subject_arch)
    for _, tag in ipairs(subject_size_tags) do
        table.insert(all_subject_tags, tag)
    end

    -- 4. FIND THE RECIPE
    local recipe = find_matching_recipe(experimenter_arch, subject_arch, experiment_type, all_subject_tags)

    -- 5. HANDLE FALLBACK (Recipe says to do nothing)
    if not recipe or not recipe.config_file_to_use then
        script_log("MOD_EXPERIMENT_GENERATOR: No mod recipe found or config_file_to_use is nil. No experiment created for: ", experiment_type)
        ropar.making_experiment = nil -- Mark as handled
        return
    end

    -- 6. GENERATE NEW CREATURE (Requirements 1, 2, 3)
    script_log("MOD_EXPERIMENT_GENERATOR: Using mod recipe. Generating from config: ", recipe.config_file_to_use)
    
    local config_name = recipe.config_file_to_use:gsub("%.lua", "")
    local success_load_config, config_obj = pcall(require, config_name)
    if not success_load_config then
        script_log("MOD_EXPERIMENT_GENERATOR: ERROR! Could not 'require' the recipe config file: ", config_name, tostring(config_obj))
        ropar.making_experiment = nil -- Mark as handled
        return
    end

    -- [NEW] Split the recipe's output tags into size constraints (for CGE) and rating filters (for us)
    local forced_size_tags = {}
    local forced_rating_tags = {}
    if recipe.required_output_tags then
        for _, tag in ipairs(recipe.required_output_tags) do
            if size_tag_to_index[tag] then
                table.insert(forced_size_tags, tag)
            else
                table.insert(forced_rating_tags, tag)
            end
        end
    end

    -- Pass the 'forced_size_tags' (e.g., {"LARGE"}) to the CGE
    local generated_data = cge_module.generate_data_only(config_obj, forced_size_tags)
    
    if not generated_data or #generated_data == 0 then
        script_log("MOD_EXPERIMENT_GENERATOR: ERROR! CGE returned no creature data for config: ", recipe.config_file_to_use)
        if forced_size_tags and #forced_size_tags > 0 then
             script_log("MOD_EXPERIMENT_GENERATOR: This may be because no creatures in that config match the required size tags: ", table.concat(forced_size_tags, ", "))
        end
        ropar.making_experiment = nil -- Mark as handled
        return
    end

    -- Requirement 2: Find a creature from the list that has not been generated yet
    local chosen_creature_raws = nil
    local original_creature_token = nil
    
    -- This loop now also checks for required_output_tags
    for _, creature_obj in ipairs(generated_data) do
        -- The token is on the first line, e.g., "[CREATURE:SHELL_ID-MDM-SPNT-1234]"
        local cge_token_line = creature_obj.creature[1]
        local cge_token = cge_token_line:match("%[CREATURE:(.+)%]")
        
        -- Check if the creature's tags match the recipe's *rating* requirements
        local tags_match = check_required_tags(creature_obj.components.creature_tags, forced_rating_tags)
        
        if cge_token and not MOD_GENERATED_EXPERIMENT_TOKENS[cge_token] and tags_match then
            -- This one hasn't been used yet! Let's use it.
            chosen_creature_raws = creature_obj.creature
            original_creature_token = cge_token -- This is now the string, e.g., "SHELL_ID-MDM-SPNT-1234"
            
            -- Mark it as used
            MOD_GENERATED_EXPERIMENT_TOKENS[cge_token] = true
            script_log("MOD_EXPERIMENT_GENERATOR: Found and 'claimed' unused creature token: ", cge_token)
            break
        end
    end
    
    if not chosen_creature_raws then
        script_log("MOD_EXPERIMENT_GENERATOR: WARNING! All creatures from config '", recipe.config_file_to_use, "' have already been generated (or match constraints). No experiment created.")
        ropar.making_experiment = nil -- Mark as handled
        return
    end
    
    -- 7. PROCESS THE RAWS
    local final_raws = {}
    
    script_log("MOD_EXPERIMENT_GENERATOR: Replacing CGE token '" .. original_creature_token .. "' with game token '" .. new_game_token .. "'")

    for _, line in ipairs(chosen_creature_raws) do
        local modified_line = line
        
        -- Replace all instances of the original token with the new one
        modified_line = string.gsub(modified_line, original_creature_token, new_game_token)

        if string.starts(modified_line, "[CREATURE:") then
            table.insert(final_raws, modified_line)
        
        -- Keep the naming from the CGE
        elseif string.starts(modified_line, "[NAME:") or
               string.starts(modified_line, "[CASTE_NAME:") or
               string.starts(modified_line, "[GO_TO_START]") then
            
            table.insert(final_raws, modified_line)
        
        -- Remove CGE's description
        elseif not string.starts(modified_line, "[DESCRIPTION:") then
            table.insert(final_raws, modified_line)
        end
    end

    -- Build the options table
    local options = {
        token = new_game_token,
        failed_experiment = (experiment_type == "failed_small" or experiment_type == "failed_large"),
        amalgam_experiment = (experiment_type == "humanoid_giant"),
    }

    -- Add our custom description (Requirement 3)
    local custom_description = build_custom_experiment_description(final_raws, options, recipe)
    table.insert(final_raws, "[DESCRIPTION:" .. custom_description .. "]")
    
    -- Add debug log token if enabled (Requirement 4)
    if LOG_CURRENT_ENTRY then
        table.insert(final_raws, "[LOG_CURRENT_ENTRY]")
    end
    
    -- 8. REGISTER THE CREATURE AND CLEAN UP
    script_log("MOD_EXPERIMENT_GENERATOR: Registering custom experiment: ", new_game_token)
    raws.register_creatures(final_raws)
    
    -- Tell the game we are done
    ropar.making_experiment = nil 
    -- Increment the count so the *next* token is correct
    ropar.experimenter_experiment_count = exp_count

    script_log("MOD_EXPERIMENT_GENERATOR: Successfully generated custom experiment.")
end


-- ===========================================================================
-- MODULE RETURN
-- ===========================================================================

-- Return the hook function so init.lua can call it
return {
    run_experiment_generation_hook = run_experiment_generation_hook
}

