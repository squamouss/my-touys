local log = _G.log or function(...) end
log("FREQUENCY_RULES: Loading frequency distribution rules.")

local M = {}

M.DEFAULT_FREQUENCY = 50 

M.RULES = {
    ["BIOMACHINE"] = {
        MCR = { VERMIN = 100, AMBIENT = 100 },
        MNL = { VERMIN = 100, AMBIENT = 100 },
        SML = { VERMIN = 100, AMBIENT = 100 },
        LSR = { 
            BENIGN = 50,
            PROBLEMATIC = 30,
            HAZARDOUS = 20,
            DANGEROUS = 15, 
			
			NOMAD = 25,
			CARRIER = 20,
			VEHICLE = 25,
			COMPANION = 20,
			DOMESTIC = 50,
			SANITATION = 25,
			HUNTER = 25,
			WEAPON = 10,
			MILITARY = 5,
			LABOR = 10,
			SERVANT = 5,
			PRODUCT = 20
        },
        MDM = { 
            BENIGN = 40,
            PROBLEMATIC = 20,
            HAZARDOUS = 15,
            DANGEROUS = 10, 
			
			NOMAD = 25,
			CARRIER = 20,
			VEHICLE = 25,
			COMPANION = 20,
			DOMESTIC = 50,
			SANITATION = 25,
			HUNTER = 25,
			WEAPON = 10,
			MILITARY = 5,
			LABOR = 10,
			SERVANT = 5,
			PRODUCT = 20,
			
			AVATAR = 100,
			EXISTENTIAL = 100,
			HOSTILE = 100
        },
        LRG = { 
            BENIGN = 30,
            PROBLEMATIC = 10,
            HAZARDOUS = 10,
            DANGEROUS = 5, 
			
			NOMAD = 25,
			CARRIER = 20,
			VEHICLE = 25,
			COMPANION = 20,
			DOMESTIC = 50,
			SANITATION = 25,
			HUNTER = 25,
			WEAPON = 10,
			MILITARY = 5,
			LABOR = 10,
			SERVANT = 5,
			PRODUCT = 20,
			
			AVATAR = 100,
			EXISTENTIAL = 100,
			HOSTILE = 100
        },
        HGE = { 
            BENIGN = 20,
            PROBLEMATIC = 10,
            HAZARDOUS = 20,
            DANGEROUS = 5, 
			
			NOMAD = 25,
			CARRIER = 20,
			VEHICLE = 25,
			COMPANION = 20,
			DOMESTIC = 50,
			SANITATION = 25,
			HUNTER = 25,
			WEAPON = 10,
			MILITARY = 5,
			LABOR = 10,
			SERVANT = 5,
			PRODUCT = 20,
			
			AVATAR = 100,
			EXISTENTIAL = 100,
			HOSTILE = 100
        },
        GNT = {
            DEFAULT = 1 
        },
        TTN = {
            DEFAULT = 1 
        }
    },

    ["NANOMACHINE"] = {
        MCR = { VERMIN = 100, AMBIENT = 100 },
        MNL = { VERMIN = 100, AMBIENT = 100 },
        SML = { VERMIN = 100, AMBIENT = 100 },
        LSR = { 
            BENIGN = 25,
            PROBLEMATIC = 15,
            HAZARDOUS = 10,
            DANGEROUS = 5 
        },
        MDM = { 
            BENIGN = 25,
            PROBLEMATIC = 15,
            HAZARDOUS = 10,
            DANGEROUS = 5 
        },
        LRG = { 
            BENIGN = 30, 
            DOMESTIC = 30,
            HOSTILE = 5, 
            DANGEROUS = 5,
            WEAPON = 5,
            MILITARY = 2
        },
        HGE = { 
            BENIGN = 15,
            HOSTILE = 2,
            DANGEROUS = 2,
            DEFAULT = 5
        },
        GNT = {
            DEFAULT = 1 
        },
        TTN = {
            DEFAULT = 1 
        }
    },


    ["CHIMERA"] = {
        MCR = { VERMIN = 100, AMBIENT = 100 },
        MNL = { VERMIN = 100, AMBIENT = 100 },
        SML = { VERMIN = 100, AMBIENT = 100 },
        LSR = { 
            BENIGN = 60,
            PROBLEMATIC = 40,
            HAZARDOUS = 30,
            DANGEROUS = 15 
        },
        MDM = { 
            BENIGN = 50, 
            DOMESTIC = 50,
            SOPHONT = 5, 
            HOSTILE = 10, 
            DANGEROUS = 10,
            HAZARDOUS = 20,
            VESSEL = 5
        },
        LRG = { 
            BENIGN = 30, 
            DOMESTIC = 30,
            HOSTILE = 5, 
            DANGEROUS = 5,
            WEAPON = 5,
            MILITARY = 2
        },
        HGE = { 
            BENIGN = 15,
            HOSTILE = 2,
            DANGEROUS = 2,
            DEFAULT = 5
        },
        GNT = {
            DEFAULT = 1 
        },
        TTN = {
            DEFAULT = 1 
        }
    },
	
	
    ["PROTOCHIMERA"] = {
        MCR = { VERMIN = 100, AMBIENT = 100 },
        MNL = { VERMIN = 100, AMBIENT = 100 },
        SML = { VERMIN = 100, AMBIENT = 100 },
        LSR = { 
            BENIGN = 60,
            PROBLEMATIC = 40,
            HAZARDOUS = 30,
            DANGEROUS = 15 
        },
        MDM = { 
            BENIGN = 50, 
            DOMESTIC = 50,
            SOPHONT = 5, 
            HOSTILE = 10, 
            DANGEROUS = 10,
            HAZARDOUS = 20,
            VESSEL = 5
        },
        LRG = { 
            BENIGN = 30, 
            DOMESTIC = 30,
            HOSTILE = 5, 
            DANGEROUS = 5,
            WEAPON = 5,
            MILITARY = 2
        },
        HGE = { 
            BENIGN = 15,
            HOSTILE = 2,
            DANGEROUS = 2,
            DEFAULT = 5
        },
        GNT = {
            DEFAULT = 1 
        },
        TTN = {
            DEFAULT = 1 
        }
    },

    -- Cloned structure for other archetypes (can be customized individually)
    ["CYBERMACHINE"] = {
        MCR = { VERMIN = 100, AMBIENT = 100 },
        MDM = { BENIGN = 40, HOSTILE = 10, SOPHONT = 5 },
        LRG = { BENIGN = 25, HOSTILE = 5 },
        GNT = { DEFAULT = 1 },
        TTN = { DEFAULT = 1 }
    },
    ["NECROMACHINE"] = {
        MCR = { VERMIN = 100 },
        MDM = { BENIGN = 10, HOSTILE = 20, DANGEROUS = 20 }, -- Necromachines generally rarer/more hostile
        LRG = { HOSTILE = 10, DANGEROUS = 10 },
        GNT = { DEFAULT = 1 }
    },
    ["CHIMERA"] = {
        MDM = { DEFAULT = 10 }, -- Chimeras are rare mutants
        LRG = { DEFAULT = 5 },
        GNT = { DEFAULT = 1 }
    }
}

return M