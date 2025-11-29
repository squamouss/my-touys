local ENABLE_LUALOG = true
local ENABLE_MODULAR_EXPERIMENTS = true 
local original_log = _G.log
local function custom_log(...)
    if ENABLE_LUALOG and type(original_log) == "function" then
        original_log(...)
    end
end
_G.log = custom_log
if _G.get_caller_loc_string == nil then
    _G.get_caller_loc_string = function() return "[Location Unknown]" end
end

-- =====================================================================================
-- MODULE REQUIREMENTS
-- =====================================================================================
_G.log("INIT_LOG: Requiring all generator modules...")

local function safe_require(module_name)
    local success, module = pcall(require, module_name)
    if success then
        _G.log("INIT_LOG: Successfully loaded module '" .. module_name .. "'.")
        return module
    else
        _G.log("INIT_LOG: FATAL ERROR loading module '" .. module_name .. "': " .. tostring(module))
        return nil
    end
end

local creature_generator_engine = safe_require("creature_generator_engine")

safe_require("filter")
safe_require("conlang_locant_1")
safe_require("conlang_locant_2")
safe_require("conlang_locant_3")
safe_require("conlang_locant_4")
safe_require("conlang_locant_5")
safe_require("conlang_locant_6")
safe_require("conlang_excant_1")
safe_require("conlang_excant_2")
safe_require("conlang_excant_3")
safe_require("conlang_uncant_1")
safe_require("conlang_uncant_2")
safe_require("conlang_uncant_3")
safe_require("conlang_hicant")
safe_require("conlang_postcant")
safe_require("conlang_endcant")

local config_files = {
    {data = safe_require("config_locaste"), name = "config_locaste", generate_early = true},
    {data = safe_require("config_neotenate"), name = "config_neotenate", generate_early = true},
    {data = safe_require("config_protoform"), name = "config_protoform", generate_early = true},
    {data = safe_require("config_shell"), name = "config_shell", generate_early = true},
    {data = safe_require("config_chimera"), name = "config_chimera", generate_early = true},
    {data = safe_require("config_automachine"), name = "config_automachine", generate_early = true},
    {data = safe_require("config_macrocell"), name = "config_macrocell", generate_early = true},
    {data = safe_require("config_polymerid"), name = "config_polymerid", generate_early = true},
    {data = safe_require("config_husk"), name = "config_husk", generate_early = true},
    {data = safe_require("config_ghost"), name = "config_ghost", generate_early = true},
    {data = safe_require("config_engram"), name = "config_engram", generate_early = true},
    {data = safe_require("config_hicaste"), name = "config_hicaste", generate_early = true},
    {data = safe_require("config_replica"), name = "config_replica", generate_early = true},
    {data = safe_require("config_cyborg"), name = "config_cyborg", generate_early = true},
    {data = safe_require("config_degen"), name = "config_degen", generate_early = true},
    {data = safe_require("config_transhuman"), name = "config_transhuman", generate_early = true},
    {data = safe_require("config_deviant"), name = "config_deviant", generate_early = true},
    {data = safe_require("config_biomachine"), name = "config_biomachine", generate_early = true},
    {data = safe_require("config_bioroid"), name = "config_bioroid", generate_early = true},
    {data = safe_require("config_impurity"), name = "config_impurity", generate_early = true},
    {data = safe_require("config_drone"), name = "config_drone", generate_early = true}
}

local dynamic_civilization_generator_module = safe_require("dynamic_civilization_generator")
local dynamic_underground_generator_module = safe_require("dynamic_underground_generator")
local universal_transformation_module = safe_require('universal_transformation')
local universal_transcendent_transformation_module = safe_require('universal_transcendent_transformation')
local specific_transformation_module = safe_require("specific_transformation")
local universal_item_and_reaction_generators_module = safe_require("universal_item_and_reaction_generators")

-- =====================================================================================
-- ===== MODULE REQUIRE FOR TRANSMUTATION ======================================
-- =====================================================================================
_G.log("INIT_LOG: Loading weapon system configs...")
local weapon_configs = {
    safe_require("transmutation.config_autogun"),
    safe_require("transmutation.config_rotorgun"),
    safe_require("transmutation.config_cannon"),
    safe_require("transmutation.config_blade"),
    safe_require("transmutation.config_jet"),
    safe_require("transmutation.config_cloud"),
    safe_require("transmutation.config_web")
}

local weapon_generator_module = safe_require("transmutation.weapon_generator")
-- =====================================================================================

-- =====================================================================================
-- ===== MODULAR EXPERIMENT SYSTEM
-- =====================================================================================
local experiment_engine_module = nil
if ENABLE_MODULAR_EXPERIMENTS then
    _G.log("INIT_LOG: Modular experiment system is ENABLED. Loading modules from 'experiments/'...")
    -- Config must be loaded first as the engine depends on it
    -- Note: 'experiments.' prefix tells Lua to look in the 'experiments' folder
    safe_require("experiments.experiment_config") 
    experiment_engine_module = safe_require("experiments.experiment_engine")
