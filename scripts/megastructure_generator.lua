-- Megastructure Procedural Generator
-- Generates inorganic building materials based on resource yield percentages.
-- Includes Universal Fork System and Configurable World Placement.
-- Ensures persistence via _G.add_generated_info().
-- GUARANTEE SYSTEM: Ensures at least one of every type exists.

-- ============================================================================
-- HELPER FUNCTIONS (Fixed: No external utils required)
-- ============================================================================
local function trandom(n)
    if _G.trandom then return _G.trandom(n) end
    return math.random(n) - 1 -- trandom is 0 to n-1
end

-- Configuration
local NUM_TO_GENERATE = 100 

-- Resource IDs
local RES_ALLOY = "ALLOY"
local RES_ENERGY = "ENERGETIC_COMPOUND"
local RES_COMPUTE = "COMPUTING_SUBSTRATE"
local RES_BIO = "N_MATTER"
local RES_HYPERBIO = "HYPERBIOLOGY" 

-- ============================================================================
-- MAIN MATERIAL CONFIGURATION
-- ============================================================================
local MAIN_MATERIALS = {
    -- High Tier (Original + Structure Types)
    {
        name = "advanced machinery",
        condition = function(ma, ec, cs) return ec > 50 and cs > 50 end,
        tile = 15,      -- Gear symbol
        color = "7:8:1", 
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:median structure", type="CLUSTER", prob=30 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=30 },
            },
            tags = [[
               SPECIAL
            ]]
        }
    },
    {
        name = "energy cabling",
        condition = function(ma, ec, cs) return ec > 70 end,
        tile = 172,      -- '¼'
        color = "5:0:1", -- Purple
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="VEIN", prob=20 },
                { target="GROUP:median structure", type="VEIN", prob=20 },
                { target="GROUP:heavy structure",   type="VEIN", prob=20 },
            },
            tags = [[
               SPECIAL
            ]]
        }
    },
    {
        name = "computing bank",
        condition = function(ma, ec, cs) return cs > 70 end,
        tile = 240,      -- '≡'
        color = "7:7:1", -- White
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=50 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=50 },
            },
            tags = [[
               SPECIAL
            ]]
        }
    },
    {
        name = "heavy structure",
        caps = { ec = 40, cs = 40 }, -- Dense Structure Cap
        condition = function(ma, ec, cs) return ma > 70 end,
        tile = 206,      -- '╬'
        color = "7:8:0", 
        placement = {
            mode = "layer",
            tags = [[
                [IGNEOUS_INTRUSIVE]
                [SEDIMENTARY_OCEAN_DEEP]
            ]]
        }
    },
    {
        name = "median structure",
        caps = { ec = 30, cs = 30 }, -- Median Structure Cap
        condition = function(ma, ec, cs) return ma > 40 end,
        tile = 216,   
        color = "0:7:1", 
        placement = {
            mode = "layer",
            tags = [[
                [METAMORPHIC]
                [IGNEOUS_EXTRUSIVE]
            ]]
        }
    },
    {
        name = "light structure",
        caps = { ec = 20, cs = 20 }, -- Light Structure Cap
        condition = function(ma, ec, cs) return ma > 10 end,
        tile = 197,      -- '+'
        color = "0:7:1", 
        placement = {
            mode = "layer",
            tags = [[
                [SEDIMENTARY]
                [SEDIMENTARY_OCEAN_SHALLOW]
            ]]
        }
    },

    -- DEAD ZONE FILLERS: Computing Substrate Focus
    {
        name = "computing terminal",
        condition = function(ma, ec, cs) return cs >= 40 and cs <= 70 and ma < 30 and ec < 30 end,
        caps = { cs = 70 },
        tile = 61, color = "7:7:1",
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:median structure", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER_SMALL", prob=50 },
            },
            tags = [[
               SPECIAL
            ]]
		}
    },
    {
        name = "computing cabling",
        condition = function(ma, ec, cs) return cs >= 25 and cs < 40 and ma < 20 and ec < 20 end,
        caps = { cs = 40 },
        tile = 247, color = "7:7:1", -- Dark Grey '≡'
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=50 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=50 },
            },
            tags = [[
               SPECIAL
            ]]
		}
    },
    {
        name = "computing filament",
        condition = function(ma, ec, cs) return cs > 10 and cs < 25 and ma < 15 and ec < 15 end,
        caps = { cs = 25 },
        tile = 172, color = "7:7:1", 
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=50 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=50 },
            },
            tags = [[
               SPECIAL
            ]]
		}
    },
    {
        name = "energy vault",
        condition = function(ma, ec, cs) return ec >= 40 and ec <= 70 and ma < 30 and cs < 30 end,
        caps = { ec = 70 },
        tile = 241, color = "7:8:1", -- Dark Purple 'Σ'
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:median structure", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER_SMALL", prob=50 },
            },
            tags = [[
               SPECIAL
            ]]
		}
    },
    {
        name = "energy bank",
        condition = function(ma, ec, cs) return ec >= 25 and ec < 40 and ma < 20 and cs < 20 end,
        caps = { ec = 40 },
        tile = 43, color = "7:8:1", 
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER_SMALL", prob=100 },
                { target="GROUP:median structure", type="CLUSTER_SMALL", prob=100 },
                { target="GROUP:heavy structure",   type="CLUSTER_SMALL", prob=100 },
            },
            tags = [[
               SPECIAL
            ]]
		}
    },
    {
        name = "energy wiring",
        condition = function(ma, ec, cs) return ec > 10 and ec < 25 and ma < 15 and cs < 15 end,
        caps = { ec = 25 },
        tile = 126, color = "5:0:1", 
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="VEIN", prob=50 },
                { target="GROUP:median structure", type="VEIN", prob=50 },
                { target="GROUP:heavy structure",   type="VEIN", prob=50 },
            },
            tags = [[
               SPECIAL
            ]]
		}
    },

    {
        name = "basic machinery",
        condition = function(ma, ec, cs) return ma >= 25 and ma <= 40 and ec >= 10 and ec <= 40 and cs >= 10 and cs <= 40 end,
        caps = { ma = 40, ec = 40, cs = 40 },
        tile = 15, color = "7:8:1", 
        placement = { mode = "layer", tags = [[ 
		[METAMORPHIC][SEDIMENTARY]
		]] }
    },
    {
        name = "structural scaffolding",
        condition = function(ma, ec, cs) return ma >= 15 and ma < 25 and ec >= 10 and ec < 25 and cs >= 10 and cs < 25 end,
        caps = { ma = 25, ec = 25, cs = 25 },
        tile = 215, color = "0:0:1",
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=50 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=50 },
                { target="GROUP:plastcrete",   type="CLUSTER", prob=100 },
            },
            tags = [[
               SPECIAL
            ]]
		}
    },
    {
        name = "structural foundation",
        condition = function(ma, ec, cs) return ma > 10 and ma < 15 and ec > 10 and ec < 15 and cs > 10 and cs < 15 end,
        caps = { ma = 15, ec = 15, cs = 15 },
        tile = 254, color = "0:7:1", -- Light Grey '▓'
        placement = { 
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=100 },
                { target="GROUP:median structure", type="CLUSTER", prob=100 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=100 },
                { target="GROUP:plastcrete",   type="CLUSTER", prob=100 },
            },
            tags = [[
               SPECIAL
            ]]
		}
    },

    -- Fallback
    {
        name = "plastcrete",
        -- STRICT CONDITION: Only accept if ALL stats are 10 or below.
        condition = function(ma, ec, cs) return ma <= 10 and ec <= 10 and cs <= 10 end,
        tile = 178,     
        color = "0:7:1", 
        placement = {
            mode = "layer",
            tags = [[
                [IGNEOUS_INTRUSIVE]
                [SEDIMENTARY]
                [IGNEOUS_EXTRUSIVE]
                [METAMORPHIC]
            ]]
        }
    }
}

