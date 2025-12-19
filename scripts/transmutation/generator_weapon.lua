local M = {}

local function script_log(...)
    if _G.log then _G.log(...) end
end

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
    if _G.add_generated_info then _G.add_generated_info(lines)
    else table.insert(lines, "[GENERATED]") end
end

-- =============================================================================
--  1. FINAL ATTACK GENERATION (The Effect Syndrome)
--  ID Structure: (NAME)_SEV_(X)_FINAL or (NAME)_SEV_(X)_FINAL_SELF
-- =============================================================================
local function generate_final_attack(config, ability_key, sev_lvl, is_self_optimized)
    local ability_list = config.ABILITY_TYPES or config.ABILITIES
    local ability = ability_list[ability_key]
    
    local id_suffix = is_self_optimized and "_FINAL_SELF" or "_FINAL"
    local id = string.format("%s_SEV_%d%s", ability.token_prefix, sev_lvl, id_suffix)
    local lines = {}
    
    -- DURATION LOGIC
    -- Now handled explicitly by the config entry (ability.duration).
    -- Defaults to 1000 ticks if not specified in the config.
    local effect_duration = ability.duration or 1000
    
    table.insert(lines, "[INTERACTION:" .. id .. "]")
    add_generated_info(lines)
    
    -- =========================================================================
    -- LOGIC A: STANDARD (Hard Block / Non-Soakable / Guard)
    -- Applied to DEFENSE (Guard) or OFFENSE without soak (Hack)
    -- =========================================================================
    if ability.role == "DEFENSE" or (ability.role == "OFFENSE" and not ability.soak) then
        
        -- Logic Change: Only include Manual Input if NOT self-optimized
        local manual_input_line = is_self_optimized and "" or "[IT_MANUAL_INPUT:target]"
        
        local base_target = string.format([[
    [I_TARGET:C:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        %s
]], manual_input_line)
        table_merge(lines, split_to_lines({}, base_target))

        -- Hard Filtering: Block completely if Shield (FIREWALL) or Robustness (INNATE) is >= Attack
        if ability.role == "OFFENSE" then
            -- Check Active Shield (Syndrome Class)
            for i = sev_lvl, config.MAX_POWER_LEVEL do
                 table.insert(lines, "        [IT_CANNOT_HAVE_SYNDROME_CLASS:FIREWALL_" .. i .. "]")
            end
            -- Check Innate Robustness (Creature Class)
            for i = sev_lvl, config.MAX_POWER_LEVEL do
                 table.insert(lines, "        [IT_IMMUNE_CLASS:INNATE_FIREWALL_" .. i .. "]")
            end
            table.insert(lines, "        [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]")
        
        elseif ability.role == "DEFENSE" then
            -- Defense Redundancy Check
            -- Prevent applying Guard if target has Innate Firewall >= Severity
            for i = sev_lvl, config.MAX_POWER_LEVEL do
                 table.insert(lines, "        [IT_IMMUNE_CLASS:INNATE_FIREWALL_" .. i .. "]")
            end
        end

        local effect_base = [[
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:C]
        [IE_IMMEDIATE]
        [SYNDROME]
]]
        table_merge(lines, split_to_lines({}, effect_base))
        
        if ability.role == "DEFENSE" then
            -- Defense (Guard) applies the Shield class
            table.insert(lines, "            [SYN_CLASS:FIREWALL_" .. sev_lvl .. "]")
            
            local tile = config.SEVERITY_SYMBOLS[sev_lvl] or 249
            -- Synced CE_FLASH_TILE and CE_PHYS_ATT_CHANGE to effect_duration
            local defense_effects = string.format([[
            [CE_FLASH_TILE:TILE:%d:7:0:1:FREQUENCY:2000:1000:START:0:END:%d]
            [CE_PHYS_ATT_CHANGE:DISEASE_RESISTANCE:200:100:START:0:END:%d]
]], tile, effect_duration, effect_duration)
            table_merge(lines, split_to_lines({}, defense_effects))
            
        elseif ability.role == "OFFENSE" then
             if ability.injects_silence then
                 table.insert(lines, "            [SYN_CLASS:" .. config.SILENCE_CLASS .. "]")
            end
            if ability.speed_penalty_base then
                local final_speed = 100 - (10 * sev_lvl) 
                if final_speed < 10 then final_speed = 10 end
                -- Synced Speed Change to effect_duration
                table.insert(lines, "            [CE_SPEED_CHANGE:SPEED_PERC:"..final_speed..":ABRUPT:START:0:END:"..effect_duration.."]")
            end
            local tile = config.SEVERITY_SYMBOLS[sev_lvl] or 249
            local color = config.COLORS.OFFENSE or "4:0:0"
            -- Synced CE_FLASH_TILE and Dummy CE_PHYS_ATT_CHANGE to effect_duration
            local offense_effects = string.format([[
            [CE_FLASH_TILE:TILE:%d:%s:FREQUENCY:2000:1000:START:0:END:%d]
            [CE_PHYS_ATT_CHANGE:DISEASE_RESISTANCE:100:100:START:0:END:%d]
]], tile, color, effect_duration, effect_duration)
            table_merge(lines, split_to_lines({}, offense_effects))
        end

    -- =========================================================================
    -- LOGIC B: SOAK SYSTEM (Robustness Filtering)
    -- Attack must pass Active Shield (Guard), then is soaked by Innate Firewall.
    -- =========================================================================
    elseif ability.role == "OFFENSE" and ability.soak then
        
        local manual_input_line = is_self_optimized and "" or "[IT_MANUAL_INPUT:target]"
        local base_target = string.format([[
    [I_TARGET:C:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        %s
]], manual_input_line)
        table_merge(lines, split_to_lines({}, base_target))

        -- 1. SHIELD CHECK (Hard Block via Syndrome Class)
        for i = sev_lvl, config.MAX_POWER_LEVEL do
             table.insert(lines, "        [IT_CANNOT_HAVE_SYNDROME_CLASS:FIREWALL_" .. i .. "]")
        end

        -- 2. INNATE CHECK (Hard Block via Creature Class if Soak >= Severity)
        for i = sev_lvl, config.MAX_POWER_LEVEL do
             table.insert(lines, "        [IT_IMMUNE_CLASS:INNATE_FIREWALL_" .. i .. "]")
        end

        -- Base Effect: Exclude soaking classes to prevent "Double Dipping"
        table.insert(lines, "    [I_EFFECT:ADD_SYNDROME]")
        table.insert(lines, "        [IE_TARGET:C]")
        table.insert(lines, "        [IE_IMMEDIATE]")
        
        if sev_lvl > 1 then 
            for soak_level = 1, (sev_lvl - 1) do
                 table.insert(lines, "        [IE_TARGETING_REQ_EXCLUDED_SYNDROME_CLASS:INNATE_FIREWALL_" .. soak_level .. "]")
            end
        end
        
        -- 3. ROBUSTNESS SOAK (Syndrome Branches based on INNATE_FIREWALL)
        for innate_lvl = 0, (sev_lvl - 1) do
            local effective_sev = math.max(1, sev_lvl - innate_lvl)
            
            table.insert(lines, "        [SYNDROME]")
            
            if innate_lvl == 0 then
                -- Target has no Innate Firewall (Full Damage)
                for k = 1, config.MAX_POWER_LEVEL do
                     table.insert(lines, "            [SYN_IMMUNE_CLASS:INNATE_FIREWALL_" .. k .. "]")
                end
            else
                -- Target robustness is exactly innate_lvl
                table.insert(lines, "            [SYN_AFFECTED_CLASS:INNATE_FIREWALL_" .. innate_lvl .. "]")
                for k = (innate_lvl + 1), config.MAX_POWER_LEVEL do
                     table.insert(lines, "            [SYN_IMMUNE_CLASS:INNATE_FIREWALL_" .. k .. "]")
                end
            end
            
            -- PAYLOAD
            if ability.injects_silence then
                 table.insert(lines, "            [SYN_CLASS:" .. config.SILENCE_CLASS .. "]")
            end
            
            if ability.speed_penalty_base then
                local final_speed = 100 - (10 * effective_sev) 
                if final_speed < 10 then final_speed = 10 end
                -- Synced Speed Change to effect_duration
                table.insert(lines, "            [CE_SPEED_CHANGE:SPEED_PERC:"..final_speed..":ABRUPT:START:0:END:"..effect_duration.."]")
            end
            
            local tile = config.SEVERITY_SYMBOLS[effective_sev] or 249
            local color = config.COLORS.OFFENSE or "4:0:0"
            
            -- Synced CE_FLASH_TILE and Dummy CE_PHYS_ATT_CHANGE to effect_duration
            local branch_effects = string.format([[
            [CE_FLASH_TILE:TILE:%d:%s:FREQUENCY:2000:1000:START:0:END:%d]
            [CE_PHYS_ATT_CHANGE:DISEASE_RESISTANCE:100:100:START:0:END:%d]
]], tile, color, effect_duration, effect_duration)
            table_merge(lines, split_to_lines({}, branch_effects))
        end
    end
    
    return id, lines
end

-- =============================================================================
--  2. PREPARE INTERACTION (The Bullet / Firing)
-- =============================================================================
local function generate_prepare_interaction(config, ability_key, sev_lvl, num_idx, final_attack_id)
    local ability_list = config.ABILITY_TYPES or config.ABILITIES
    local ability = ability_list[ability_key]
    local target_count = config.TARGET_TIERS[num_idx]
    
    local strict_name = string.format("%s_SEV_%d_NUM_%d", ability.token_prefix, sev_lvl, target_count)
    local id = "PREPARE_" .. strict_name
    local lines = {}

    table.insert(lines, "[INTERACTION:" .. id .. "]")
    add_generated_info(lines)

    local base_target = string.format([[
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_CANNOT_TARGET_IF_ALREADY_AFFECTED]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:%s]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [SYNDROME]
]], config.SILENCE_CLASS)
    table_merge(lines, split_to_lines({}, base_target))
    
    -- TIMING LOGIC (REBALANCED FOR ADVENTURE MODE)
    -- Sum of Severity + Target Tier (Ranges from 2 to 7)
    local sum_tier = sev_lvl + num_idx
    
    -- Start Tick: Controls "Lag" before firing.
    -- Sev 1/2 -> Start 2. Sev 3/4 -> Start 3. Sev 5/6 -> Start 4.
    local start_tick = 2
    if sum_tier >= 6 then
        start_tick = 4
    elseif sum_tier >= 4 then
        start_tick = 3
    end
    
    -- Window: How long the user has to fire. (100 ticks = 2 hours)
    local window_width = 100
    local end_tick = start_tick + window_width 
    local dwf_stretch = 10
    
    table.insert(lines, string.format("            [CE_CAN_DO_INTERACTION:PROB:100:START:%d:END:%d:DWF_STRETCH:%d]", start_tick, end_tick, dwf_stretch))
    table.insert(lines, "                [CDI:INTERACTION:" .. final_attack_id .. "]")
    table.insert(lines, "                [CDI:ADV_NAME:execute " .. strict_name .. "]")
    
    -- TARGETING LOGIC
    if ability.role == "DEFENSE" then
        if target_count == 1 then
             local defense_single = [[
                [CDI:USAGE_HINT:DEFEND]
                [CDI:TARGET:C:SELF_ONLY]
]]
             table_merge(lines, split_to_lines({}, defense_single))
        else
             local defense_multi = [[
                [CDI:USAGE_HINT:GREETING]
                [CDI:TARGET:C:LINE_OF_SIGHT]
                [CDI:TARGET_RANGE:C:100]
]]
             table_merge(lines, split_to_lines({}, defense_multi))
        end
    else
        local offense_target = [[
                [CDI:USAGE_HINT:ATTACK]
                [CDI:TARGET:C:LINE_OF_SIGHT]
                [CDI:TARGET_RANGE:C:100]
]]
        table_merge(lines, split_to_lines({}, offense_target))
    end
    
    table.insert(lines, "                [CDI:MAX_TARGET_NUMBER:C:" .. target_count .. "]")
    
    -- SINGLE SHOT ENFORCEMENT
    -- We set the wait period to be slightly longer than the window (110 vs 100).
    -- This ensures that once fired, it cannot be fired again during this specific "Compile" syndrome.
    -- The "Real" cooldown is handled by the Secret/Item that grants this syndrome.
    local shot_cooldown = window_width + 10
    table.insert(lines, "                [CDI:WAIT_PERIOD:" .. shot_cooldown .. "]") 
    
    local t_verb_final = "hit target:hits target:NA"
    if ability.target_verbs and ability.target_verbs[sev_lvl] then
         t_verb_final = ability.target_verbs[sev_lvl]
    elseif ability.target_verb then
         local sev_adj = config.SEVERITY_ADJECTIVES[sev_lvl] or "standard"
         t_verb_final = ability.target_verb:gsub("%%s", sev_adj)
    end
    
    table.insert(lines, "                [CDI:TARGET_VERB:" .. t_verb_final .. "]")

    return id, lines