else
    _G.log("INIT_LOG: Modular experiment system is DISABLED.")
end
-- =====================================================================================


_G.log("INIT_LOG: All modules loaded.")

-- =====================================================================================
-- TABLE INITIALIZATION
-- =====================================================================================
if materials == nil then materials = {} end
if items == nil then items = {} end
if languages == nil then languages = {} end
if creatures == nil then creatures = {} end
if interactions == nil then interactions = {} end
if entities == nil then entities = {} end
if preprocess == nil then preprocess = {} end
if do_once == nil then do_once = {} end
if postprocess == nil then postprocess = {} end
if do_once_early == nil then do_once_early = {} end

-- =====================================================================================
-- ===== [NEW] EXPERIMENT TRIGGER HOOKS
-- =====================================================================================
_G.log("INIT_LOG: Registering experiment trigger hooks...")
if creatures.experiment == nil then creatures.experiment = {} end

-- This dummy function "registers" our mod to handle experiments.
-- The game will set ropar.making_experiment, which our preprocess
-- hook (experiment_engine.lua) will intercept.
-- The preprocess hook does all the real work and then sets
-- ropar.making_experiment = nil, so by the time this function
-- is actually called, the work is already done.
local dummy_experiment_func = function(tok)
    _G.log("INIT_LOG: Dummy experiment trigger called for tok: " .. (tok or "NIL") .. ". No action needed (preprocess hook already ran).")
    -- Return an empty table to satisfy the game.
    return { raws={}, weight=1 }
end

-- Register our dummy trigger for all experiment types your
-- engine is capable of intercepting.
creatures.experiment.humanoid = dummy_experiment_func
creatures.experiment.humanoid_giant = dummy_experiment_func
creatures.experiment.beast_large = dummy_experiment_func
creatures.experiment.beast_small = dummy_experiment_func
creatures.experiment.failed_large = dummy_experiment_func
creatures.experiment.failed_small = dummy_experiment_func

_G.log("INIT_LOG: Experiment triggers registered.")
-- =====================================================================================


-- =====================================================================================
-- ===== MODULAR EXPERIMENT HOOK
-- =====================================================================================
if ENABLE_MODULAR_EXPERIMENTS and experiment_engine_module then
    _G.log("INIT_LOG: Inserting modular experiment hook into preprocess phase.")
    table.insert(preprocess, function()
        -- This hook runs every time preprocess runs, to check for ropar.making_experiment
        pcall(experiment_engine_module.run_experiment_generation_hook)
    end)
end
-- =====================================================================================


-- =====================================================================================
-- GLOBAL DATA STORAGE
-- =====================================================================================
local registered_interactions_temp_store = {}
local combined_generated_creature_data = {}

