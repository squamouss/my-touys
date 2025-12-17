local M = {}

local function script_log(...)
    if _G.log then _G.log(...) end
end

local function table_merge(t1, t2)
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

local function add_generated_info(lines)
    if _G.add_generated_info then _G.add_generated_info(lines)
    else table.insert(lines, "[GENERATED]") end
end

-- =============================================================================
--  TEXT GENERATION HELPERS
-- =============================================================================

local function get_verb_string(config, ability, sev_lvl, num_idx)
    local sev_adj = config.SEVERITY_ADJECTIVES[sev_lvl] or "standard"
    local noun_plural = ability.noun_plural
    
    local collective = "stream" 
    if num_idx == 1 then collective = "single"
    elseif num_idx == 2 then collective = "double stream"
    elseif num_idx == 3 then collective = "group"
    elseif num_idx == 4 then collective = "cluster"
    elseif num_idx == 5 then collective = "swarm"
    elseif num_idx == 6 then collective = "horde"
    end
    
    return "project a " .. collective .. " of " .. sev_adj .. " " .. noun_plural
end

-- =============================================================================
--  1. FINAL ATTACK GENERATION (The Bullet)
-- =============================================================================
local function generate_final_attack(config, ability_key, sev_lvl, num_idx)
    local ability = config.ABILITY_TYPES[ability_key]
    local target_count = config.TARGET_TIERS[num_idx]
    
    local id = string.format("%s_SEV_%d_NUM_%d", ability.token_prefix, sev_lvl, target_count)
    local lines = {}
    
    table.insert(lines, "[INTERACTION:" .. id .. "]")
    add_generated_info(lines)
    
    table.insert(lines, "    [I_TARGET:C:CREATURE]")
    table.insert(lines, "        [IT_LOCATION:CONTEXT_CREATURE]")
    table.insert(lines, "        [IT_MANUAL_INPUT:target]")
    
    if ability.role == "OFFENSE" then
        -- ACTIVATED FIREWALLS: Block attacks of EQUAL or HIGHER level.
        for i = sev_lvl, config.MAX_POWER_LEVEL do
             table.insert(lines, "        [IT_CANNOT_HAVE_SYNDROME_CLASS:FIREWALL_" .. i .. "]")
        end
        -- INNATE FIREWALLS: Block attacks of STRICTLY HIGHER level only.
        for i = sev_lvl + 1, config.MAX_POWER_LEVEL do
             table.insert(lines, "        [IT_CANNOT_HAVE_SYNDROME_CLASS:INNATE_FIREWALL_" .. i .. "]")
        end
        table.insert(lines, "        [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]")
    end

    table.insert(lines, "    [I_EFFECT:ADD_SYNDROME]")
    table.insert(lines, "        [IE_TARGET:C]")
    table.insert(lines, "        [IE_IMMEDIATE]")
    table.insert(lines, "        [SYNDROME]")
    
    if ability.role == "DEFENSE" then
        table.insert(lines, "            [SYN_CLASS:" .. ability.syn_class_prefix .. "_" .. sev_lvl .. "]")
        local tile = config.SEVERITY_SYMBOLS[sev_lvl] or 249
        table.insert(lines, "            [CE_FLASH_TILE:TILE:"..tile..":COLOR:7:0:1:FREQUENCY:2000:1000:START:0:END:1200]")
        table.insert(lines, "            [CE_PHYS_ATT_CHANGE:DISEASE_RESISTANCE:200:0:START:0:END:1200]")
    elseif ability.role == "OFFENSE" then
        if ability.injects_silence then
             table.insert(lines, "            [SYN_CLASS:" .. config.SILENCE_CLASS .. "]")
        end
        if ability.speed_penalty_base then
            local final_speed = 100 - (10 * sev_lvl) 
            if final_speed < 10 then final_speed = 10 end
            table.insert(lines, "            [CE_SPEED_CHANGE:SPEED_PERC:"..final_speed..":ABRUPT:START:0:END:1000]")
        end
        local tile = config.SEVERITY_SYMBOLS[sev_lvl] or 249
        local color = config.COLORS.OFFENSE or "4:0:0"
        table.insert(lines, "            [CE_FLASH_TILE:TILE:"..tile..":COLOR:"..color..":FREQUENCY:2000:1000:START:0:END:1000]")
        table.insert(lines, "            [CE_PHYS_ATT_CHANGE:DISEASE_RESISTANCE:100:0:START:0:END:2000]")
    end
    
    return id, lines
