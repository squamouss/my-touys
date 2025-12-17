local function script_log(...)
    if _G.log then _G.log(...) end
end

local M = {}

-- =============================================================================
--  HELPER FUNCTIONS
-- =============================================================================
local function split_to_lines(current_lines_table, raw_block)
    if not raw_block then return current_lines_table end
    
    local content_type = type(raw_block)
    if content_type == 'string' then
        for line in raw_block:gmatch("[^\r\n]+") do
            if line:match("%S") then 
                table.insert(current_lines_table, line)
            end
        end
    elseif content_type == 'table' then
        for _, line in ipairs(raw_block) do
            if type(line) == 'string' and line:match("%S") then
                 table.insert(current_lines_table, line)
            end
        end
    end
    return current_lines_table
end

local function table_merge(t1, t2)
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

local function add_generated_info(lines)
    if _G.add_generated_info then
        _G.add_generated_info(lines)
    else
        table.insert(lines, "[GENERATED]")
    end
end

-- =============================================================================
--  DEFAULTS & CONSTANTS
-- =============================================================================
local MAKE_REACTIONS_FREE_FOR_TESTING = true

-- Multipliers for each tier (Payload Power)
-- Now explicitly defines costs for both modes to ensure visibility and differentiation
local TIER_DATA = {
    PRIMARY     = { value = 500, adv_cost = 40, fort_cost = 1 },
    SECONDARY   = { value = 400, adv_cost = 20, fort_cost = 1 },
    TERTIARY    = { value = 300, adv_cost = 10, fort_cost = 1 },
    QUATERNARY  = { value = 200, adv_cost = 5,  fort_cost = 1 }
}

-- Unlock Probability Configuration
-- Defines the % chance to acquire a specific slot based on the Unlock Tier
local UNLOCK_PROBABILITIES = {
    TIER_1 = { QUATERNARY = 20, TERTIARY = 15, SECONDARY = 10, PRIMARY = 5 },
    TIER_2 = { QUATERNARY = 40, TERTIARY = 30, SECONDARY = 20, PRIMARY = 10 },
    TIER_3 = { QUATERNARY = 80, TERTIARY = 60, SECONDARY = 40, PRIMARY = 20 }
}

-- Default configuration values if not specified in master config
local DEFAULTS = {
    -- Acquisition
    ABILITY_ADV_NAME_TEMPLATE = "Attribute Program- %s", -- %s = buff_name
    ABILITY_WAIT_PERIOD = 2400,
    ABILITY_USAGE_HINT = "DEFEND",
    
    -- Payload
    BUFF_SYNDROME_NAME = "Body Enhancement",
    BUFF_DURATION_TICKS = 10000,
    
    -- Inorganic
    TABLET_TILE = "'#'",
    TABLET_COLOR = "7:11:0",
    
    -- Crafting (Fort)
    FORT_REAGENT_PREFIX = "ITEM_TOOL_TABLET_INCOMPLETE",
    FORT_REAGENT_MATERIAL = "INORGANIC:N_MATTER",
    FORT_BUILDING = "N_MATTER_REFINERY",
    FORT_CATEGORY_ID = "PROGRAM_BODY",
    FORT_CATEGORY_NAME = "Body Programs",
    FORT_CATEGORY_DESC = "Create physical data packets granting users multipliers to various physical attributes.\nAn enhanced body is required to make use of these abilities.",
    
    -- Crafting (Adv)
    ADV_REAGENT_SCRAP = "ITEM_TOOL_SCRAP",
    ADV_REAGENT_MATERIAL = "INORGANIC:N_MATTER",
    ADV_REAGENT_TOOL = "ITEM_TOOL_PORTABLE_SYNTH",
    ADV_CATEGORY_ID = "PROGRAM_BODY_ADV",
    ADV_CATEGORY_NAME = "Body Programs",
    ADV_CATEGORY_DESC = "Attribute enhancers"
}