end

-- =============================================================================
--  3. SECRET (Learning Method)
-- =============================================================================
local function generate_secret(config, ability_key, sev_lvl, num_idx, prepare_id)
    local ability = (config.ABILITY_TYPES or config.ABILITIES)[ability_key]
    local target_count = config.TARGET_TIERS[num_idx]
    
    local strict_name = string.format("%s_SEV_%d_NUM_%d", ability.token_prefix, sev_lvl, target_count)
    local base_secret_id = "SECRET_" .. strict_name
    local unique_class = "HAS_" .. strict_name
    
    local rarity_const = config.WORLDGEN_RARITY_CONSTANT or 10
    local copies_count = math.max(1, rarity_const - (sev_lvl + num_idx))
    
    local all_lines = {}

    for i = 0, (copies_count - 1) do
        local current_id = base_secret_id
        if i > 0 then current_id = base_secret_id .. "_COPY_" .. i end
        
        table.insert(all_lines, "[INTERACTION:" .. current_id .. "]")
        add_generated_info(all_lines)
        
        -- Split Source Block to inject Learning Restrictions
        local source_block_1 = string.format([[
    [I_SOURCE:DEITY]
        [IS_USAGE_HINT:MAJOR_CURSE]
        [IS_HIST_STRING_1: the infodeity was challenged in the Datasphere by ]
        [IS_HIST_STRING_2: who obtained the program %s]
    [I_SOURCE:SECRET]
        [IS_NAME:%s]
        [IS_SECRET_GOAL:IMMORTALITY]
        [IS_SECRET:SUPERNATURAL_LEARNING_POSSIBLE]
        [IS_SECRET:MUNDANE_RESEARCH_POSSIBLE]
        [IS_SECRET:MUNDANE_TEACHING_POSSIBLE]
        [IS_SECRET:MUNDANE_RECORDING_POSSIBLE:BOOK_INSTRUCTION:SECRET_DIGITAL]
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_REQUIRES:CAN_LEARN]
        [IT_REQUIRES:CAN_SPEAK]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:%s]
]], strict_name, strict_name, unique_class)
        table_merge(all_lines, split_to_lines({}, source_block_1))
        
        -- If Defense and Single Target, prevent learning if Innate Firewall >= Severity
        if ability.role == "DEFENSE" and target_count == 1 then
            for k = sev_lvl, config.MAX_POWER_LEVEL do
                 table.insert(all_lines, "        [IT_IMMUNE_CLASS:INNATE_FIREWALL_" .. k .. "]")
            end
        end

        local source_block_2 = string.format([[
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [IE_ARENA_NAME:%s]
        [SYNDROME]
            [SYN_CLASS:%s]
            [CE_CAN_DO_INTERACTION:PROB:100:START:0:ABRUPT]
                [CDI:ADV_NAME:compile %s]
                [CDI:TARGET:A:SELF_ONLY]
                [CDI:INTERACTION:%s]
]], strict_name, unique_class, strict_name, prepare_id)
        table_merge(all_lines, split_to_lines({}, source_block_2))
        
        if ability.role == "DEFENSE" and target_count > 1 then
            table.insert(all_lines, "                [CDI:USAGE_HINT:GREETING]")
        else
            table.insert(all_lines, "                [CDI:USAGE_HINT:DEFEND]")
        end
        
        -- RECHARGE TIMING (Global Cooldown)
        -- Scaled so higher power spells take longer to "Re-Compile".
        -- Sum (2 to 7) * 100 ticks.
        -- Sev 1: ~200 ticks. Sev 6: ~700 ticks.
        local sum_tier = sev_lvl + num_idx
        local recharge_time = sum_tier * 100
        table.insert(all_lines, "                [CDI:WAIT_PERIOD:" .. recharge_time .. "]")
        
        local role_text = config.FLAVOR_TEXT[ability.role]
        if role_text and role_text[sev_lvl] and role_text[sev_lvl][num_idx] then
            local entry = role_text[sev_lvl][num_idx]
            table.insert(all_lines, "                [CDI:VERB:" .. entry.VERB_1ST .. ":" .. entry.VERB_3RD .. ":NA]")
        else
            table.insert(all_lines, "                [CDI:VERB:compile a program:compiles a program:NA]")
        end
        
        table.insert(all_lines, "") 
    end

    return base_secret_id, all_lines
