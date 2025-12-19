local M = {
    -- =========================================================================
    -- SYSTEM SETTINGS
    -- =========================================================================
    MAX_POWER_LEVEL = 6,
    SILENCE_CLASS = "HACKED", 
    
    WORLDGEN_RARITY_CONSTANT = 10,

    -- =========================================================================
    -- ABILITIES
    -- =========================================================================
    ABILITY_TYPES = {
        LOCK = {
            name = "SLOWDOWN",
            token_prefix = "SLOWDOWN",
            role = "OFFENSE",
            duration = 600, 
            speed_penalty_base = 80,
            injects_silence = false,
            soak = true, -- ENABLED SOAKING MECHANIC
            
            target_verbs = {
                [1] = "are orbited by tiny glitching holographic needles:is orbited by tiny glitching holographic needles:NA",
                [2] = "are orbited by small glitching holographic needles:is orbited by small glitching holographic needles:NA",
                [3] = "are orbited by large glitching holographic needles:is orbited by large glitching holographic needles:NA",
                [4] = "are encircled by a thin glitching ring of holographic shards:is encircled by a thin glitching ring of holographic shards:NA",
                [5] = "are encircled by a thick glitching ring of holographic shards:is encircled by a thick glitching ring of holographic shards:NA",
                [6] = "are encircled by multiple glitching rings of holographic shards:is orbited by multiple glitching rings of holographic shards:NA",
            }
        },

        HACK = {
            name = "Hack",
            token_prefix = "HACK",
            role = "OFFENSE",
            duration = 120, 
            injects_silence = true,
            
            target_verbs = {
                [1] = "are orbited by tiny amorphous glitching holograms:is orbited by tiny amorphous glitching holograms:NA",
                [2] = "are orbited by small amorphous glitching holograms:is orbited by small amorphous glitching holograms:NA",
                [3] = "are orbited by large amorphous glitching holograms:is orbited by large amorphous glitching holograms:NA",
                [4] = "are encircled by a thin glitching ring of holographic light:is encircled by a thin glitching ring of holographic light:NA",
                [5] = "are encircled by a thick glitching ring of holographic light:is encircled by a thick glitching ring of holographic light:NA",
                [6] = "are encircled by multiple glitching rings of holographic light:is orbited by multiple glitching rings of holographic light:NA",
            }
        },

        GUARD = {
            name = "Firewall",
            token_prefix = "GUARD",
            role = "DEFENSE",
            duration = 1200, 
            syn_class_prefix = "FIREWALL",
            
            target_verbs = {
                [1] = "are crowned by a thin holographic halo:is crowned by a thin holographic halo:NA",
                [2] = "are crowned by a thick holographic halo:is crowned by a thick holographic halo:NA",
                [3] = "are crowned by multiple holographic halos:is crowned by multiple holographic halos:NA",
                [4] = "are encircled by a thin ring of holographic light:is encircled by a thin ring of holographic light:NA",
                [5] = "are encircled by a thick ring of holographic light:is encircled by a thick ring of holographic light:NA",
                [6] = "are encircled by multiple rings of holographic light:is encircled by multiple rings of holographic light:NA",
            }
        }
    },

    -- =========================================================================
    -- FLAVOR TEXT SETS (Generic Telegraphs)
    -- =========================================================================
    -- Structure: [SEVERITY 1-6] -> [TARGET COUNT]
    
    FLAVOR_TEXT = {
        OFFENSE = {
            [1] = { 
                [1] = { VERB_1ST="project a small holographic targeting reticule", VERB_3RD="projects a small holographic targeting reticule" },
                [2] = { VERB_1ST="project a cluster of small holographic targeting reticules", VERB_3RD="projects a cluster of small holographic targeting reticules" },
                [3] = { VERB_1ST="project a halo of small holographic targeting reticules", VERB_3RD="projects a halo of small holographic targeting reticules" },
                [4] = { VERB_1ST="project a ring of small holographic targeting reticules", VERB_3RD="projects ring of a small holographic targeting reticules" },
                [5] = { VERB_1ST="project multiple rings of small holographic targeting reticules", VERB_3RD="projects multiple rings of small holographic targeting reticules" },
                [6] = { VERB_1ST="project a rotating swarm of small holographic targeting reticules", VERB_3RD="projects a rotating swarm of small holographic targeting reticules" },
            },
            [2] = {
                [1] = { VERB_1ST="project a large holographic targeting reticule", VERB_3RD="projects a large holographic targeting reticule" },
                [2] = { VERB_1ST="project a cluster of large holographic targeting reticules", VERB_3RD="projects a cluster of large holographic targeting reticules" },
                [3] = { VERB_1ST="project a halo of large holographic targeting reticules", VERB_3RD="projects a halo of large holographic targeting reticules" },
                [4] = { VERB_1ST="project a ring of large holographic targeting reticules", VERB_3RD="projects ring of a large holographic targeting reticules" },
                [5] = { VERB_1ST="project multiple rings of large holographic targeting reticules", VERB_3RD="projects multiple rings of large holographic targeting reticules" },
            },
            [3] = {
                [1] = { VERB_1ST="project a large multilayered holographic targeting reticule", VERB_3RD="projects a large multilayered holographic targeting reticule" },
                [2] = { VERB_1ST="project a cluster of large multilayered holographic targeting reticules", VERB_3RD="projects a cluster of large multilayered holographic targeting reticules" },
                [3] = { VERB_1ST="project a halo of large multilayered holographic targeting reticules", VERB_3RD="projects a halo of large multilayered holographic targeting reticules" },
                [4] = { VERB_1ST="project a ring of large multilayered holographic targeting reticules", VERB_3RD="projects ring of a large multilayered holographic targeting reticules" },
            },
            [4] = { 
                [1] = { VERB_1ST="project a huge multilayered holographic targeting reticule", VERB_3RD="projects a huge multilayered holographic targeting reticule" },
                [2] = { VERB_1ST="project a cluster of huge multilayered holographic targeting reticules", VERB_3RD="projects a cluster of huge multilayered holographic targeting reticules" },
                [3] = { VERB_1ST="project a halo of huge multilayered holographic targeting reticules", VERB_3RD="projects a halo of huge multilayered holographic targeting reticules" },
            },
            [5] = { 
                [1] = { VERB_1ST="project a gigantic multilayered holographic targeting reticule", VERB_3RD="projects a gigantic multilayered holographic targeting reticule" },
                [2] = { VERB_1ST="project a cluster of gigantic multilayered holographic targeting reticules", VERB_3RD="projects a cluster of gigantic multilayered holographic targeting reticules" },
            },
            [6] = { 
                [1] = { VERB_1ST="project a titanic multilayered holographic targeting reticule", VERB_3RD="projects a titanic multilayered holographic targeting reticule" },
            }
        }, 
        
        DEFENSE = {
             [1] = { 
                [1] = { VERB_1ST="project a small holographic data screen", VERB_3RD="projects a small holographic data screen" },
                [2] = { VERB_1ST="project a cluster of small holographic data screens", VERB_3RD="projects a cluster of small holographic data screens" },
                [3] = { VERB_1ST="project a halo of small holographic data screens", VERB_3RD="projects a halo of small holographic data screens" },
                [4] = { VERB_1ST="project a ring of small holographic data screens", VERB_3RD="projects ring of a small holographic data screens" },
                [5] = { VERB_1ST="project multiple rings of small holographic data screens", VERB_3RD="projects multiple rings of small holographic data screens" },
                [6] = { VERB_1ST="project a rotating swarm of small holographic data screens", VERB_3RD="projects a rotating swarm of small holographic data screens" },
            },
            [2] = {
                [1] = { VERB_1ST="project a large holographic data screen", VERB_3RD="projects a large holographic data screen" },
                [2] = { VERB_1ST="project a cluster of large holographic data screens", VERB_3RD="projects a cluster of large holographic data screens" },
                [3] = { VERB_1ST="project a halo of large holographic data screens", VERB_3RD="projects a halo of large holographic data screens" },
                [4] = { VERB_1ST="project a ring of large holographic data screens", VERB_3RD="projects ring of a large holographic data screens" },
                [5] = { VERB_1ST="project multiple rings of large holographic data screens", VERB_3RD="projects multiple rings of large holographic data screens" },
            },
            [3] = {
                [1] = { VERB_1ST="project a large multilayered holographic data screen", VERB_3RD="projects a large multilayered holographic data screen" },
                [2] = { VERB_1ST="project a cluster of large multilayered holographic data screens", VERB_3RD="projects a cluster of large multilayered holographic data screens" },
                [3] = { VERB_1ST="project a halo of large multilayered holographic data screens", VERB_3RD="projects a halo of large multilayered holographic data screens" },
                [4] = { VERB_1ST="project a ring of large multilayered holographic data screens", VERB_3RD="projects ring of a large multilayered holographic data screens" },
            },
            [4] = { 
                [1] = { VERB_1ST="project a huge multilayered holographic data screen", VERB_3RD="projects a huge multilayered holographic data screen" },
                [2] = { VERB_1ST="project a cluster of huge multilayered holographic data screens", VERB_3RD="projects a cluster of huge multilayered holographic data screens" },
                [3] = { VERB_1ST="project a halo of huge multilayered holographic data screens", VERB_3RD="projects a halo of huge multilayered holographic data screens" },
            },
            [5] = { 
                [1] = { VERB_1ST="project a gigantic multilayered holographic data screen", VERB_3RD="projects a gigantic multilayered holographic data screen" },
                [2] = { VERB_1ST="project a cluster of gigantic multilayered holographic data screens", VERB_3RD="projects a cluster of gigantic multilayered holographic data screens" },
            },
            [6] = { 
                [1] = { VERB_1ST="project a titanic multilayered holographic data screen", VERB_3RD="projects a titanic multilayered holographic data screen" },
            }
        }
    },

    -- =========================================================================
    -- SCALING & VISUALS
    -- =========================================================================
    TARGET_TIERS = { [1]=1, [2]=5, [3]=10, [4]=25, [5]=50, [6]=100 },
    
    TARGET_ADJECTIVES = {
        [1]="class-1", [2]="class-2", [3]="class-3", [4]="class-4", [5]="class-5", [6]="class-6"
    },
    
    SEVERITY_ADJECTIVES = {
        [1]="severity-1", [2]="severity-2", [3]="severity-3", [4]="severity-4", [5]="severity-5", [6]="severity-6"
    },

    SEVERITY_SYMBOLS = {
        [1]=249, [2]=248, [3]=167, [4]=009, [5]=111, [6]=079 
    },

    COLORS = { OFFENSE="4:0:0", DEFENSE="7:0:1" },

    CRAFTING = {
        FREE_RECIPES = true,
        FORT_BUILDING = "N_MATTER_REFINERY",
        FORT_REAGENT_MAT = "INORGANIC:N_MATTER",
        FORT_TOOL_PREFIX = "ITEM_TOOL_TABLET_INCOMPLETE_WARFARE",
        ADV_TOOL_MAT = "INORGANIC:N_MATTER",
        ADV_SCRAP_MAT = "INORGANIC:N_MATTER",
        ADV_TOOL_ID = "ITEM_TOOL_PORTABLE_SYNTH",
        COST_BASE = 5,
        COST_MULT = 5,
        COST_TARGET_MULT = 2,
        CATEGORY_ID_PREFIX = "DIGI_WARFARE",
    },
}

return M