-- run_civ_generators.lua
-- A standalone script to trigger the dynamic civilization generators.

-- ============================================================================
-- 1. ENVIRONMENT SETUP & MOCKING
-- ============================================================================

-- Add current directory to package path
local function add_current_dir_to_path()
    local info = debug.getinfo(1, "S")
    if info and info.source then 
        local script_path = info.source:match("@?(.*/)")
        if script_path then
            package.path = script_path .. "?.lua;" .. script_path .. "scripts/?.lua;" .. package.path
        end
    end
    -- Also try generic current dir
    package.path = "./?.lua;./scripts/?.lua;" .. package.path
end
add_current_dir_to_path()

-- Mock Global Tables required by the engine
_G.materials = {}
_G.items = {}
_G.languages = {}
_G.creatures = {}
_G.interactions = {}
_G.entities = {}
_G.preprocess = {}
_G.do_once = {}
_G.postprocess = {}
_G.do_once_early = {}

-- Mock Globals provided by DF
_G.df = {} 
_G.world = { year = 100 }
_G.random_object_parameters = { main_world_randoms = true }

-- Setup Logging
_G.log = function(...)
    print(table.concat({...}, "\t"))
end

-- Mock Raws registry functions
_G.raws = {
    register_creatures = function(lines) 
        -- _G.log("[MOCK] Registered " .. #lines .. " creature lines.") 
    end,
    register_entities = function(lines)
        -- _G.log("[MOCK] Registered " .. #lines .. " entity lines.")
        -- Optional: Dump to file for inspection
        local file = io.open("generated_entities_debug.txt", "a")
        if file then
            for _, l in ipairs(lines) do file:write(l .. "\n") end
            file:close()
        end
    end,
    register_languages = function(lines) end,
    register_interactions = function(lines) end,
    register_inorganics = function(lines) end,
    register_reactions = function(lines) end,
}

_G.log("SYSTEM: Environment mocked successfully.")

-- ============================================================================
-- 2. LOAD DEPENDENCIES
-- ============================================================================

local function safe_require(module_name)
    local success, module = pcall(require, module_name)
    if success then
        return module
    else
        _G.log("ERROR: Could not load module '" .. module_name .. "': " .. tostring(module))
        return nil
    end
end

-- Load Engines (We skip creature_generator_engine for the dummy run)
-- local creature_engine = safe_require("creature_generator_engine")
local civ_gen = safe_require("dynamic_civilization_generator")
local invasion_gen = safe_require("dynamic_invasion_generator")
local tribe_gen = safe_require("dynamic_tribe_generator")

-- ============================================================================
-- 3. GENERATE DUMMY DATA (MOCKED CREATURES)
-- ============================================================================

local combined_generated_creature_data = {}
local DUMMY_COUNT_PER_ARCHETYPE = 50 -- Adjust this number for scale

-- List of Archetypes to simulate
local target_archetypes = {
    "NUCASTE",
    "EXCASTE",
    "BIOMACHINE",
    "CYBERMACHINE",
    "NECROMACHINE",
    "NANOMACHINE",
    "CHIMERA"
}

_G.log("SYSTEM: Generating " .. (DUMMY_COUNT_PER_ARCHETYPE * #target_archetypes) .. " dummy creatures for testing...")

local counter = 1

for _, archetype in ipairs(target_archetypes) do
    for i = 1, DUMMY_COUNT_PER_ARCHETYPE do
        
        -- Create a dummy ID
        local id = string.format("%s_ID_DUMMY_%04d", archetype, counter)
        
        -- Construct minimal components structure required by civ generators
        -- Civ generators usually look for:
        -- creature.id
        -- creature.components.rating.tags (Must contain "SOPHONT")
        -- creature.components.size_variant.size_tags (e.g. "MEDIUM", "LARGE")
        
        local dummy_obj = {
            id = id,
            creature = { "[CREATURE:" .. id .. "]", "[NAME:dummy " .. archetype .. ":dummies:dummy]" }, -- Minimal raw lines
            components = {
                rating = {
                    tags = { "SOPHONT" } -- Force SOPHONT so civ generator picks it up
                },
                size_variant = {
                    size_tags = { "MEDIUM" } -- Default to medium
                },
                -- Add empty tables for other components to prevent nil indexing
                component_1 = {},
                component_2 = {},
                component_3 = {}
            }
        }
        
        -- Vary the tags slightly for better test coverage
        if i % 3 == 0 then
            table.insert(dummy_obj.components.rating.tags, "HOSTILE")
        elseif i % 3 == 1 then
            table.insert(dummy_obj.components.rating.tags, "BENIGN")
        end
        
        if i % 4 == 0 then
             dummy_obj.components.size_variant.size_tags = { "LARGE" }
        end

        table.insert(combined_generated_creature_data, dummy_obj)
        counter = counter + 1
    end
end

_G.log("SYSTEM: Dummy data generation complete.")

-- ============================================================================
-- 4. EXECUTE CIVILIZATION GENERATORS
-- ============================================================================

_G.log("\n=== STARTING CIVILIZATION GENERATION ===\n")

-- 1. Main Dynamic Civilizations
if civ_gen then
    _G.log("--- Running Dynamic Civilization Generator ---")
    if civ_gen.prepare_civilization_data_hook then
        civ_gen.prepare_civilization_data_hook(combined_generated_creature_data)
    end
    
    if civ_gen.generate_civilizations_hook then
        civ_gen.generate_civilizations_hook()
    end
    
    if civ_gen.register_all_generated_civilizations then
        civ_gen.register_all_generated_civilizations()
    end
else
    _G.log("WARNING: dynamic_civilization_generator not loaded.")
end

-- 2. Dynamic Invasions
if invasion_gen then
    _G.log("\n--- Running Dynamic Invasion Generator ---")
    if invasion_gen.prepare_civilization_data_hook then
        invasion_gen.prepare_civilization_data_hook(combined_generated_creature_data)
    end
    
    if invasion_gen.generate_civilizations_hook then
        invasion_gen.generate_civilizations_hook()
    end
    
    if invasion_gen.register_all_generated_civilizations then
        invasion_gen.register_all_generated_civilizations()
    end
else
    _G.log("WARNING: dynamic_invasion_generator not loaded.")
end

-- 3. Dynamic Tribes
if tribe_gen then
    _G.log("\n--- Running Dynamic Tribe Generator ---")
    if tribe_gen.prepare_civilization_data_hook then
        tribe_gen.prepare_civilization_data_hook(combined_generated_creature_data)
    end
    
    if tribe_gen.generate_civilizations_hook then
        tribe_gen.generate_civilizations_hook()
    end
    
    if tribe_gen.register_all_generated_civilizations then
        tribe_gen.register_all_generated_civilizations()
    end
else
    _G.log("WARNING: dynamic_tribe_generator not loaded.")
end

_G.log("\n=== EXECUTION COMPLETE ===")
_G.log("Check 'generated_entities_debug.txt' if output was enabled.")