end

-- =============================================================================
--  4. REACTION & INORGANIC (Crafting & Items)
-- =============================================================================
local function generate_reaction(config, ability_key, sev_lvl, num_idx, inorganic_id)
    local ability = (config.ABILITY_TYPES or config.ABILITIES)[ability_key]
    local craft = config.CRAFTING
    local target_count = config.TARGET_TIERS[num_idx]
    local strict_name = string.format("%s_SEV_%d_NUM_%d", ability.token_prefix, sev_lvl, target_count)
    local reaction_id = strict_name .. "_REACTION"
    
    local lines = {}
    local tier_sum = sev_lvl + num_idx - 1
    local cost_scrap = tier_sum * 15
    local description = string.format("Compile a %s %s program targeting %d units.", 
        config.SEVERITY_ADJECTIVES[sev_lvl] or "standard", ability.name, target_count)
    
    table.insert(lines, "[REACTION:" .. reaction_id .. "]")
    add_generated_info(lines)
    local reagent = (not craft.FREE_RECIPES) and ("[REAGENT:tablet:1:TOOL:ITEM_TOOL_TABLET_INCOMPLETE_PROGRAM" .. tier_sum .. ":NONE:NONE]") or ""
    
    local fort_block = string.format([[
    [NAME:Compile %s]
    [FORTRESS_MODE_ENABLED]
    [BUILDING:%s:NONE]
    %s
    [PRODUCT:100:1:MEAT:NONE:INORGANIC:%s]
    [SKILL:EXTRACT_STRAND]
    [DESCRIPTION:%s]
    [CATEGORY:%s_FORT]
        [CATEGORY_NAME:Digital Warfare Programs]
]], strict_name, craft.FORT_BUILDING, reagent, inorganic_id, description, craft.CATEGORY_ID_PREFIX)
    table_merge(lines, split_to_lines({}, fort_block))
    
    table.insert(lines, "")
    table.insert(lines, "[REACTION:" .. reaction_id .. "_ADV]")
    add_generated_info(lines)
    local adv_reagent = (not craft.FREE_RECIPES) and ("[REAGENT:scrap:"..cost_scrap..":TOOL:ITEM_TOOL_SCRAP:"..craft.ADV_SCRAP_MAT.."]") or ""
    
    local adv_block = string.format([[
    [NAME:Compile %s]
    [ADVENTURE_MODE_ENABLED]
    %s
    [PRODUCT:100:1:MEAT:NONE:INORGANIC:%s]
    [SKILL:EXTRACT_STRAND]
    [DESCRIPTION:%s]
    [CATEGORY:%s_ADV]
        [CATEGORY_NAME:Digital Warfare Programs]
]], strict_name, adv_reagent, inorganic_id, description, craft.CATEGORY_ID_PREFIX)
    table_merge(lines, split_to_lines({}, adv_block))

    return reaction_id, lines