end

-- =============================================================================
--  2. PREPARE INTERACTION (The Gun)
-- =============================================================================
local function generate_prepare_interaction(config, ability_key, sev_lvl, num_idx, final_attack_id)
    local ability = config.ABILITY_TYPES[ability_key]
    local target_count = config.TARGET_TIERS[num_idx]
    
    local id = "PREPARE_" .. final_attack_id
    local lines = {}

    table.insert(lines, "[INTERACTION:" .. id .. "]")
    add_generated_info(lines)

    table.insert(lines, "    [I_TARGET:A:CREATURE]")
    table.insert(lines, "        [IT_LOCATION:CONTEXT_CREATURE]")
    table.insert(lines, "        [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]")
    table.insert(lines, "        [IT_MANUAL_INPUT:creature]") 
    table.insert(lines, "        [IT_CANNOT_HAVE_SYNDROME_CLASS:" .. config.SILENCE_CLASS .. "]")

    table.insert(lines, "    [I_EFFECT:ADD_SYNDROME]")
    table.insert(lines, "        [IE_TARGET:A]")
    table.insert(lines, "        [IE_IMMEDIATE]")
    table.insert(lines, "        [SYNDROME]")
    
    table.insert(lines, "            [CE_CAN_DO_INTERACTION:PROB:100:START:2:END:6:DWF_STRETCH:50]")
    table.insert(lines, "                [CDI:INTERACTION:" .. final_attack_id .. "]")
    
    local adv_name = ability.name .. " " .. config.SEVERITY_ADJECTIVES[sev_lvl] .. " (" .. target_count .. ")"
    table.insert(lines, "                [CDI:ADV_NAME:Inject " .. adv_name .. "]")
    
    if ability.role == "DEFENSE" then
        if target_count == 1 then
             table.insert(lines, "                [CDI:USAGE_HINT:DEFEND]")
             table.insert(lines, "                [CDI:TARGET:C:SELF_ONLY]") 
        else
             table.insert(lines, "                [CDI:USAGE_HINT:GREETING]")
             table.insert(lines, "                [CDI:TARGET:C:LINE_OF_SIGHT]")
             table.insert(lines, "                [CDI:TARGET_RANGE:C:100]")
        end
    else
        table.insert(lines, "                [CDI:USAGE_HINT:ATTACK]")
        table.insert(lines, "                [CDI:TARGET:C:LINE_OF_SIGHT]")
        table.insert(lines, "                [CDI:TARGET_RANGE:C:100]")
    end
    
    table.insert(lines, "                [CDI:MAX_TARGET_NUMBER:C:" .. target_count .. "]")
    table.insert(lines, "                [CDI:WAIT_PERIOD:20]") 
    
    local verb_text = get_verb_string(config, ability, sev_lvl, num_idx)
    table.insert(lines, "                [CDI:VERB:" .. verb_text .. ":NA:NA]")
    
    local sev_adj = config.SEVERITY_ADJECTIVES[sev_lvl] or "standard"
    local t_verb_filled = ability.target_verb:gsub("%%s", sev_adj)
    table.insert(lines, "                [CDI:TARGET_VERB:" .. t_verb_filled .. "]")

    return id, lines
end