-- =============================================================================
-- LEVEL MAP CONFIGURATION
-- =============================================================================
local LEVEL_MAP = {
    { key = "PRIMARY", token = "PRIMARY", name = "Primary", syn_class = "PRIMARY", reagent_suffix = "_PRIMARY" },
    { key = "SECONDARY", token = "SECONDARY", name = "Secondary", syn_class = "SECONDARY", reagent_suffix = "_SECONDARY" },
    { key = "TERTIARY", token = "TERTIARY", name = "Tertiary", syn_class = "TERTIARY", reagent_suffix = "_TERTIARY" },
    { key = "QUATERNARY", token = "QUATERNARY", name = "Quaternary", syn_class = "QUATERNARY", reagent_suffix = "_QUATERNARY" }
}

-- =============================================================================
--  DYNAMIC PAYLOAD GENERATOR
-- =============================================================================
local function get_payload_string(config, level_key)
    local tier_info = TIER_DATA[level_key]
    local value = tier_info.value
    local duration = config.BUFF_DURATION_TICKS or DEFAULTS.BUFF_DURATION_TICKS
    
    -- DWF_STRETCH:144 added for Adventure Mode parity
    local stretch = ":DWF_STRETCH:144"

    if config.type == "PHYSICAL" then
        return string.format("[CE_PHYS_ATT_CHANGE:%s:%d:0:START:0:END:%d%s]", 
            config.id, value, duration, stretch)
            
    elseif config.type == "MENTAL" then
        return string.format("[CE_MENT_ATT_CHANGE:%s:%d:0:START:0:END:%d%s]", 
            config.id, value, duration, stretch)
            
    elseif config.type == "SPEED" then
        return string.format("[CE_SPEED_CHANGE:SPEED_PERC:%d:ABRUPT:START:0:END:%d%s]", 
            value, duration, stretch)
            
    else
        script_log("ATTR_GEN: Unknown type '"..tostring(config.type).."' for " .. config.id)
        return ""
    end
end

-- =============================================================================
-- ### RAW BUILDER FUNCTIONS ###
-- =============================================================================

-- 1. Builds the Payload Interaction
local function build_payload_interaction(config, level)
    local lines = {}
    local interaction_id = string.format("%s_%s", config.payload_prefix, level.token)
    
    table.insert(lines, string.format("[INTERACTION:%s]", interaction_id))
    add_generated_info(lines)
    
    local static_raws = [[
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]
        [IT_MANUAL_INPUT:target]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [SYNDROME]
]]
    table_merge(lines, split_to_lines({}, static_raws))

    -- Name
    local syn_name = config.BUFF_SYNDROME_NAME or DEFAULTS.BUFF_SYNDROME_NAME
    table.insert(lines, string.format("            [SYN_NAME:%s]", syn_name))

    -- Effect (Generated dynamically)
    local effect_string = get_payload_string(config, level.key)
    table.insert(lines, string.format("            %s", effect_string))
    
    return lines
end

-- 2. Builds the Inorganic Tablet
local function build_inorganic_tablet(config, level)
    local lines = {}
    local inorganic_id = string.format("%s_%s_PROGRAM", config.id_prefix, level.token)
    local tablet_name_adj = string.format("%s %s core implant", level.name:lower(), config.buff_noun)
    local meat_name = string.format("%s %s enhancement tablet", level.name:lower(), config.buff_noun)
    
    -- Defaults retrieval
    local ability_name = string.format(DEFAULTS.ABILITY_ADV_NAME_TEMPLATE, config.buff_name)
    local verb = config.verbs[level.key] or "perform a generic buff:performs a generic buff:NA"
    local wait_period = config.ABILITY_WAIT_PERIOD or DEFAULTS.ABILITY_WAIT_PERIOD
    local tile = config.TABLET_TILE or DEFAULTS.TABLET_TILE
    local color = config.TABLET_COLOR or DEFAULTS.TABLET_COLOR
    local usage_hint = config.usage_hint or DEFAULTS.ABILITY_USAGE_HINT

    table.insert(lines, string.format("[INORGANIC:%s]", inorganic_id))
    add_generated_info(lines)

    local rest_of_raw = string.format([[
    [USE_MATERIAL_TEMPLATE:MUSCLE_TABLET_TEMPLATE][MEAT][SPECIAL]
    [STATE_NAME_ADJ:ALL_SOLID:%s][DISPLAY_COLOR:%s][TILE:%s]
    [MELTING_POINT:12070]
    [SOLID_DENSITY:400]
    [MEAT_NAME:NONE:%s:%s]
    [SYNDROME]
        [SYN_INGESTED]
        [CE_DISPLAY_NAME:NAME:transmuter:transmuters:transmuter:START:0]
        [SYN_CLASS:%s][SYN_IMMUNE_CLASS:%s]
        [SYN_CLASS:%s][SYN_IMMUNE_CLASS:%s]
    [CE_CAN_DO_INTERACTION:PROB:100:START:0:ABRUPT]
        [CDI:ADV_NAME:%s]
        [CDI:TARGET:A:SELF_ONLY]
        [CDI:INTERACTION:%s_%s]
        [CDI:USAGE_HINT:%s]
        [CDI:MAX_TARGET_NUMBER:A:1]
        [CDI:VERB:%s]
        [CDI:WAIT_PERIOD:%d]
]],
        tablet_name_adj, color, tile,
        meat_name, meat_name,
        config.id_prefix, config.id_prefix,
        level.syn_class, level.syn_class,
        ability_name,
        config.payload_prefix, level.token,
        usage_hint,
        verb,
        wait_period
    )
    
    table_merge(lines, split_to_lines({}, rest_of_raw))
    return lines