-- ============================================================================
-- FORK CONFIGURATION
-- ============================================================================
local MATERIAL_FORKS = {
    { 
        trigger_name = "computing bank", 
        fork_name = "biomachinery", 
        fork_tile = 224, fork_color = "5:0:1", 
        replace_resource_id = RES_COMPUTE, new_resource_id = RES_HYPERBIO, new_resource_tag = "HB", 
        inherit_percentage = true,
        placement = {
            mode = "inclusion",
            specs = { { target="GROUP:heavy structure", type="VEIN", prob=15 } }
        }
    },
    { 
        trigger_name = "computing bank", 
        fork_name = "biomachine locus", 
        fork_tile = 15, fork_color = "4:8:0", 
        replace_resource_id = RES_COMPUTE, new_resource_id = RES_HYPERBIO, new_resource_tag = "HB", 
        inherit_percentage = true,
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:median structure", type="CLUSTER_SMALL", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER_SMALL", prob=50 },
            }
        }
    },
    { 
        trigger_name = "computing cabling", 
        fork_name = "biomachine cable", 
        fork_tile = 247, fork_color = "4:8:0", 
        replace_resource_id = RES_COMPUTE, new_resource_id = RES_HYPERBIO, new_resource_tag = "HB", 
        inherit_percentage = true,
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="VEIN", prob=50 },
                { target="GROUP:median structure", type="VEIN", prob=50 },
                { target="GROUP:heavy structure",   type="VEIN", prob=50 },
            }
        }
    },
    { 
        trigger_name = "computing filament", 
        fork_name = "biomachine mass", 
        fork_tile = 224, fork_color = "4:8:0", 
        replace_resource_id = RES_COMPUTE, new_resource_id = RES_HYPERBIO, new_resource_tag = "HB", 
        inherit_percentage = true,
        placement = {
            mode = "inclusion",
            specs = {
                { target="GROUP:light structure", type="CLUSTER", prob=50 },
                { target="GROUP:median structure", type="CLUSTER", prob=50 },
                { target="GROUP:heavy structure",   type="CLUSTER", prob=50 },
            }
        }
    },
    { 
        trigger_name = "plastcrete", 
        fork_name = "native stone", 
        fork_tile = 178, fork_color = "6:7:0", 
        replace_resource_id = RES_COMPUTE, new_resource_id = RES_ALLOY, new_resource_tag = "NS", 
        inherit_percentage = false,
        placement = {
            tags = [[
                [IGNEOUS_INTRUSIVE]
                [METAMORPHIC]
				[SPECIAL]
            ]]
        }
    },
    { 
        trigger_name = "plastcrete", 
        fork_name = "rusted scrap", 
        fork_tile = 178, fork_color = "4:6:1", 
        replace_resource_id = RES_COMPUTE, new_resource_id = RES_ALLOY, new_resource_tag = "NS", 
        inherit_percentage = false,
        placement = {
            tags = [[
                [METAMORPHIC]
				[SEDIMENTARY]
				[SPECIAL]
            ]]
        }
    },
    { 
        trigger_name = "plastcrete", 
        fork_name = "slag", 
        fork_tile = 247, fork_color = "0:6:1", 
        replace_resource_id = RES_COMPUTE, new_resource_id = RES_ALLOY, new_resource_tag = "SG", 
        inherit_percentage = false,
        placement = {
            mode = "inclusion",
            -- Manual entry without quotes/commas:
            tags = [[ [LAVA][SPECIAL] ]], 
            specs = { { target="GROUP:median structure", type="CLUSTER", prob=100 } }
        }
    }
}