-- =============================================================================
--  3. SECRET (The Learning Method)
-- =============================================================================
local function generate_secret(config, ability_key, sev_lvl, num_idx, prepare_id)
    local ability = config.ABILITY_TYPES[ability_key]
    local target_count = config.TARGET_TIERS[num_idx]
    
    local secret_id = prepare_id .. "_SECRET"
    local slot_class = ""
    
    if ability.role == "OFFENSE" then
        slot_class = "ATTACK_HACK_SLOT_" .. sev_lvl
    else
        slot_class = "GUARD_SLOT_" .. sev_lvl
    end
    
    local lines = {}
    table.insert(lines, "[INTERACTION:" .. secret_id .. "]")
    add_generated_info(lines)
    
    table.insert(lines, "    [I_SOURCE:DEITY]")
    table.insert(lines, "        [IS_USAGE_HINT:MAJOR_CURSE]") 
    table.insert(lines, "        [IS_HIST_STRING_1: the infodeity was challenged in the Datasphere by ]")
    table.insert(lines, "        [IS_HIST_STRING_2: who compiled " .. ability.name .. "]")

    table.insert(lines, "    [I_SOURCE:SECRET]")
    table.insert(lines, "        [IS_NAME:the Digital Program- " .. ability.name .. "-" .. sev_lvl .. "-" .. target_count .. "]")
    table.insert(lines, "        [IS_SECRET_GOAL:IMMORTALITY]")
    table.insert(lines, "        [IS_SECRET:SUPERNATURAL_LEARNING_POSSIBLE]")
    table.insert(lines, "        [IS_SECRET:MUNDANE_RESEARCH_POSSIBLE]")
    table.insert(lines, "        [IS_SECRET:MUNDANE_TEACHING_POSSIBLE]")
    table.insert(lines, "        [IS_SECRET:MUNDANE_RECORDING_POSSIBLE:BOOK_INSTRUCTION:SECRET_DIGITAL]")

    table.insert(lines, "    [I_TARGET:A:CREATURE]")
    table.insert(lines, "        [IT_LOCATION:CONTEXT_CREATURE]")
    table.insert(lines, "        [IT_REQUIRES:CAN_LEARN]")
    table.insert(lines, "        [IT_REQUIRES:CAN_SPEAK]")
    table.insert(lines, "        [IT_CANNOT_HAVE_SYNDROME_CLASS:" .. slot_class .. "]")

    table.insert(lines, "    [I_EFFECT:ADD_SYNDROME]")
    table.insert(lines, "        [IE_TARGET:A]")
    table.insert(lines, "        [IE_IMMEDIATE]")
    table.insert(lines, "        [IE_ARENA_NAME:" .. ability.name .. "-" .. sev_lvl .. "-" .. target_count .. "]")
    
    table.insert(lines, "        [SYNDROME]")
    table.insert(lines, "        [SYN_CLASS:" .. slot_class .. "]")

    table.insert(lines, "        [CE_CAN_DO_INTERACTION:PROB:100:START:0:ABRUPT]")
    table.insert(lines, "            [CDI:ADV_NAME:" .. ability.name .. "-" .. sev_lvl .. "-" .. target_count .. "]")
    table.insert(lines, "            [CDI:TARGET:A:SELF_ONLY]")
    table.insert(lines, "            [CDI:INTERACTION:" .. prepare_id .. "]")
    
    if ability.role == "DEFENSE" then
        table.insert(lines, "            [CDI:USAGE_HINT:DEFEND]")
    else
        table.insert(lines, "            [CDI:USAGE_HINT:ATTACK]")
    end
    table.insert(lines, "            [CDI:WAIT_PERIOD:500]")

    return secret_id, lines
end

