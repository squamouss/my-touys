local log = _G.log or function(...) end
log("CLUSTER_RULES: Loading cluster size distribution rules.")

local M = {}


local DEFAULT_RULES = {
    MCR = { 
        COLONY = { min = 1000, max_cap = 2000, decay = 0.90 }, 
        FISH = { min = 5, max_cap = 100, decay = 0.80 }
    },
    MNL = { 
        COLONY = { min = 1000, max_cap = 2000, decay = 0.90 },
        FISH = { min = 5, max_cap = 50, decay = 0.80 }
    },
    SML = { 
        COLONY = { min = 100, max_cap = 200, decay = 0.90 },
        FISH = { min = 1, max_cap = 20, decay = 0.80 }
    },
    LSR = { 
        -- [[ SAMPLE: Multiple Weighted Options for DANGEROUS ]]
        -- Instead of a single {min=..., max=...}, this is a list of tables.
        -- The engine will pick ONE of these based on 'weight' before calculating size.
        DANGEROUS = {
            { min = 3, max_cap = 10, decay = 0.50, weight = 1 }, -- Pack hunting (33% chance)
            { min = 2, max_cap = 5, decay = 0.50, weight = 1 },  -- Small group (33% chance)
            { min = 1, max_cap = 2, decay = 0.50, weight = 1 }   -- Solitary/Pair (33% chance)
        },
        
        PROBLEMATIC = { min = 1, max_cap = 30, decay = 0.50 },
        BENIGN = { min = 1, max_cap = 30, decay = 0.50 }, 
        HAZARDOUS = { min = 1, max_cap = 20, decay = 0.50 }
    },
    MDM = {
        DANGEROUS = { min = 1, max_cap = 10, decay = 0.50 },
        PROBLEMATIC = { min = 1, max_cap = 20, decay = 0.50 },
        BENIGN = { min = 1, max_cap = 20, decay = 0.50 },    
        HAZARDOUS = { min = 1, max_cap = 20, decay = 0.50 }
    },
    LRG = { 
        BENIGN = { min = 1, max_cap = 10, decay = 0.50 },    
        PROBLEMATIC = { min = 1, max_cap = 10, decay = 0.50 }, 
        DANGEROUS = { min = 1, max_cap = 5, decay = 0.50 },
        HAZARDOUS = { min = 1, max_cap = 5, decay = 0.50 }
    },
    HGE = { 
        BENIGN = { min = 1, max_cap = 10, decay = 0.50 },    
        PROBLEMATIC = { min = 1, max_cap = 10, decay = 0.50 }, 
        DANGEROUS = { min = 1, max_cap = 3, decay = 0.50 },
        HAZARDOUS = { min = 1, max_cap = 5, decay = 0.50 }
    },
    GNT = { 
        BENIGN = { min = 1, max_cap = 10, decay = 0.50 },    
        PROBLEMATIC = { min = 1, max_cap = 10, decay = 0.50 }, 
        DANGEROUS = { min = 1, max_cap = 5, decay = 0.50 },
        HAZARDOUS = { min = 1, max_cap = 5, decay = 0.50 }
    },
    TTN = { 
        DEFAULT = { min = 1, max_cap = 1, decay = 0.0 }      -- Solitary
    }
}

M.RULES = { 
    ["BIOMACHINE"] = {
        MCR = { 
            COLONY = { min = 1000, max_cap = 2000, decay = 0.90 }, 
            FISH = { min = 5, max_cap = 100, decay = 0.80 }
        },
        MNL = { 
            COLONY = { min = 1000, max_cap = 2000, decay = 0.90 },
            FISH = { min = 5, max_cap = 50, decay = 0.80 }
        },
        SML = { 
            COLONY = { min = 100, max_cap = 200, decay = 0.90 },
            FISH = { min = 1, max_cap = 20, decay = 0.80 }
        },
        LSR = { 
            DANGEROUS = {
                { min = 3, max_cap = 10, decay = 0.50, weight = 1 }, -- Pack hunting
                { min = 2, max_cap = 5, decay = 0.50, weight = 1 },  -- Small group
                { min = 1, max_cap = 2, decay = 0.50, weight = 1 }   -- Solitary/Pair
            },
            PROBLEMATIC = { min = 1, max_cap = 30, decay = 0.50 },
            BENIGN = { min = 1, max_cap = 30, decay = 0.50 }, 
            HAZARDOUS = { min = 1, max_cap = 20, decay = 0.50 }
        },
        MDM = {
            DANGEROUS = { min = 1, max_cap = 10, decay = 0.50 },
            PROBLEMATIC = { min = 1, max_cap = 20, decay = 0.50 },
            BENIGN = { min = 1, max_cap = 20, decay = 0.50 },    
            HAZARDOUS = { min = 1, max_cap = 20, decay = 0.50 }
        },
        LRG = { 
            BENIGN = { min = 1, max_cap = 10, decay = 0.50 },    
            PROBLEMATIC = { min = 1, max_cap = 10, decay = 0.50 }, 
            DANGEROUS = { min = 1, max_cap = 5, decay = 0.50 },
            HAZARDOUS = { min = 1, max_cap = 5, decay = 0.50 }
        },
        HGE = { 
            BENIGN = { min = 1, max_cap = 10, decay = 0.50 },    
            PROBLEMATIC = { min = 1, max_cap = 10, decay = 0.50 }, 
            DANGEROUS = { min = 1, max_cap = 3, decay = 0.50 },
            HAZARDOUS = { min = 1, max_cap = 5, decay = 0.50 }
        },
        GNT = { 
            BENIGN = { min = 1, max_cap = 10, decay = 0.50 },    
            PROBLEMATIC = { min = 1, max_cap = 10, decay = 0.50 }, 
            DANGEROUS = { min = 1, max_cap = 5, decay = 0.50 },
            HAZARDOUS = { min = 1, max_cap = 5, decay = 0.50 }
        },
        TTN = { 
            DEFAULT = { min = 1, max_cap = 1, decay = 0.0 }
        }
    },
    
    ["CYBERMACHINE"] = DEFAULT_RULES,
    ["NECROMACHINE"] = DEFAULT_RULES,
    ["NANOMACHINE"] = DEFAULT_RULES,
    ["HOLOMACHINE"] = DEFAULT_RULES,
    ["LOCASTE"] = DEFAULT_RULES,
    ["HICASTE"] = DEFAULT_RULES,
    ["NUCASTE"] = DEFAULT_RULES,
    ["EXCASTE"] = DEFAULT_RULES,
    ["CYCASTE"] = DEFAULT_RULES,
    ["CHIMERA"] = DEFAULT_RULES,
    ["PROTOCHIMERA"] = DEFAULT_RULES,
    ["MACROCELL"] = DEFAULT_RULES,
    ["POLYMERID"] = DEFAULT_RULES,
}

return M