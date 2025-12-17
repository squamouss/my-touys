-- ============================================================================
-- FUNCTIONS
-- ============================================================================
local function trandom(n)
    if _G.trandom then return _G.trandom(n) end
    return math.random(n) - 1 
end

-- get random number
local function random_in_range(min, max)
    if min >= max then return min end
    return trandom(max - min + 1) + min
end

-- Configuration
local NUM_TO_GENERATE = 400 

-- Resource IDs
local RES_ALLOY = "ALLOY"
local RES_ENERGY = "ENERGETIC_COMPOUND"
local RES_COMPUTE = "COMPUTING_SUBSTRATE"
local RES_BIO = "N_MATTER"
local RES_HYPERBIO = "HYPERBIOLOGY"
local RES_HARDLIGHT = "HARDLIGHT" 

-- ============================================================================
-- MAIN MATERIAL CONFIGURATION
-- ============================================================================
local MAIN_MATERIALS = {

    -- =======================================================
    -- COMPUTING
    -- =======================================================
    {
        name = "computing core",
        stone_suffix = " scrap",
        weight = 12, 
        ranges = { ma={0,30}, ec={0,30}, cs={71,100} }, 
        tile = 240, color = "3:8:1",
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:computing bank", type="CLUSTER_ONE", prob=100 },
                { target="GROUP:computing cabling", type="CLUSTER_ONE", prob=50 },
            },
            tags = [[  

		]]
        }
    },
    {
        name = "computing bank",
        stone_suffix = " scrap",
        weight = 15,
        ranges = { ma={0,29}, ec={0,29}, cs={40,70} }, 
        caps = { cs = 70 },
        tile = 61, color = "3:8:1",
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:computing cabling", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:computing filament", type="CLUSTER_ONE", prob=50 },
            },
            tags = [[ ]]
		}
    },
    {
        name = "computing channel",
        stone_suffix = " scrap",
        weight = 16, 
        ranges = { ma={0,19}, ec={0,19}, cs={25,39} },
        caps = { cs = 40 },
        tile = 206, color = "3:8:1",
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:computing filament", type="VEIN", prob=100 },
                { target="GROUP:median structure", type="VEIN", prob=50 },
                { target="GROUP:heavy structure",   type="VEIN", prob=50 },
            },
            tags = [[ ]]
		}
    },
    {
        name = "computing filament",
        stone_suffix = " scrap",
        weight = 16, 
        ranges = { ma={0,14}, ec={0,14}, cs={11,24} },
        caps = { cs = 25 },
        tile = 172, color = "3:8:1", 
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=25 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=75 },
            },
            tags = [[ ]]
		}
    },

    -- =======================================================
    -- ENERGY
    -- =======================================================
    {
        name = "energy reactor",
        stone_suffix = " scrap",
        weight = 12, 
        ranges = { ma={0,30}, ec={71,100}, cs={0,30} }, -- High EC
        tile = 241, color = "6:0:1",
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:energy vault", type="CLUSTER_ONE", prob=100 },
                { target="GROUP:energy cabling", type="VEIN", prob=50 },
            },
            tags = [[ ]]
        }
    },
	
    { 
        name = "energy vault",
        stone_suffix = " scrap",
        weight = 12,
        ranges = { ma={0,29}, ec={40,70}, cs={0,29} }, 
        caps = { ec = 70 },
        tile = 043, color = "6:8:1",
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:energy cabling", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:energy wiring", type="CLUSTER_SMALL", prob=50 },
            },
            tags = [[ ]]
		}
    },
    {
        name = "energy cabling",
        stone_suffix = " scrap",
        weight = 16, 
        ranges = { ma={0,19}, ec={25,39}, cs={0,19} },
        caps = { ec = 40 },
        tile = 247, color = "6:8:1", 
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:energy wiring", type="VEIN", prob=100 },
                { target="GROUP:median structure", type="VEIN", prob=50 },
                { target="GROUP:heavy structure",   type="VEIN", prob=50 },
            },
            tags = [[ ]]
		}
    },
    {
        name = "energy wiring",
        stone_suffix = " scrap",
        weight = 16,
        ranges = { ma={0,14}, ec={11,24}, cs={0,14} }, 
        caps = { ec = 25 },
        tile = 126, color = "6:0:1", 
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=25 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=75 },
            },
            tags = [[  ]]
		}
    }, 
    { 
        name = "biocore", 
        stone_suffix = " sample",
        weight = 12, 
        ranges = { ma={0,30}, ec={71,100}, cs={0,30} }, -- High EC stats (Swapped to Bio)
        tile = 005, color = "4:8:0", 
        resource_swaps = { { target = RES_ENERGY, replace_with = RES_HYPERBIO, tag = "HB" } },
        placement = {
            mode = "inclusion",
            specs = { { target="GROUP:heavy structure", type="VEIN", prob=15 } },
            tags = [[ ]]
        }
    },
	
    { 
        name = "biomachinery", 
        stone_suffix = " sample",
        weight = 12, 
        ranges = { ma={0,29}, ec={40,70}, cs={0,29} }, 
        tile = 037, color = "4:8:0", 
        resource_swaps = { { target = RES_ENERGY, replace_with = RES_HYPERBIO, tag = "HB" } },
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:energy cabling", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:energy wiring", type="CLUSTER_SMALL", prob=50 },
            },
            tags = [[ ]]
        }
    },
	
    { 
        name = "biomachine artery", 
        stone_suffix = " sample",
        weight = 12,
        ranges = { ma={0,19}, ec={25,39}, cs={0,19} },
        caps = { ec = 40 },
        tile = 247, color = "4:8:0", 
        resource_swaps = { { target = RES_ENERGY, replace_with = RES_HYPERBIO, tag = "HB" } },
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:biomachine mass", type="VEIN", prob=100 },
                { target="GROUP:median structure", type="VEIN", prob=50 },
                { target="GROUP:heavy structure",   type="VEIN", prob=50 },
            },
            tags = [[ ]]
        }
    },

    {
        name = "biomass", 
        stone_suffix = " sample",
        weight = 12,
        ranges = { ma={0,14}, ec={11,24}, cs={0,14} },
        caps = { ec = 25 },
        tile = 224, color = "4:8:0", 
        resource_swaps = { { target = RES_ENERGY, replace_with = RES_HYPERBIO, tag = "HB" } },
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=25 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=75 },
            },
            tags = [[ ]]
        }
    },

    -- =======================================================
    -- STRUCTURE
    -- =======================================================
    {
        name = "heavy structure",
        stone_suffix = " scrap",
        weight = 15, 
        ranges = { ma={71,100}, ec={0,40}, cs={0,40} }, 
        caps = { ec = 40, cs = 40 },
        tile = 206, color = "0:7:1", 
        placement = {
            mode = "layer",
            tags = [[ 
			[REACTION_CLASS:HEAVY_STRUCTURE]
			[IGNEOUS_INTRUSIVE] [SEDIMENTARY_OCEAN_DEEP]
			[IS_STONE]
			]]
        }
    },
    {
        name = "median structure",
        stone_suffix = " scrap",
        weight = 15,
        ranges = { ma={41,70}, ec={0,30}, cs={0,30} }, 
        caps = { ec = 30, cs = 30 },
        tile = 216, color = "0:7:1", 
        placement = {
            mode = "layer",
            tags = [[ 
			[REACTION_CLASS:MIDDLE_STRUCTURE]
			[METAMORPHIC] [IGNEOUS_EXTRUSIVE]
			[IS_STONE] 
			]]
        }
    },
    {
        name = "light structure",
        stone_suffix = " scrap",
        weight = 16,
        ranges = { ma={11,40}, ec={0,20}, cs={0,20} }, 
        caps = { ec = 20, cs = 20 }, 
        tile = 197, color = "0:7:1", 
        placement = {
            mode = "layer",
            tags = [[ 
			[REACTION_CLASS:LIGHT_STRUCTURE]
			[SEDIMENTARY] [SEDIMENTARY_OCEAN_SHALLOW]
			[IS_STONE]
			]]
        }
    },
    {
        name = "plastcrete",
        stone_suffix = " chunk",
        weight = 18, 
        ranges = { ma={0,10}, ec={0,10}, cs={0,10} },
        tile = 178, color = "7:6:0", 
        placement = {
            mode = "layer",
            tags = [[ 
			[REACTION_CLASS:PLASTCRETE]
			[IGNEOUS_INTRUSIVE] [SEDIMENTARY] [IGNEOUS_EXTRUSIVE] [METAMORPHIC] 
			[IS_STONE]
			]]
        }
    },
	
    { 
        name = "native stone", 
        stone_suffix = " scrap",
        weight = 14, 
        ranges = { ma={0,10}, ec={0,10}, cs={0,10} },
        tile = 178, color = "6:7:0", 
        resource_swaps = { { target = RES_COMPUTE, replace_with = RES_ALLOY, tag = "NS" } },
        placement = {
            tags = [[ [IGNEOUS_INTRUSIVE] [METAMORPHIC] [SPECIAL] ]]
        }
    },
	
    { 
        name = "structural scarring", 
        stone_suffix = " scrap",
        weight = 14, 
        ranges = { ma={0,10}, ec={0,10}, cs={0,10} },
        tile = 178, color = "0:12:1", 
        resource_swaps = { { target = RES_COMPUTE, replace_with = RES_ALLOY, tag = "NS" } },
        placement = {
            tags = [[ [METAMORPHIC] [SEDIMENTARY] [SPECIAL] ]]
        }
    },
    -- [VARIANT] Slag
    { 
        name = "slag", 
        stone_suffix = " scrap",
        weight = 14, 
        ranges = { ma={0,10}, ec={0,10}, cs={0,10} },
        tile = 247, color = "0:6:1", 
        resource_swaps = { { target = RES_COMPUTE, replace_with = RES_ALLOY, tag = "SG" } },
        placement = {
            tags = [[ [LAVA][SPECIAL] ]], 
            specs = { { target="GROUP:median structure", type="CLUSTER", prob=100 } }
        }
    },

    -- =======================================================
    -- OTHER
    -- =======================================================
    {
        name = "advanced machinery",
        stone_suffix = " scrap",
        weight = 12, 
        ranges = { ma={0,40}, ec={40,80}, cs={40,80} },
        tile = 15, color = "7:0:1", 
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:basic machinery", type="CLUSTER_SMALL", prob=100 },
            },
            tags = [[ ]]
        }
    },
    {
        name = "basic machinery",
        stone_suffix = " scrap",
        weight = 15,
        ranges = { ma={25,40}, ec={10,40}, cs={10,40} }, 
        caps = { ma = 40, ec = 40, cs = 40 },
        tile = 15, color = "7:0:0", 
        placement = { mode = "layer", tags = [[ [METAMORPHIC][SEDIMENTARY] ]] }
    },
    {
        name = "structural scaffolding",
        stone_suffix = " scrap",
        weight = 15,
        ranges = { ma={15,24}, ec={10,24}, cs={10,24} }, 
        caps = { ma = 25, ec = 25, cs = 25 },
        tile = 035, color = "7:0:0",
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=50 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=50 },
                { target="GROUP:plastcrete",   type="CLUSTER", prob=100 },
            },
            tags = [[ ]]
		}
    },
    {
        name = "structural foundation",
        stone_suffix = " scrap",
        weight = 16, 
        ranges = { ma={11,14}, ec={11,14}, cs={11,14} }, 
        caps = { ma = 15, ec = 15, cs = 15 },
        tile = 210, color = "7:0:0", 
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=100 },
                { target="GROUP:median structure", type="CLUSTER", prob=100 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=100 },
                { target="GROUP:plastcrete",   type="CLUSTER", prob=100 },
            },
            tags = [[ ]]
		}
    },
	
    {
        name = "meta-mineral",
        stone_suffix = " chunk",
        weight = 10, 
        ranges = { ma={11,24}, ec={11,24}, cs={11,24} }, 
        tile = 177, 
        color = "7:7:1", 
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:plastcrete", type="VEIN", prob=100 },
                { target="GROUP:native stone", type="VEIN", prob=100 },
            },
            tags = [[ ]]
        }
    }, 
    {
        name = "meta-crystal",
        stone_suffix = " chunk",
        weight = 10, 
        ranges = { ma={25,39}, ec={25,39}, cs={25,39} },
        tile = 015, 
        color = "7:7:1", 
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:meta-mineral", type="CLUSTER_SMALL", prob=100 },
                { target="GROUP:plastcrete", type="CLUSTER_ONE", prob=100 },
                { target="GROUP:native stone", type="CLUSTER_ONE", prob=100 },
            },
            tags = [[ ]]
        }
    }
}