-- =============================================================================
--  4. REACTION (Crafting)
-- =============================================================================
local function generate_reaction(config, ability_key, sev_lvl, num_idx, inorganic_id)
    local ability = config.ABILITY_TYPES[ability_key]
    local craft = config.CRAFTING
    local reaction_id = inorganic_id:gsub("_PROGRAM", "") .. "_REACTION"
    local lines = {}
    
    -- FREE RECIPE LOGIC
    local is_free = craft.FREE_RECIPES or false
    
    local cost_scrap = 1
    local cost_tablet = 1
    
    if not is_free then
        local calculated_cost = craft.COST_BASE + (sev_lvl * craft.COST_MULT) + (num_idx * craft.COST_TARGET_MULT)
        cost_scrap = calculated_cost
        cost_tablet = calculated_cost + 5
    end
    
    -- FORT MODE
    table.insert(lines, "[REACTION:" .. reaction_id .. "]")
    add_generated_info(lines)
    table.insert(lines, "    [NAME:Compile " .. ability.name .. "]")
    table.insert(lines, "    [FORTRESS_MODE_ENABLED]")
    table.insert(lines, "    [BUILDING:" .. craft.FORT_BUILDING .. ":NONE]")
    
    table.insert(lines, "    [REAGENT:blank_tablet:"..cost_tablet..":TOOL:"..craft.FORT_TOOL_PREFIX..":NONE:"..craft.FORT_REAGENT_MAT.."]")
    
    table.insert(lines, "    [PRODUCT:100:1:BOULDER:NONE:INORGANIC:" .. inorganic_id .. "]")
    table.insert(lines, "    [SKILL:EXTRACT_STRAND]") 
    table.insert(lines, "    [CATEGORY:" .. craft.CATEGORY_ID_PREFIX .. "_FORT]")
    
    table.insert(lines, "")

    -- ADVENTURE MODE
    local adv_id = reaction_id .. "_ADV"
    table.insert(lines, "[REACTION:" .. adv_id .. "]")
    add_generated_info(lines)
    table.insert(lines, "    [NAME:Compile " .. ability.name .. "]")
    table.insert(lines, "    [ADVENTURE_MODE_ENABLED]")
    
    table.insert(lines, "    [REAGENT:scrap:"..cost_scrap..":TOOL:ITEM_TOOL_SCRAP:"..craft.ADV_SCRAP_MAT.."]")
    table.insert(lines, "    [REAGENT:synth:1:TOOL:"..craft.ADV_TOOL_ID..":NONE:NONE][PRESERVE_REAGENT]")
    
    table.insert(lines, "    [PRODUCT:100:1:BOULDER:NONE:INORGANIC:" .. inorganic_id .. "]")
    table.insert(lines, "    [SKILL:EXTRACT_STRAND]")
    table.insert(lines, "    [CATEGORY:" .. craft.CATEGORY_ID_PREFIX .. "_ADV]")

    return reaction_id, lines
end

-- =============================================================================
--  5. INORGANIC (The Item)
-- =============================================================================
local function generate_inorganic(config, ability_key, sev_lvl, num_idx, prepare_id)
    local ability = config.ABILITY_TYPES[ability_key]
    local target_count = config.TARGET_TIERS[num_idx]
    
    local program_name = ability.token_prefix .. "_SEV_" .. sev_lvl .. "_NUM_" .. target_count .. "_PROGRAM"
    local lines = {}
    
    table.insert(lines, "[INORGANIC:" .. program_name .. "]")
    add_generated_info(lines)
    table.insert(lines, "    [USE_MATERIAL_TEMPLATE:STONE_TEMPLATE]")
    table.insert(lines, "    [STATE_NAME_ADJ:ALL_SOLID:" .. ability.name .. " v" .. sev_lvl .. "." .. num_idx .. "]")
    table.insert(lines, "    [DISPLAY_COLOR:2:0:1]")
    table.insert(lines, "    [TILE:232]") 
    table.insert(lines, "    [EDIBLE_RAW]") 
    table.insert(lines, "    [EDIBLE_VERMIN]")
    
    table.insert(lines, "    [SYNDROME]")
    table.insert(lines, "        [SYN_NAME:installed " .. program_name .. "]")
    table.insert(lines, "        [SYN_AFFECTED_CREATURE:ADVENTURER:ALL]")
    table.insert(lines, "        [SYN_AFFECTED_CREATURE:DWARF:ALL]")
    table.insert(lines, "        [CE_CAN_DO_INTERACTION:START:0:END:0:INTERACTION:" .. prepare_id .. "]")
    table.insert(lines, "            [CDI:ADV_NAME:" .. ability.name .. "-" .. sev_lvl .. "-" .. target_count .. "]")
    table.insert(lines, "            [CDI:TARGET:A:SELF_ONLY]")
    table.insert(lines, "            [CDI:INTERACTION:" .. prepare_id .. "]")
    table.insert(lines, "            [CDI:WAIT_PERIOD:500]")
    
    return program_name, lines
end