end

-- 3. Builds the Secret Interaction
local function build_secret_interaction(config, level)
    local lines = {}
    local interaction_id = string.format("%s_%s_SECRET", config.secret_prefix, level.token)
    local hist_string = string.format("who gained %s Body Enhancement- %s from them", level.name, config.buff_name)
    local secret_name = string.format("the %s Body Enhancement- %s", level.name, config.buff_name)
    local arena_name = string.format("%s %s", level.name, config.buff_name)
    
    -- Defaults retrieval
    local ability_name = string.format(DEFAULTS.ABILITY_ADV_NAME_TEMPLATE, config.buff_name)
    local verb = config.verbs[level.key] or "perform a generic buff:performs a generic buff:NA"
    local wait_period = config.ABILITY_WAIT_PERIOD or DEFAULTS.ABILITY_WAIT_PERIOD
    local usage_hint = config.usage_hint or DEFAULTS.ABILITY_USAGE_HINT

    table.insert(lines, string.format("[INTERACTION:%s]", interaction_id))
    add_generated_info(lines)

    local rest_of_raw = string.format([[
    [I_SOURCE:DEITY]
        [IS_USAGE_HINT:MAJOR_CURSE]
        [IS_HIST_STRING_1: the infodeity was challenged in the Datasphere by ]
        [IS_HIST_STRING_2: %s]
    [I_SOURCE:SECRET]
        [IS_NAME:%s]
        [IS_SECRET_GOAL:IMMORTALITY]
        [IS_SECRET:SUPERNATURAL_LEARNING_POSSIBLE]
        [IS_SECRET:MUNDANE_RECORDING_POSSIBLE:BOOK_INSTRUCTION:SECRET_CORE]
    [I_SOURCE:INGESTION]
        [IS_HIST_STRING_1: consumed the nanite-infused blood of ]
        [IS_HIST_STRING_2: and gained their power]
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_REQUIRES:CAN_LEARN]
        [IT_REQUIRES:CAN_SPEAK]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:%s]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:%s]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [IE_ARENA_NAME:%s]
        [SYNDROME]
            [SYN_CLASS:%s][SYN_CLASS:%s]
            [CE_DISPLAY_NAME:NAME:transmuter:transmuters:transmuter:START:0]
            [CE_BODY_MAT_INTERACTION:MAT_TOKEN:RESERVED_BLOOD:START:0]
                [CE:INTERACTION:%s]
                [CE:SYNDROME_TAG:SYN_INJECTED]
            [CE_CAN_DO_INTERACTION:PROB:100:START:0:ABRUPT]
                [CDI:ADV_NAME:%s]
                [CDI:TARGET:A:SELF_ONLY]
                [CDI:INTERACTION:%s_%s]
                [CDI:USAGE_HINT:%s]
                [CDI:MAX_TARGET_NUMBER:A:1]
                [CDI:VERB:%s]
                [CDI:WAIT_PERIOD:%d]
]],
        hist_string, secret_name,
        config.id_prefix, level.syn_class,
        arena_name,
        config.id_prefix, level.syn_class,
        interaction_id,
        ability_name,
        config.payload_prefix, level.token,
        usage_hint,
        verb,
        wait_period
    )
    
    table_merge(lines, split_to_lines({}, rest_of_raw))
    return lines