end

local function generate_inorganic(config, ability_key, sev_lvl, num_idx, prepare_id)
    local ability = (config.ABILITY_TYPES or config.ABILITIES)[ability_key]
    local target_count = config.TARGET_TIERS[num_idx]
    local strict_name = string.format("%s_SEV_%d_NUM_%d", ability.token_prefix, sev_lvl, target_count)
    local unique_class = "HAS_" .. strict_name
    
    local lines = {}
    table.insert(lines, "[INORGANIC:" .. strict_name .. "_PROGRAM]")
    add_generated_info(lines)
    
    local base_material = string.format([[
    [USE_MATERIAL_TEMPLATE:MUSCLE_TABLET_TEMPLATE][MEAT][SPECIAL]
    [STATE_NAME_ADJ:ALL_SOLID:%s]
    [DISPLAY_COLOR:2:0:1][TILE:232]
    [MELTING_POINT:12070]
    [SOLID_DENSITY:400]
    [MEAT_NAME:NONE:%s:%s]
    [SYNDROME]
        [SYN_INGESTED]
        [SYN_CLASS:%s]
        [SYN_IMMUNE_CLASS:%s]
]], strict_name, strict_name, strict_name, unique_class, unique_class)
    table_merge(lines, split_to_lines({}, base_material))
    
    -- If Defense and Single Target, prevent application if Innate Firewall >= Severity
    if ability.role == "DEFENSE" and target_count == 1 then
        for k = sev_lvl, config.MAX_POWER_LEVEL do
             table.insert(lines, "        [SYN_IMMUNE_CLASS:INNATE_FIREWALL_" .. k .. "]")
        end
    end
    
    local end_material = string.format([[
        [CE_DISPLAY_NAME:NAME:transmuter:transmuters:transmuter:START:0]
        [CE_CAN_DO_INTERACTION:PROB:100:START:0]
            [CDI:ADV_NAME:compile %s]
            [CDI:TARGET:A:SELF_ONLY]
            [CDI:INTERACTION:%s]
]], strict_name, prepare_id)
    table_merge(lines, split_to_lines({}, end_material))
    
    -- RECHARGE TIMING FOR ITEMS
    local sum_tier = sev_lvl + num_idx
    local recharge_time = sum_tier * 100
    table.insert(lines, "            [CDI:WAIT_PERIOD:" .. recharge_time .. "]")
    
    if ability.role == "DEFENSE" and target_count > 1 then table.insert(lines, "            [CDI:USAGE_HINT:GREETING]") else table.insert(lines, "            [CDI:USAGE_HINT:DEFEND]") end
    
    local role_text = config.FLAVOR_TEXT[ability.role]
    if role_text and role_text[sev_lvl] and role_text[sev_lvl][num_idx] then
        table.insert(lines, "            [CDI:VERB:" .. role_text[sev_lvl][num_idx].VERB_1ST .. ":" .. role_text[sev_lvl][num_idx].VERB_3RD .. ":NA]")
    else
        table.insert(lines, "            [CDI:VERB:compile a program:compiles a program:NA]")
    end
    
    return strict_name .. "_PROGRAM", lines