-- =============================================================================
--  MAIN EXECUTION
-- =============================================================================

function M.generate(config)
    local all_interaction_lines = {}
    local all_inorganic_lines = {}
    local all_reaction_lines = {}
    
    script_log("DIGITAL_WARFARE: Starting generation...")

    for key, ability in pairs(config.ABILITY_TYPES) do
        for sev = 1, config.MAX_POWER_LEVEL do
            for num = 1, 6 do 
                -- 1. Create Final Attack
                local attack_id, attack_lines = generate_final_attack(config, key, sev, num)
                table_merge(all_interaction_lines, attack_lines)
                table.insert(all_interaction_lines, "")

                -- 2. Create Prepare Interaction
                local prep_id, prep_lines = generate_prepare_interaction(config, key, sev, num, attack_id)
                table_merge(all_interaction_lines, prep_lines)
                table.insert(all_interaction_lines, "")
                
                -- 3. Create Secret
                local sec_id, sec_lines = generate_secret(config, key, sev, num, prep_id)
                table_merge(all_interaction_lines, sec_lines)
                table.insert(all_interaction_lines, "")
                
                -- 4. Create Inorganic
                local mat_id, mat_lines = generate_inorganic(config, key, sev, num, prep_id)
                table_merge(all_inorganic_lines, mat_lines)
                table.insert(all_inorganic_lines, "")
                
                -- 5. Create Reactions
                local react_id, react_lines = generate_reaction(config, key, sev, num, mat_id)
                table_merge(all_reaction_lines, react_lines)
                table.insert(all_reaction_lines, "")
            end
        end
    end
    
    -- === REGISTERING CONTENT TO THE GAME ===
    -- This was missing! Without this, the game never receives the data.
    
    if _G.raws then
        if #all_interaction_lines > 0 then
            script_log("DIGITAL_WARFARE: Registering " .. #all_interaction_lines .. " interaction lines.")
            _G.raws.register_interactions(all_interaction_lines)
        end
        
        if #all_inorganic_lines > 0 then
            script_log("DIGITAL_WARFARE: Registering " .. #all_inorganic_lines .. " inorganic lines.")
            _G.raws.register_inorganics(all_inorganic_lines)
        end
        
        if #all_reaction_lines > 0 then
            script_log("DIGITAL_WARFARE: Registering " .. #all_reaction_lines .. " reaction lines.")
            _G.raws.register_reactions(all_reaction_lines)
        end
    end

    return all_interaction_lines, all_inorganic_lines, all_reaction_lines
end

-- =============================================================================
--  STANDALONE TESTING
-- =============================================================================
if ... == nil then
    print("Running Digital Warfare Generator in standalone mode...")
    
    local outfile = "output_digital_warfare.txt"
    local f = io.open(outfile, "w")
    if f then 
        f:write("--- GENERATED DIGITAL WARFARE OUTPUT ---\n")
        f:close()
        print("Cleared output file: " .. outfile)
    end

    local function append_to_file(header, lines)
        local f = io.open(outfile, "a")
        if not f then print("Error writing to file"); return end
        f:write("\n" .. header .. "\n")
        for _, line in ipairs(lines) do f:write(line .. "\n") end
        f:close()
    end

    _G.raws = {
        register_interactions = function(lines) append_to_file("[OBJECT:INTERACTION]", lines) end,
        register_inorganics = function(lines) append_to_file("[OBJECT:INORGANIC]", lines) end,
        register_reactions = function(lines) append_to_file("[OBJECT:REACTION]", lines) end,
    }

    print("Loading config...")
    local status, config = pcall(require, "config_digital_warfare")
    if not status then
        status, config = pcall(dofile, "config_digital_warfare.lua")
    end

    if status and config then
        print("Config loaded. Generating content...")
        
        -- Since M.generate now calls _G.raws.register internally,
        -- calling it here will trigger the append_to_file writes automatically.
        -- We do NOT need to manually pass the returned tables to register functions again.
        M.generate(config)
        
        print("Generation complete. Check " .. outfile)
    else
        print("CRITICAL ERROR: Could not load config_digital_warfare.lua")
        print(config)
    end
end

return M