end

-- 4. Builds the Fortress Reaction
local function build_fortress_reaction(config, level, is_first)
    local lines = {}
    local reaction_id = string.format("%s_%s_PROGRAM", config.id_prefix, level.token)
    local reaction_name = string.format("Body Enhancement- %s- %s", config.buff_name, level.name)
    local product = string.format("PRODUCT:100:1:MEAT:NONE:INORGANIC:%s_%s_PROGRAM", config.id_prefix, level.token)
    local description = string.format("An edible tablet that grants an eligible life form an ability that enhances %s (%s).", config.buff_noun, level.name)
    
    -- Defaults retrieval
    local reagent_prefix = config.FORT_REAGENT_PREFIX or DEFAULTS.FORT_REAGENT_PREFIX
    local reagent_mat = config.FORT_REAGENT_MATERIAL or DEFAULTS.FORT_REAGENT_MATERIAL
    local building = config.FORT_BUILDING or DEFAULTS.FORT_BUILDING
    local category_id = config.FORT_CATEGORY_ID or DEFAULTS.FORT_CATEGORY_ID
    local category_name = config.FORT_CATEGORY_NAME or DEFAULTS.FORT_CATEGORY_NAME
    local category_desc = config.FORT_CATEGORY_DESC or DEFAULTS.FORT_CATEGORY_DESC
    
    -- Explicitly get Fortress Cost from TIER_DATA
    local fort_cost = TIER_DATA[level.key].fort_cost

    local reagent_line = ""
    if not MAKE_REACTIONS_FREE_FOR_TESTING then
        local reagent = string.format("blank tablet:%d:TOOL:%s%s:%s", fort_cost, reagent_prefix, level.reagent_suffix, reagent_mat)
        reagent_line = string.format("[REAGENT:%s]", reagent)
    end

    table.insert(lines, string.format("[REACTION:%s]", reaction_id))
    add_generated_info(lines)
    
    local rest_of_raw = string.format([[
    [NAME:%s]
    [FORTRESS_MODE_ENABLED][BUILDING:%s:NONE]
    %s
    [%s]
    [SKILL:EXTRACT_STRAND]
    [DESCRIPTION:%s]
    [CATEGORY:%s]
]],
        reaction_name, building, reagent_line, product, description, category_id
    )
    
    table_merge(lines, split_to_lines({}, rest_of_raw))
    
    if is_first then
        table.insert(lines, string.format("    [CATEGORY_NAME:%s]", category_name))
        table.insert(lines, string.format("    [CATEGORY_DESCRIPTION:%s]", category_desc))
    end
    
    return lines
end