-- ============================================================================
-- GEM MATERIAL CONFIGURATION
-- ============================================================================
local GEM_MATERIALS = {
    {
        name = "holomachinery",
        stone_suffix = "", 
        weight = 15, -- Adjusted up (was 10)
        ranges = { ma={0,30}, ec={0,30}, cs={71,100} },
        tile = 042, 
        color = "7:8:1", 
        is_gem = true,
        gem_name = "holomachine",
        gem_plural = "holomachines",
        -- material_value removed in favor of dynamic calc
        resource_swaps = { { target = RES_COMPUTE, replace_with = RES_HARDLIGHT, tag = "HL" } }, -- Swap to Hardlight
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:computing bank", type="CLUSTER_SMALL", prob=100 },
                { target="GROUP:computing terminal", type="CLUSTER_SMALL", prob=100 }
            },
            tags = [[  ]]
        }
    },
    {
        name = "holoscreen",
        stone_suffix = "",
        weight = 20,
        ranges = { ma={0,30}, ec={0,30}, cs={50,69} },
        tile = 248,
        color = "7:8:1", 
        is_gem = true,
        gem_name = "holoscreen",
        gem_plural = "holoscreens",
        -- material_value removed in favor of dynamic calc
        resource_swaps = { { target = RES_COMPUTE, replace_with = RES_HARDLIGHT, tag = "HL" } }, -- Swap to Hardlight
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:computing cabling", type="CLUSTER_SMALL", prob=100 },
                { target="GROUP:computing filament", type="CLUSTER_SMALL", prob=100 }
            },
            tags = [[  ]]
        }
    },
    {
        name = "holocrystal",
        stone_suffix = "",
        weight = 10, 
        ranges = { ma={0,30}, ec={0,30}, cs={81,100} },
        tile = 009, 
        color = "7:8:1", 
        is_gem = true,
        gem_name = "holocrystal",
        gem_plural = "holocrystals",
        -- material_value removed in favor of dynamic calc
        resource_swaps = { { target = RES_COMPUTE, replace_with = RES_HARDLIGHT, tag = "HL" } }, -- Swap to Hardlight
        placement = {
            mode = "inclusion",
            specs = {
           
                { target="GROUP:computing bank", type="CLUSTER_ONE", prob=50 } 
            },
            tags = [[  ]]
        }
    }
}