-- =====================================================================================
-- UTILITY FUNCTION FOR GENERATION
-- =====================================================================================
local function generate_and_register_creatures(config, target_data_cache)
    if config.data and creature_generator_engine then
        _G.log("INIT_LOG: Generating data for [" .. config.name .. "]")
        
        -- Step 1: Generate the creature data structures.
        local generated_data = creature_generator_engine.generate_data_only(config.data)

        if generated_data and #generated_data > 0 then
            -- Step 2: Immediately register the creatures using the direct injection method.
            local all_lines_for_this_config = {}
            for _, creature_obj in ipairs(generated_data) do
                if creature_obj.creature then
                    for _, line in ipairs(creature_obj.creature) do
                        table.insert(all_lines_for_this_config, line)
                    end
                end
            end
            
            if raws and raws.register_creatures and #all_lines_for_this_config > 0 then
                raws.register_creatures(all_lines_for_this_config)
                _G.log("INIT_LOG: Directly registered " .. #all_lines_for_this_config .. " creature raw lines for [" .. config.name .. "].")
            end

            -- Step 3: Cache the full data structure for dependent modules.
            for _, creature_obj in ipairs(generated_data) do
                table.insert(target_data_cache, creature_obj)
            end
        end
    end
end

-- =====================================================================================
-- PREPROCESS PHASE
-- =====================================================================================
table.insert(preprocess, function()
    if not (random_object_parameters.pre_gen_randoms or random_object_parameters.main_world_randoms) then return end
    
    _G.log("INIT_LOG: Activating interaction interception hook.")
    if type(_G.raws) ~= "table" then _G.raws = {} end
    if not _G.raws.register_interactions_original then
        _G.raws.register_interactions_original = _G.raws.register_interactions or function() end
    end

    _G.raws.register_interactions = function(lines_table)
        if type(lines_table) == "table" then
            local current_block = {}
            for _, line in ipairs(lines_table) do
                if line:match("^%[INTERACTION:") and #current_block > 0 then
                    table.insert(registered_interactions_temp_store, table.concat(current_block, "\n"))
                    current_block = { line }
                else
                    table.insert(current_block, line)
                end
            end
            if #current_block > 0 then
                table.insert(registered_interactions_temp_store, table.concat(current_block, "\n"))
            end
        end
        _G.raws.register_interactions_original(lines_table)
    end

    _G.raws.get_interactions = function()
        return registered_interactions_temp_store
    end
end)

-- =====================================================================================
-- DO_ONCE_EARLY PHASE: GENERATE PRE-MAP DATA
-- =====================================================================================
table.insert(do_once_early, function()
    if not random_object_parameters.pre_gen_randoms then return end
    _G.log("INIT_LOG: Executing DO_ONCE_EARLY hook for pre-map data generation.")

    -- Generate creatures flagged for the early phase
    for _, config in ipairs(config_files) do
        if config.generate_early then
            generate_and_register_creatures(config, combined_generated_creature_data)
        end
    end

    _G.log("INIT_LOG: Early-phase creature generation complete.")

    -- Run modules that need to operate in the early phase
    if dynamic_underground_generator_module then
        pcall(dynamic_underground_generator_module.prepare_civilization_data_hook, combined_generated_creature_data)
        pcall(dynamic_underground_generator_module.generate_civilizations_hook)
        _G.log("INIT_LOG: Finished running dynamic_underground_generator in early phase.")
    end

    _G.log("INIT_LOG: DO_ONCE_EARLY hook finished.")
end)


-- =====================================================================================
-- DO_ONCE PHASE: GENERATE MAIN DATA
-- =====================================================================================
table.insert(do_once, function()
    if not random_object_parameters.main_world_randoms then return end
    _G.log("INIT_LOG: Executing primary DO_ONCE hook for main data generation.")
    
    if language_manager then
        pcall(language_manager.register_all_languages)
    end

    -- Generate creatures flagged for the main phase
    for _, config in ipairs(config_files) do
        if not config.generate_early then
            generate_and_register_creatures(config, combined_generated_creature_data)
        end
    end
    
    _G.log("INIT_LOG: Main-phase creature data generation and registration complete.")
    _G.log("INIT_LOG: Total creature objects cached from ALL phases for dependent modules: " .. #combined_generated_creature_data)

    if #combined_generated_creature_data == 0 then
        _G.log("INIT_LOG: No creatures were generated in any phase, skipping dependent modules.")
        return
    end

    _G.log("INIT_LOG: Executing dependent module hooks...")
    if dynamic_civilization_generator_module then
        pcall(dynamic_civilization_generator_module.prepare_civilization_data_hook, combined_generated_creature_data)
        pcall(dynamic_civilZization_generator_module.generate_civilizations_hook)
        _G.log("INIT_LOG: Finished running dynamic_civilization_generator.")
    end
    
    _G.log("INIT_LOG: Executing transformation interaction generation hooks...")
    if universal_transformation_module then pcall(universal_transformation_module.preprocess.transformation_init, combined_generated_creature_data) end
    if universal_transcendent_transformation_module then pcall(universal_transcendent_transformation_module.preprocess.transformation_init, combined_generated_creature_data) end
    if specific_transformation_module then pcall(specific_transformation_module.preprocess.transformation_init, combined_generated_creature_data) end
    _G.log("INIT_LOG: Transformation interaction hook finished.")

    -- =====================================================================================
    -- ===== UPDATED CALL TO RENAMED TRANSMUTATION GENERATOR ===============================
    -- =====================================================================================
    _G.log("INIT_LOG: Executing transmutation weapon system generation...")
    if weapon_generator_module then
        -- This calls the 'generate_all_custom_weapon_systems' function from the module,
        -- passing in the configs we loaded earlier.
        pcall(weapon_generator_module.generate_all_custom_weapon_systems, weapon_configs)
        _G.log("INIT_LOG: Finished running weapon_generator_module.")
    else
        _G.log("INIT_LOG: weapon_generator_module module not found, skipping.")
    end
    -- =====================================================================================

    _G.log("INIT_LOG: Primary DO_ONCE hook finished.")
end)


-- =====================================================================================
-- POSTPROCESS PHASE: FINAL WRAP-UP
-- =====================================================================================
table.insert(postprocess, function()
    if not random_object_parameters.main_world_randoms then return end
    _G.log("INIT_LOG: Starting POSTPROCESS phase for final item/reaction generation.")

    _G.log("INIT_LOG: Executing item and reaction generator hook...")
    if universal_item_and_reaction_generators_module and universal_item_and_reaction_generators_module.postprocess then
        pcall(universal_item_and_reaction_generators_module.postprocess.generate_all_transformation_items)
    end
    _G.log("INIT_LOG: Item/reaction hook finished.")
    _G.log("INIT_LOG: POSTPROCESS phase complete.")
end)

_G.log("INIT_LOG: Master init.lua script fully loaded and all hooks registered.")