end

-- =============================================================================
--  MAIN EXECUTION
-- =============================================================================
function M.generate(config)
    local all_interaction_lines, all_inorganic_lines, all_reaction_lines = {}, {}, {}
    script_log("DIGITAL_WARFARE: Starting generation...")

    local sorted_keys = {}
    for k in pairs(config.ABILITY_TYPES or config.ABILITIES) do table.insert(sorted_keys, k) end
    table.sort(sorted_keys)

    for _, key in ipairs(sorted_keys) do
        local ability = (config.ABILITY_TYPES or config.ABILITIES)[key]
        
        for sev = 1, config.MAX_POWER_LEVEL do
            -- 1. Generate STANDARD Final Attack (Has manual input, used for Offense or Multi-target Defense)
            local shared_attack_id, attack_lines = generate_final_attack(config, key, sev, false)
            table_merge(all_interaction_lines, attack_lines)
            table.insert(all_interaction_lines, "")

            -- 2. Generate SELF-OPTIMIZED Final Attack (No manual input, used for Single-target Defense)
            local self_attack_id = nil
            if ability.role == "DEFENSE" then
                local self_lines
                self_attack_id, self_lines = generate_final_attack(config, key, sev, true)
                table_merge(all_interaction_lines, self_lines)
                table.insert(all_interaction_lines, "")
            end

            for num = 1, ((config.MAX_POWER_LEVEL + 1) - sev) do 
                local target_count = config.TARGET_TIERS[num]
                
                -- Determine which Final Attack ID to use for this specific Target Tier
                local final_id_to_use = shared_attack_id
                if ability.role == "DEFENSE" and target_count == 1 and self_attack_id then
                    final_id_to_use = self_attack_id
                end

                local prep_id, prep_lines = generate_prepare_interaction(config, key, sev, num, final_id_to_use)
                table_merge(all_interaction_lines, prep_lines)
                table.insert(all_interaction_lines, "")
                
                local _, sec_lines = generate_secret(config, key, sev, num, prep_id)
                table_merge(all_interaction_lines, sec_lines)
                table.insert(all_interaction_lines, "")
                
                local mat_id, mat_lines = generate_inorganic(config, key, sev, num, prep_id)
                table_merge(all_inorganic_lines, mat_lines)
                table.insert(all_inorganic_lines, "")
                
                local _, react_lines = generate_reaction(config, key, sev, num, mat_id)
                table_merge(all_reaction_lines, react_lines)
                table.insert(all_reaction_lines, "")
            end
        end
    end
    
    if _G.raws then
        if #all_interaction_lines > 0 and _G.raws.register_interactions then _G.raws.register_interactions(all_interaction_lines) end
        if #all_inorganic_lines > 0 and _G.raws.register_inorganics then _G.raws.register_inorganics(all_inorganic_lines) end
        if #all_reaction_lines > 0 and _G.raws.register_reactions then _G.raws.register_reactions(all_reaction_lines) end
    end
    return all_interaction_lines, all_inorganic_lines, all_reaction_lines
end

-- STANDALONE LOADER
if ... == nil then
    print("Running Digital Warfare Generator in standalone mode...")
    
    local outfile = "output_digital_warfare.txt"
    local f = io.open(outfile, "w")
    if f then 
        f:write("--- GENERATED DIGITAL WARFARE OUTPUT ---\n")
        f:close()
        print("Cleared output file: " .. outfile)
    else
        print("Warning: Could not clear output file. It may be locked.")
    end

    local function append_to_file(header, lines)
        local f = io.open(outfile, "a")
        if not f then print("Error writing to file: " .. outfile); return end
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
        print("Config loaded. Generating...")
        M.generate(config)
        print("Generation complete. Output saved to: " .. outfile)
    else
        print("Error: Could not load config_digital_warfare.lua")
    end
end

return M