-- ============================================================================
-- GENERATOR LOGIC
-- ============================================================================

-- [[ CRITICAL FIX: Attach to do_once_early instead of do_once ]]
if not do_once_early then do_once_early = {} end

-- We define the function locally first to assign it to both the array (for init.lua)
-- and the keyed table (for standalone/legacy checks).
local function run_megastructure_gen()
    -- [[ SAFETY CHECK: Only run during pre-generation ]]
    if not random_object_parameters.pre_gen_randoms then return end

    if _G.log then _G.log("MEGASTRUCT_LOG: Starting generation (PRE-MAP PHASE)...") end

    -- [[ MERGE MATERIALS FOR GENERATION POOL ]] --
    local GENERATION_POOL = {}
    for _, v in ipairs(MAIN_MATERIALS) do table.insert(GENERATION_POOL, v) end
    for _, v in ipairs(GEM_MATERIALS) do table.insert(GENERATION_POOL, v) end

    local generated_objects = {} -- Stores object data for Pass 2
    local generated_groups = {}  -- Map: base_name -> List of IDs
    local generated_types = {}   -- Map: name -> bool (For Guarantee Pass)
    local generated_counts = {}  -- Track counts for logging
    local generated_signatures = {} -- [[ DUPLICATE PREVENTION ]] Map: signature -> bool

    -- Helper: Weighted Random Selection
    -- Picks a definition from the table based on its 'weight' property
    local function pick_weighted_definition(source_table)
        local total_weight = 0
        for _, def in ipairs(source_table) do
            total_weight = total_weight + (def.weight or 1)
        end
        
        local roll = trandom(total_weight)
        local current = 0
        
        for _, def in ipairs(source_table) do
            current = current + (def.weight or 1)
            if roll < current then
                return def
            end
        end
        return source_table[#source_table] -- Fallback
    end

    local function create_raw_object(token, def, resource_list, nm)
        local entry = {}
        local id_parts = {}
        
        -- Calculate value based on total yield
        local total_yield = 0
        for _, res in ipairs(resource_list) do 
            table.insert(id_parts, res.tag .. res.val) 
            total_yield = total_yield + res.val
        end
        if nm and nm > 0 then
            total_yield = total_yield + nm
        end
        
        local full_name = def.name .. " " .. "ID-" .. table.concat(id_parts, "-")
        
        -- [[ ID FIX: Ensure ID matches player-facing name ]]
        -- Converts "computing bank ID-MA16-EC9-CS84" -> "COMPUTING_BANK_ID_MA16_EC9_CS84"
        local new_token = string.upper(full_name:gsub("[ %-]", "_"))

        -- Header & Basic Props
        table.insert(entry, "[INORGANIC:" .. new_token .. "]")
        
        -- [[ PERSISTENCE FIX ]] --
        -- [CRITICAL FIX] Uncommented [GENERATED] injection.
        -- This is required for save/load persistence.
        if _G.add_generated_info then
            _G.add_generated_info(entry)
        else
            table.insert(entry, "[GENERATED]")
        end

        table.insert(entry, "[USE_MATERIAL_TEMPLATE:STONE_TEMPLATE]")
        
        -- [[ GEM VS STONE LOGIC ]] --
        if def.is_gem then
            -- Gem Definition
            local gem_plural = def.gem_plural or "STP"
            table.insert(entry, "[IS_GEM:" .. def.gem_name .. ":" .. gem_plural .. ":OVERWRITE_SOLID]")
            
            -- [[ GEM VALUE FIX ]] --
            -- Use normal calculation (total_yield), but without division by 3.
            local mat_value = math.max(1, total_yield)
            table.insert(entry, "[MATERIAL_VALUE:" .. mat_value .. "]")
        else
            -- Standard Stone Definition
            -- Use the configured suffix or default to " scrap"
            local stone_suffix = def.stone_suffix or " scrap"
            table.insert(entry, "[STONE_NAME:" .. def.name .. stone_suffix .. "]")
            
            table.insert(entry, "[STATE_NAME_ADJ:ALL_SOLID:" .. full_name .. "]")
            
            -- Stone Value Logic: Sum / 3, rounded down. Minimum 1.
            local mat_value = math.max(1, math.floor(total_yield / 3))
            table.insert(entry, "[MATERIAL_VALUE:" .. mat_value .. "]") 
        end
        
        table.insert(entry, "[DISPLAY_COLOR:" .. def.color .. "]")
        table.insert(entry, "[TILE:" .. def.tile .. "]")
        table.insert(entry, "[SOLID_DENSITY:2000]")
        table.insert(entry, "[MELTING_POINT:11485]")


        -- Ores
        for _, res in ipairs(resource_list) do
            if res.val > 0 then table.insert(entry, "[METAL_ORE:" .. res.id .. ":" .. res.val .. "]") end
        end
        if nm > 0 then table.insert(entry, "[METAL_ORE:" .. RES_BIO .. ":" .. nm .. "]") end
        
        -- [[ DYNAMIC TAG INSERTION ]] --
        local placement_rule = def.placement
        if placement_rule and placement_rule.tags then
            if type(placement_rule.tags) == "string" then
                for line in placement_rule.tags:gmatch("[^\r\n]+") do
                    local clean = line:match("^%s*(.-)%s*$")
                    if clean and #clean > 0 then
                        table.insert(entry, clean)
                    end
                end
            elseif type(placement_rule.tags) == "table" then
                for _, tag in ipairs(placement_rule.tags) do
                    if string.find(tag, "%[") then
                        table.insert(entry, tag)
                    else
                        table.insert(entry, "[" .. tag .. "]")
                    end
                end
            end
        end

        -- Register in group list
        if not generated_groups[def.name] then generated_groups[def.name] = {} end
        -- NOTE: Using the new token here so Environmental Specs point to the correct ID
        table.insert(generated_groups[def.name], new_token)
        
        generated_types[def.name] = true

        return { 
            token = new_token, 
            name = def.name, 
            lines = entry, 
            placement = placement_rule
        }
    end

    -- Internal function to perform one generation cycle
    -- Now uses INVERSE generation: Pick Type -> Generate Stats
    local function generate_cycle(index, force_def_name, source_table)
        local def
        local table_to_use = source_table or GENERATION_POOL
        
        -- [[ DUPLICATE PREVENTION SETTINGS ]]
        local max_retries = 100 -- Increased from 20 to ensure finding a slot
        local retries = 0
        local success = false
        local pct_ma, pct_ec, pct_cs
        
        while retries < max_retries do
            if force_def_name then
                -- Force Logic: Find definition directly
                for _, d in ipairs(table_to_use) do
                    if d.name == force_def_name then
                        def = d
                        break
                    end
                end
                -- If we can't find it, we can't force it. Break.
                if not def then break end 
            else
                -- Weighted Random Selection
                def = pick_weighted_definition(table_to_use)
            end

            if not def then break -- Should theoretically not happen unless table empty
            end

            -- Generate Stats based on Definition Ranges
            local r = def.ranges or {ma={0,0}, ec={0,0}, cs={0,0}}
            pct_ma = random_in_range(r.ma[1], r.ma[2])
            pct_ec = random_in_range(r.ec[1], r.ec[2])
            pct_cs = random_in_range(r.cs[1], r.cs[2])

            -- [[ CAP LOGIC ]] --
            if def.caps then
                if def.caps.ec then pct_ec = math.min(pct_ec, def.caps.ec) end
                if def.caps.cs then pct_cs = math.min(pct_cs, def.caps.cs) end
                if def.caps.ma then pct_ma = math.min(pct_ma, def.caps.ma) end
            end
            
            -- [[ DUPLICATE CHECK ]] --
            -- Create a signature string: "name_ma_ec_cs"
            local signature = def.name .. "_" .. pct_ma .. "_" .. pct_ec .. "_" .. pct_cs
            
            if not generated_signatures[signature] then
                generated_signatures[signature] = true
                success = true
                break -- We have a unique material!
            else
                retries = retries + 1
            end
        end
        
        -- [[ FALLBACK MUTATOR ]]
        -- If we failed to find a unique combo after max_retries, we force a mutation
        -- to ensure we don't return nil and lose an item count.
        if not success and def then
            if _G.log then _G.log("MEGASTRUCT_LOG: WARNING - Collision retry limit reached for " .. def.name .. ". Forcing mutation.") end
            
            -- Attempt to mutate Alloy, then Energy, then Compute until unique
            for i = 1, 50 do
                pct_ma = (pct_ma + 1) % 100
                local signature = def.name .. "_" .. pct_ma .. "_" .. pct_ec .. "_" .. pct_cs
                if not generated_signatures[signature] then
                    generated_signatures[signature] = true
                    success = true
                    break
                end
            end
        end

        if not success then 
            if _G.log then _G.log("MEGASTRUCT_LOG: ERROR - Could not generate unique signature for " .. (def and def.name or "UNKNOWN") .. " even after fallback.") end
            return 
        end

        -- Increment count for summary
        generated_counts[def.name] = (generated_counts[def.name] or 0) + 1

        local pct_nm = (trandom(100) < 5) and (trandom(10) + 1) or 0
        local base_token = "MEGASTRUCT_GEN_" .. index .. "_" .. pct_ma .. "_" .. pct_ec
        
        -- [[ RESOURCE MAPPING ]] --
        -- 1. Create Standard Resource List
        local resources = {
            { id = RES_ALLOY, val = pct_ma, tag = "MA" },
            { id = RES_ENERGY, val = pct_ec, tag = "EC" },
            { id = RES_COMPUTE, val = pct_cs, tag = "CS" }
        }
        
        -- 2. Apply Swaps (for Variants/Forks)
        if def.resource_swaps then
            for _, swap in ipairs(def.resource_swaps) do
                for _, res in ipairs(resources) do
                    if res.id == swap.target then
                        res.id = swap.replace_with
                        res.tag = swap.tag
                        -- Note: We keep the original 'val' (yield percentage)
                    end
                end
            end
        end

        -- Generate Object
        table.insert(generated_objects, create_raw_object(
            base_token, def, resources, pct_nm
        ))
    end

    -- PASS 1: Main Random Generation (Merged Pool)
    for i = 1, NUM_TO_GENERATE do
        generate_cycle(i, nil, GENERATION_POOL)
    end
    
    -- [[ DEPRECATED PASS 1.5 REMOVED ]] --
    -- Gems are now included in the main GENERATION_POOL

    -- GUARANTEE PASS: Check for missing types and force generate them
    local extra_idx = NUM_TO_GENERATE + 1
    
    -- Check Main Materials
    for _, def in ipairs(MAIN_MATERIALS) do
        if not generated_types[def.name] then
            if _G.log then _G.log("MEGASTRUCT_LOG: Force generating missing Material: " .. def.name) end
            generate_cycle(extra_idx, def.name, MAIN_MATERIALS)
            extra_idx = extra_idx + 1
        end
    end
    
    -- Check Gems
    for _, def in ipairs(GEM_MATERIALS) do
        if not generated_types[def.name] then
            if _G.log then _G.log("MEGASTRUCT_LOG: Force generating missing Gem: " .. def.name) end
            generate_cycle(extra_idx, def.name, GEM_MATERIALS)
            extra_idx = extra_idx + 1
        end
    end

    -- [[ CRITICAL FIX: SEPARATE LAYER & INCLUSION REGISTRATION ]] --
    -- We must register Layers FIRST so that IDs exist for Environment Specs.
    -- Then we register Inclusions that reference those Layers.
    
    local layer_lines = {}
    local inclusion_lines = {}

    local layers = {}
    local inclusions = {}
    
    for _, obj in ipairs(generated_objects) do
        -- Heuristic: If it has placement specs, it's an inclusion that depends on something else.
        if obj.placement and obj.placement.specs then
            table.insert(inclusions, obj)
        else
            table.insert(layers, obj)
        end
    end

    -- PASS 2A: Process Layers
    for _, obj in ipairs(layers) do
        -- Layers typically have generic ENVIRONMENT tags or none. 
        -- If no tags/specs, apply default broad placement logic.
        if not obj.placement or (not obj.placement.tags and not obj.placement.specs) then
            table.insert(obj.lines, "[ENVIRONMENT:ALL_STONE:CLUSTER:100]")
            table.insert(obj.lines, "[ENVIRONMENT:ALL_STONE:VEIN:100]")
        end
        for _, l in ipairs(obj.lines) do table.insert(layer_lines, l) end
    end

    -- PASS 2B: Process Inclusions
    for _, obj in ipairs(inclusions) do
        local rule = obj.placement
        
        if rule and rule.mode == "inclusion" and rule.specs then
            for _, spec in ipairs(rule.specs) do
                local group_prefix = "GROUP:"
                if string.sub(spec.target, 1, #group_prefix) == group_prefix then
                    local group_name = string.sub(spec.target, #group_prefix + 1)
                    local target_ids = generated_groups[group_name]
                    if target_ids then
                        for _, target_id in ipairs(target_ids) do
                            table.insert(obj.lines, string.format("[ENVIRONMENT_SPEC:%s:%s:%d]", target_id, spec.type, spec.prob))
                        end
                    end
                else
                    table.insert(obj.lines, string.format("[ENVIRONMENT_SPEC:%s:%s:%d]", spec.target, spec.type, spec.prob))
                end
            end
        end
        for _, l in ipairs(obj.lines) do table.insert(inclusion_lines, l) end
    end

    -- SUMMARY LOGGING
    if _G.log then
        _G.log("MEGASTRUCT_LOG: === Generation Summary ===")
        local function log_counts_for_table(tbl, label)
            _G.log("MEGASTRUCT_LOG: -- " .. label .. " --")
            local total = 0
            for _, def in ipairs(tbl) do
                local count = generated_counts[def.name] or 0
                _G.log(string.format("MEGASTRUCT_LOG: %-25s: %d", def.name, count))
                total = total + count
            end
            _G.log("MEGASTRUCT_LOG: Total " .. label .. ": " .. total)
        end

        log_counts_for_table(MAIN_MATERIALS, "Standard Materials")
        log_counts_for_table(GEM_MATERIALS, "Gem Materials")
        _G.log("MEGASTRUCT_LOG: ============================")
    end

    -- [[ REGISTRATION: SPLIT EXECUTION ]]
    if _G.raws and _G.raws.register_inorganics then
        -- Step 1: Register Layers (Parents)
        if #layer_lines > 0 then
            _G.raws.register_inorganics(layer_lines)
            if _G.log then _G.log("MEGASTRUCT_LOG: Registered " .. #layer_lines .. " Layer lines (Pass 1).") end
        end

        -- Step 2: Register Inclusions (Children)
        -- FIXED: Forced immediate registration of inclusions instead of caching
        if #inclusion_lines > 0 then
            _G.raws.register_inorganics(inclusion_lines)
            if _G.log then _G.log("MEGASTRUCT_LOG: Registered " .. #inclusion_lines .. " Inclusion lines (Pass 2).") end
        end
    end
end

-- [EXECUTION FIX]
-- Instead of inserting into the table here (which runs too late),
-- we ONLY assign it to the key. init.lua will now call this key explicitly
-- at the very start of its own execution loop.
do_once_early.megastructure_gen = run_megastructure_gen

-- #region Standalone Execution
-- If run directly from terminal (arg[0] present), mock the DF environment
if arg and arg[0] then
    print("MEGASTRUCT: Standalone mode detected.")
    math.randomseed(os.time())

    -- 1. Mock Globals
    _G.log = function(...) print("LOG:", ...) end
    _G.add_generated_info = function(tbl) table.insert(tbl, "[GENERATED]") end
    _G.trandom = function(n) return math.random(0, n - 1) end
    
    -- Mock the parameters required for do_once_early check
    _G.random_object_parameters = { pre_gen_randoms = true }

    -- Mock raw registration to capture output instead of calling DF
    _G.raws = {
        register_inorganics = function(lines)
            local filename = "generated_megastructure.txt"
            -- Append mode to support multiple calls
            local f = io.open(filename, "a")
            if not f then
                print("ERROR: Could not open " .. filename .. " for writing.")
                return
            end
            f:write("\n\n-- NEW REGISTRATION BATCH --\n\n[OBJECT:INORGANIC]\n\n")
            for _, line in ipairs(lines) do
                f:write(line .. "\n")
            end
            f:close()
            print("SUCCESS: Appended " .. #lines .. " lines to " .. filename)
        end
    }
    
    -- Reset file for fresh run
    local f = io.open("generated_megastructure.txt", "w")
    if f then f:write("megastructure_inorganics\n"); f:close() end

    -- 2. Trigger the Generation
    if do_once_early.megastructure_gen then
        do_once_early.megastructure_gen()
    else
        print("ERROR: do_once_early.megastructure_gen not found.")
    end
end
-- #endregion