-- ============================================================================
-- GENERATOR LOGIC
-- ============================================================================

-- [[ CRITICAL FIX: Attach to do_once_early instead of do_once ]]
-- This ensures materials generate BEFORE the world map/geology is finalized.
do_once_early = do_once_early or {}

do_once_early.megastructure_gen = function()
    -- [[ SAFETY CHECK: Only run during pre-generation ]]
    if not random_object_parameters.pre_gen_randoms then return end

    if _G.log then _G.log("MEGASTRUCT_LOG: Starting generation (PRE-MAP PHASE)...") end

    local final_lines = {}
    local generated_objects = {} -- Stores object data for Pass 2
    local generated_groups = {}  -- Map: base_name -> List of IDs
    
    -- Tracks which material names (main & fork) have been created
    local generated_types = {}

    -- Helper to find the matching definition from MAIN_MATERIALS
    -- Returns NIL if no condition matches (allowing retry)
    local function resolve_material_def(ma, ec, cs)
        for _, def in ipairs(MAIN_MATERIALS) do
            if def.condition(ma, ec, cs) then
                return def
            end
        end
        return nil
    end

    local function create_raw_object(token, name, tile, color, resource_list, nm, placement_rule)
        local entry = {}
        local id_parts = {}
        
        -- Calculate value based on total yield
        local total_yield = 0
        for _, res in ipairs(resource_list) do 
            table.insert(id_parts, res.tag .. res.val) 
            total_yield = total_yield + res.val
        end
        -- Add N-Matter yield if present
        if nm and nm > 0 then
            total_yield = total_yield + nm
        end
        
        -- [[ VALUE UPDATE ]] --
        -- Formula: Sum / 3, rounded down. Minimum 1.
        local mat_value = math.max(1, math.floor(total_yield / 3))
        
        local full_name = name .. " " .. "ID-" .. table.concat(id_parts, "-")

        -- Header & Basic Props
        table.insert(entry, "[INORGANIC:" .. token .. "]")
        
        -- [[ PERSISTENCE FIX ]] --
        if _G.add_generated_info then
            _G.add_generated_info(entry)
        else
            table.insert(entry, "[GENERATED]")
        end

        table.insert(entry, "[USE_MATERIAL_TEMPLATE:STONE_TEMPLATE]")
        table.insert(entry, "[STATE_NAME_ADJ:ALL_SOLID:" .. full_name .. "]")
        table.insert(entry, "[DISPLAY_COLOR:" .. color .. "]")
        table.insert(entry, "[TILE:" .. tile .. "]")
        table.insert(entry, "[MATERIAL_VALUE:" .. mat_value .. "]") 
        table.insert(entry, "[IS_STONE]")
        table.insert(entry, "[SOLID_DENSITY:2000]")
        table.insert(entry, "[MELTING_POINT:11485]")
        table.insert(entry, "[STONE_NAME:scrap]")


        -- Ores
        for _, res in ipairs(resource_list) do
            if res.val > 0 then table.insert(entry, "[METAL_ORE:" .. res.id .. ":" .. res.val .. "]") end
        end
        if nm > 0 then table.insert(entry, "[METAL_ORE:" .. RES_BIO .. ":" .. nm .. "]") end
        
        -- [[ DYNAMIC TAG INSERTION ]] --
        -- Supports string blocks [[ [TAG] ]] or tables { "TAG" }
        if placement_rule and placement_rule.tags then
            if type(placement_rule.tags) == "string" then
                -- Parse Block String
                for line in placement_rule.tags:gmatch("[^\r\n]+") do
                    -- Trim whitespace
                    local clean = line:match("^%s*(.-)%s*$")
                    if clean and #clean > 0 then
                        table.insert(entry, clean)
                    end
                end
            elseif type(placement_rule.tags) == "table" then
                -- Parse legacy table list
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
        if not generated_groups[name] then generated_groups[name] = {} end
        table.insert(generated_groups[name], token)
        
        -- Mark as generated for Guarantee System
        generated_types[name] = true

        return { 
            token = token, 
            name = name, 
            lines = entry, 
            placement = placement_rule -- Store rule for Pass 2 processing
        }
    end

    -- Internal function to perform one generation cycle
    -- Returns true if successful, false if errors (though currently robust)
    local function generate_cycle(index, force_def_name, force_fork_name)
        local def
        local pct_ma, pct_ec, pct_cs
        
        if force_def_name then
            -- Force Logic: Find the definition first
            for _, d in ipairs(MAIN_MATERIALS) do
                if d.name == force_def_name then
                    def = d
                    break
                end
            end
            
            -- Generate random stats. If forcing Plastcrete specifically, obey strict low limit.
            if def and def.name == "plastcrete" then
                pct_ma, pct_ec, pct_cs = trandom(11), trandom(11), trandom(11)
            else
                pct_ma, pct_ec, pct_cs = trandom(101), trandom(101), trandom(101)
            end
        else
            -- Random Logic with Retry (Avoid Dead Zones)
            local attempts = 0
            -- Loop until we find a set of stats that matches a definition
            while not def and attempts < 200 do
                pct_ma, pct_ec, pct_cs = trandom(101), trandom(101), trandom(101)
                def = resolve_material_def(pct_ma, pct_ec, pct_cs)
                attempts = attempts + 1
            end

            -- Safety Fallback: If 200 tries failed (statistically rare), defaults to Plastcrete
            if not def then
                for _, d in ipairs(MAIN_MATERIALS) do
                    if d.name == "plastcrete" then def = d break end
                end
                -- Force stats to be valid for Plastcrete (<= 10)
                pct_ma, pct_ec, pct_cs = trandom(11), trandom(11), trandom(11)
            end
        end

        -- [[ CAP LOGIC ]] --
        -- If the resolved definition has caps, clamp the generated resources.
        if def.caps then
            if def.caps.ec then pct_ec = math.min(pct_ec, def.caps.ec) end
            if def.caps.cs then pct_cs = math.min(pct_cs, def.caps.cs) end
            if def.caps.ma then pct_ma = math.min(pct_ma, def.caps.ma) end
        end

        local pct_nm = (trandom(100) < 5) and (trandom(10) + 1) or 0
        local base_token = "MEGASTRUCT_GEN_" .. index .. "_" .. pct_ma .. "_" .. pct_ec
        
        local std_res = {
            { id = RES_ALLOY, val = pct_ma, tag = "MA" },
            { id = RES_ENERGY, val = pct_ec, tag = "EC" },
            { id = RES_COMPUTE, val = pct_cs, tag = "CS" }
        }

        -- Generate Main
        table.insert(generated_objects, create_raw_object(
            base_token, def.name, def.tile, def.color, 
            std_res, pct_nm, def.placement
        ))

        -- Generate Forks
        for _, fork in ipairs(MATERIAL_FORKS) do
            -- If we are forcing a specific fork, ignore others unless they match trigger
            local should_gen = (def.name == fork.trigger_name)
            
            -- If we are in "Force Mode" for a specific fork, ensure we only gen THAT fork
            -- But if we are in normal random mode, generate all valid forks
            if force_fork_name and fork.fork_name ~= force_fork_name then
                should_gen = false
            end

            if should_gen and def.name == fork.trigger_name then
                local fork_res = {}
                for _, r in ipairs(std_res) do
                    local new_r = { id = r.id, val = r.val, tag = r.tag }
                    if r.id == fork.replace_resource_id then
                        new_r.id, new_r.tag = fork.new_resource_id, fork.new_resource_tag
                        if not fork.inherit_percentage then new_r.val = trandom(101) end
                    end
                    table.insert(fork_res, new_r)
                end
                
                local fork_token = base_token .. "_" .. fork.new_resource_tag
                table.insert(generated_objects, create_raw_object(
                    fork_token, fork.fork_name, fork.fork_tile, fork.fork_color, 
                    fork_res, pct_nm, fork.placement
                ))
            end
        end
    end

    -- PASS 1: Main Random Generation
    for i = 1, NUM_TO_GENERATE do
        generate_cycle(i, nil, nil)
    end

    -- GUARANTEE PASS: Check for missing types and force generate them
    local extra_idx = NUM_TO_GENERATE + 1
    
    -- Check Main Materials
    for _, def in ipairs(MAIN_MATERIALS) do
        if not generated_types[def.name] then
            if _G.log then _G.log("MEGASTRUCT_LOG: Force generating missing Main: " .. def.name) end
            generate_cycle(extra_idx, def.name, nil)
            extra_idx = extra_idx + 1
        end
    end

    -- Check Forks
    for _, fork in ipairs(MATERIAL_FORKS) do
        if not generated_types[fork.fork_name] then
            if _G.log then _G.log("MEGASTRUCT_LOG: Force generating missing Fork: " .. fork.fork_name) end
            -- To force a fork, we force its TRIGGER material first
            -- This will create an extra Main material instance as a side effect, which is fine
            generate_cycle(extra_idx, fork.trigger_name, fork.fork_name)
            extra_idx = extra_idx + 1
        end
    end

    -- PASS 2: Apply Inclusion Rules
    for _, obj in ipairs(generated_objects) do
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
        
        -- Fallback if no placement info exists at all (prevents unminable objects)
        if not rule or (not rule.tags and not rule.specs) then
            -- Only add fallback if we didn't add anything else
            table.insert(obj.lines, "[ENVIRONMENT:ALL_STONE:CLUSTER:100]")
            table.insert(obj.lines, "[ENVIRONMENT:ALL_STONE:VEIN:100]")
        end

        for _, l in ipairs(obj.lines) do table.insert(final_lines, l) end
    end

    -- Batch registration
    if _G.raws and _G.raws.register_inorganics then
        _G.raws.register_inorganics(final_lines)
        if _G.log then _G.log("MEGASTRUCT_LOG: Registered " .. #final_lines .. " lines.") end
    end
end