-- 5. Builds the Adventure Reaction
local function build_adventure_reaction(config, level, is_first)
    local lines = {}
    local reaction_id = string.format("%s_%s_PROGRAM_ADV", config.id_prefix, level.token)
    local reaction_name = string.format("Body Enhancement- %s- %s", config.buff_name, level.name)
    local product = string.format("PRODUCT:100:1:MEAT:NONE:INORGANIC:%s_%s_PROGRAM", config.id_prefix, level.token)
    local description = string.format("An edible tablet that grants an eligible life form an ability that enhances %s (%s).", config.buff_noun, level.name)

    -- Defaults retrieval
    local scrap_tool = config.ADV_REAGENT_SCRAP or DEFAULTS.ADV_REAGENT_SCRAP
    local scrap_mat = config.ADV_REAGENT_MATERIAL or DEFAULTS.ADV_REAGENT_MATERIAL
    local tool = config.ADV_REAGENT_TOOL or DEFAULTS.ADV_REAGENT_TOOL
    local category_id = config.ADV_CATEGORY_ID or DEFAULTS.ADV_CATEGORY_ID
    local category_name = config.ADV_CATEGORY_NAME or DEFAULTS.ADV_CATEGORY_NAME
    local category_desc = config.ADV_CATEGORY_DESC or DEFAULTS.ADV_CATEGORY_DESC
    
    -- Explicitly get Adventure Cost from TIER_DATA
    local adv_cost = TIER_DATA[level.key].adv_cost

    local reagent_scrap_line = ""
    local reagent_tool_line = ""
    if not MAKE_REACTIONS_FREE_FOR_TESTING then
        local reagent_scrap = string.format("scrap:%d:TOOL:%s:%s", adv_cost, scrap_tool, scrap_mat)
        local reagent_tool = string.format("tool:1:TOOL:%s:NONE:NONE][PRESERVE_REAGENT]", tool)
        
        reagent_scrap_line = string.format("[REAGENT:%s]", reagent_scrap)
        reagent_tool_line = string.format("[REAGENT:%s]", reagent_tool)
    end

    table.insert(lines, string.format("[REACTION:%s]", reaction_id))
    add_generated_info(lines)

    local rest_of_raw = string.format([[
    [NAME:%s]
    [ADVENTURE_MODE_ENABLED]
    %s
    %s
    [%s]
    [SKILL:EXTRACT_STRAND]
    [DESCRIPTION:%s]
    [CATEGORY:%s]
]],
        reaction_name, reagent_scrap_line, reagent_tool_line, product, description, category_id
    )
    
    table_merge(lines, split_to_lines({}, rest_of_raw))
    
    if is_first then
        table.insert(lines, string.format("    [CATEGORY_NAME:%s]", category_name))
        table.insert(lines, string.format("    [CATEGORY_DESCRIPTION:%s]", category_desc))
    end
    
    return lines
end

-- =============================================================================
--  UNLOCK SYSTEM BUILDERS
-- =============================================================================

-- 6. Builds Specific Unlock (e.g. AGILITY_UNLOCK_TIER_1)
local function build_specific_unlocks(config)
    local lines = {}
    
    -- Iterate Tier 1, 2, 3
    for tier_name, probs in pairs(UNLOCK_PROBABILITIES) do
        local interaction_id = string.format("%s_UNLOCK_%s", config.id_prefix, tier_name)
        
        table.insert(lines, string.format("[INTERACTION:%s]", interaction_id))
        add_generated_info(lines)
        
        local header = [[
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
]]
        table_merge(lines, split_to_lines({}, header))
        
        -- Loop through PRIMARY...QUATERNARY slots
        for _, level in ipairs(LEVEL_MAP) do
            local prob = probs[level.key] or 0
            
            -- Defaults retrieval for this level
            local ability_name = string.format(DEFAULTS.ABILITY_ADV_NAME_TEMPLATE, config.buff_name)
            local verb = config.verbs[level.key] or "perform a generic buff:performs a generic buff:NA"
            local wait_period = config.ABILITY_WAIT_PERIOD or DEFAULTS.ABILITY_WAIT_PERIOD
            local usage_hint = config.usage_hint or DEFAULTS.ABILITY_USAGE_HINT
            
            local synd_block = string.format([[
        [SYNDROME]
            [SYN_CLASS:%s][SYN_IMMUNE_CLASS:%s]
            [SYN_CLASS:%s][SYN_IMMUNE_CLASS:%s]
            [CE_CAN_DO_INTERACTION:PROB:%d:START:0:ABRUPT]
                [CDI:ADV_NAME:%s]
                [CDI:TARGET:A:SELF_ONLY]
                [CDI:INTERACTION:%s_%s]
                [CDI:USAGE_HINT:%s]
                [CDI:MAX_TARGET_NUMBER:A:1]
                [CDI:VERB:%s]
                [CDI:WAIT_PERIOD:%d]
]],
            level.syn_class, level.syn_class, -- e.g. PRIMARY
            config.id_prefix, config.id_prefix, -- e.g. ENHANCEAGILITY
            prob,
            ability_name,
            config.payload_prefix, level.token,
            usage_hint,
            verb,
            wait_period
            )
            table_merge(lines, split_to_lines({}, synd_block))
        end
    end
    
    return lines
end

