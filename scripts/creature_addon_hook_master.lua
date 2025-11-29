local M = {}

-- ============================================================================
-- 1. ADDON REGISTRY
-- Define your modules here. The engine will loop through this list.
-- ============================================================================
local registry = {
    {
        name = "difficulty",
        path = "rules.difficulty_calculator",
        token_func = "get_difficulty_token", 
        desc_func = "get_description_string", -- Adds "THREAT_RANK= X/"
    },
    {
        name = "building_destroyer",
        path = "rules.buildingdestroyer_calculator",
        token_func = "get_buildingdestroyer_token",
    },
    {
        name = "max_age",
        path = "rules.maxage_calculator",
        token_func = "get_maxage_token",
    },
    {
        name = "pet_value",
        path = "rules.petvalue_calculator",
        token_func = "get_petvalue_token",
    },
    {
        name = "trade_capacity",
        path = "rules.tradecapacity_calculator",
        token_func = "get_trade_capacity_token",
    },
    {
        name = "population",
        path = "rules.population_calculator",
        token_func = "get_population_token",
    },
    {
        name = "megabeast",
        path = "rules.megabeast_calculator",
        token_func = "get_megabeast_token",
    },
    {
        name = "existential",
        path = "rules.existential_variant_rules",
        token_func = "get_existential_token",
    },
    {
        name = "rating_tokens",
        path = "rules.rating_token_rules",
        token_func = "get_rating_tokens",
        is_list = true -- Returns a table of strings
    },
    {
        name = "natural_skills",
        path = "rules.natural_skill_calculator",
        token_func = "get_natural_skill_tokens",
        is_list = true -- Returns a table or multiline string handled by engine split
    },
    {
        name = "avatar_spheres",
        path = "rules.avatar_sphere_rules",
        token_func = "get_sphere_tokens",
        is_list = true
    }
}

-- ============================================================================
-- 2. INITIALIZATION
-- Loads all modules safely.
-- ============================================================================
local loaded_modules = {}

function M.init()
    if M._initialized then return end
    
    local log_func = _G.log or print
    -- log_func("ADDON_MASTER: Initializing creature extensions...")

    for _, addon in ipairs(registry) do
        local success, module = pcall(require, addon.path)
        if success and module then
            loaded_modules[addon.name] = module
        else
            log_func("ADDON_MASTER: Failed to load " .. addon.name .. " at " .. addon.path)
        end
    end
    
    M._initialized = true
end

-- ============================================================================
-- 3. TOKEN COLLECTOR
-- Iterates through all loaded modules and gathers RAW tokens.
-- ============================================================================
function M.collect_tokens(config, components)
    M.init() -- Ensure loaded
    local collected_lines = {}

    for _, addon in ipairs(registry) do
        local module = loaded_modules[addon.name]
        
        if module and addon.token_func and module[addon.token_func] then
            -- Call the specific function defined in the registry
            local result = module[addon.token_func](config, components)

            if result then
                if type(result) == "table" then
                    -- Handle modules that return a list of strings
                    for _, line in ipairs(result) do
                        if line ~= "" then table.insert(collected_lines, line) end
                    end
                elseif type(result) == "string" and result ~= "" then
                    -- Handle standard single-string returns (e.g. [DIFFICULTY:5])
                    table.insert(collected_lines, result)
                end
            end
        end
    end

    return collected_lines
end

-- ============================================================================
-- 4. DESCRIPTION MODIFIER
-- Handles the specific text injection (e.g., THREAT_RANK)
-- ============================================================================
function M.append_description_info(description_parts_table, config, components)
    M.init()
    
    for _, addon in ipairs(registry) do
        local module = loaded_modules[addon.name]
        
        -- Check if this addon has a description hook defined in registry
        if module and addon.desc_func and module[addon.desc_func] then
            local text_to_add = module[addon.desc_func](config, components)
            
            if text_to_add and text_to_add ~= "" then
                table.insert(description_parts_table, text_to_add)
            end
        end
    end
end

return M