-- 7. Builds Universal Unlock (ALL_ATTRIBUTES_UNLOCK) using Tier 1 logic
local function build_universal_unlock(loaded_configs)
    local lines = {}
    local tier_probs = UNLOCK_PROBABILITIES.TIER_1 -- Force Tier 1 Logic
    
    table.insert(lines, "[INTERACTION:ALL_ATTRIBUTES_UNLOCK]")
    add_generated_info(lines)
    
    local header = [[
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
]]
    table_merge(lines, split_to_lines({}, header))
    
    if loaded_configs then
        for _, config in ipairs(loaded_configs) do
            -- Loop slots for this attribute
            for _, level in ipairs(LEVEL_MAP) do
                local prob = tier_probs[level.key] or 0
                
                -- Defaults retrieval
                local ability_name = string.format(DEFAULTS.ABILITY_ADV_NAME_TEMPLATE, config.buff_name)
                local verb = config.verbs[level.key] or "perform a generic buff:performs a generic buff:NA"
                local wait_period = config.ABILITY_WAIT_PERIOD or DEFAULTS.ABILITY_WAIT_PERIOD
                local usage_hint = config.usage_hint or DEFAULTS.ABILITY_USAGE_HINT
                
                local synd_block = string.format([[
        [SYNDROME]
            [SYN_CLASS:%s][SYN_IMMUNE_CLASS:%s]
            [SYN_CLASS:%s][SYN_IMMUNE_CLASS:%s]
            [CE_CAN_DO_INTERACTION:PROB:%d:START:0:ABRUPT]
                [CDI:ADV_NAME:%s]
                [CDI:TARGET:A:SELF_ONLY]
                [CDI:INTERACTION:%s_%s]
                [CDI:USAGE_HINT:%s]
                [CDI:MAX_TARGET_NUMBER:A:1]
                [CDI:VERB:%s]
                [CDI:WAIT_PERIOD:%d]
]],
                level.syn_class, level.syn_class, -- e.g. PRIMARY
                config.id_prefix, config.id_prefix, -- e.g. ENHANCEAGILITY
                prob,
                ability_name,
                config.payload_prefix, level.token,
                usage_hint,
                verb,
                wait_period
                )
                table_merge(lines, split_to_lines({}, synd_block))
            end
        end
    end
    
    return lines
end

-- 8. Builds Physical/Speed Unlock (PHYSICAL_SPEED_UNLOCK) using Tier 1 logic
local function build_physical_speed_unlock(loaded_configs)
    local lines = {}
    local tier_probs = UNLOCK_PROBABILITIES.TIER_1 -- Force Tier 1 Logic
    
    table.insert(lines, "[INTERACTION:PHYSICAL_SPEED_UNLOCK]")
    add_generated_info(lines)
    
    local header = [[
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
]]
    table_merge(lines, split_to_lines({}, header))
    
    if loaded_configs then
        for _, config in ipairs(loaded_configs) do
            -- Filter logic: Only Physical or Speed
            if config.type == "PHYSICAL" or config.type == "SPEED" then
                -- Loop slots for this attribute
                for _, level in ipairs(LEVEL_MAP) do
                    local prob = tier_probs[level.key] or 0
                    
                    -- Defaults retrieval
                    local ability_name = string.format(DEFAULTS.ABILITY_ADV_NAME_TEMPLATE, config.buff_name)
                    local verb = config.verbs[level.key] or "perform a generic buff:performs a generic buff:NA"
                    local wait_period = config.ABILITY_WAIT_PERIOD or DEFAULTS.ABILITY_WAIT_PERIOD
                    local usage_hint = config.usage_hint or DEFAULTS.ABILITY_USAGE_HINT
                    
                    local synd_block = string.format([[
        [SYNDROME]
            [SYN_CLASS:%s][SYN_IMMUNE_CLASS:%s]
            [SYN_CLASS:%s][SYN_IMMUNE_CLASS:%s]
            [CE_CAN_DO_INTERACTION:PROB:%d:START:0:ABRUPT]
                [CDI:ADV_NAME:%s]
                [CDI:TARGET:A:SELF_ONLY]
                [CDI:INTERACTION:%s_%s]
                [CDI:USAGE_HINT:%s]
                [CDI:MAX_TARGET_NUMBER:A:1]
                [CDI:VERB:%s]
                [CDI:WAIT_PERIOD:%d]
]],
                    level.syn_class, level.syn_class, -- e.g. PRIMARY
                    config.id_prefix, config.id_prefix, -- e.g. ENHANCEAGILITY
                    prob,
                    ability_name,
                    config.payload_prefix, level.token,
                    usage_hint,
                    verb,
                    wait_period
                    )
                    table_merge(lines, split_to_lines({}, synd_block))
                end
            end
        end
    end
    
    return lines
end

-- =============================================================================
-- ### MAIN GENERATOR FUNCTIONS ###
-- =============================================================================

local function GenerateStatSystem(config, interaction_buffer, inorganic_buffer, reaction_buffer)
    script_log("Generating buff system: " .. config.buff_name)
    
    -- 1. Standard Components (Payload, Secret, Tablet, Reactions)
    for i, level_data in ipairs(LEVEL_MAP) do
        local is_first_in_list = (i == 1)
        
        local payload = build_payload_interaction(config, level_data)
        table_merge(interaction_buffer, payload)
        
        local secret = build_secret_interaction(config, level_data)
        table_merge(interaction_buffer, secret)
        
        local inorganic = build_inorganic_tablet(config, level_data)
        table_merge(inorganic_buffer, inorganic)
        
        local f_react = build_fortress_reaction(config, level_data, is_first_in_list)
        table_merge(reaction_buffer, f_react)
        
        local a_react = build_adventure_reaction(config, level_data, is_first_in_list)
        table_merge(reaction_buffer, a_react)
    end
    
    -- 2. Specific Unlockers (Tier 1, 2, 3)
    local unlocks = build_specific_unlocks(config)
    table_merge(interaction_buffer, unlocks)
end

function M.generate_all_custom_buff_systems(loaded_configs)
    script_log("--- Generating All Custom Stat Systems (Attribute Module) ---")

    if MAKE_REACTIONS_FREE_FOR_TESTING then
        script_log("WARNING: MAKE_REACTIONS_FREE_FOR_TESTING is TRUE. All attribute reactions will be free.")
    end

    local master_interaction_buffer = {}
    local master_inorganic_buffer = {}
    local master_reaction_buffer = {}

    -- Handle loading: loaded_configs is now the single master list table
    if loaded_configs then
        for _, config_entry in ipairs(loaded_configs) do
            GenerateStatSystem(config_entry, master_interaction_buffer, master_inorganic_buffer, master_reaction_buffer)
        end
        
        -- 3. Universal Unlocker (Tier 1 logic only)
        script_log("ATTR_GEN: Generating Global Attribute Unlocker...")
        local universal = build_universal_unlock(loaded_configs)
        table_merge(master_interaction_buffer, universal)

        -- 4. Physical/Speed Unlocker (Tier 1 logic only)
        script_log("ATTR_GEN: Generating Physical/Speed Attribute Unlocker...")
        local phys_speed = build_physical_speed_unlock(loaded_configs)
        table_merge(master_interaction_buffer, phys_speed)
    end

    -- Batch Register
    if #master_interaction_buffer > 0 then
        script_log("ATTR_GEN: Batch registering " .. #master_interaction_buffer .. " interaction lines...")
        if _G.raws and _G.raws.register_interactions then
            _G.raws.register_interactions(master_interaction_buffer)
        end
    end

    if #master_inorganic_buffer > 0 then
        script_log("ATTR_GEN: Batch registering " .. #master_inorganic_buffer .. " inorganic lines...")
        if _G.raws and _G.raws.register_inorganics then
            _G.raws.register_inorganics(master_inorganic_buffer)
        end
    end

    if #master_reaction_buffer > 0 then
        script_log("ATTR_GEN: Batch registering " .. #master_reaction_buffer .. " reaction lines...")
        if _G.raws and _G.raws.register_reactions then
            _G.raws.register_reactions(master_reaction_buffer)
        end
    end
    
    script_log("--- Custom Attribute System Generation (Attribute Module) COMPLETE ---")
end

return M