return {
    -- =========================================================================
    -- SYSTEM SETTINGS
    -- =========================================================================
	
    MAX_POWER_LEVEL = 6,
    
    -- Universal Silence Class
    SILENCE_CLASS = "HACKED", 
    
    -- =========================================================================
    -- SCALING & VISUALS
    -- =========================================================================
    
    -- Target Tiers (The count of targets for each tier index)
    TARGET_TIERS = {
        [1] = 1,
        [2] = 5,
        [3] = 10,
        [4] = 25,
        [5] = 50,
        [6] = 100
    },

    -- Naming for Target Tiers (appended to name)
    -- THIS WAS MISSING
    TARGET_ADJECTIVES = {
        [1] = "Single",
        [2] = "Double",
        [3] = "Group",
        [4] = "Cluster",
        [5] = "Swarm",
        [6] = "Horde"
    },

    -- Adjectives used in flavor text for each Power Level (Severity)
    SEVERITY_ADJECTIVES = {
        [1] = "small",
        [2] = "large",
        [3] = "huge",
        [4] = "massive",
        [5] = "colossal",
        [6] = "titanic"
    },

    SEVERITY_SYMBOLS = {
        [1] = 249, 
        [2] = 248,   
        [3] = 167,  
        [4] = 009,  
        [5] = 111,  
        [6] = 079 
    },

    COLORS = {
        OFFENSE = "4:0:0",
        DEFENSE = "7:0:1"  
    },

    -- =========================================================================
    -- CRAFTING & SECRETS
    -- =========================================================================
    CRAFTING = {
	FREE_RECIPES = true,
        -- Fortress Mode
        FORT_BUILDING = "N_MATTER_REFINERY",
        FORT_REAGENT_MAT = "INORGANIC:N_MATTER",
        FORT_TOOL_PREFIX = "ITEM_TOOL_TABLET_INCOMPLETE_WARFARE",
        
        -- Adventure Mode
        ADV_TOOL_MAT = "INORGANIC:N_MATTER",
        ADV_SCRAP_MAT = "INORGANIC:N_MATTER",
        ADV_TOOL_ID = "ITEM_TOOL_PORTABLE_SYNTH",
        
        -- Cost Calculation: Base + (PowerLvl * CostMult) + (TargetTier * TargetMult)
        COST_BASE = 5,
        COST_MULT = 5,        -- Multiplier for Severity
        COST_TARGET_MULT = 2, -- Multiplier for Target Count Tier
        
        -- Category info
        CATEGORY_ID_PREFIX = "DIGI_WARFARE",
        CATEGORY_NAME = "Digital Warfare Programs",
        CATEGORY_DESC = "Programs for digital offense and defense."
    },

    -- =========================================================================
    -- ABILITY TYPES
    -- =========================================================================
    
    ABILITY_TYPES = {
        LOCK = {
            name = "SLOWDOWN",
            verb_root = "lock",
            token_prefix = "SLOWDOWN",
            role = "OFFENSE",
            
            -- Flavor
            noun_singular = "holographic targeting reticule",
            noun_plural = "holographic targeting reticules",
            target_verb = "feel your body lock up and slow down:stiffens and slows:NA",
            craft_verb = "compile a limblock program:compiles a limblock program:NA",
            
            -- Logic: Speed Penalty
            speed_penalty_base = 80,
            speed_penalty_scale = 10
        },

        HACK = {
            name = "Hack",
            verb_root = "hack",
            token_prefix = "HACK",
            role = "OFFENSE",
            
            -- Flavor
            noun_singular = "holographic malware projection",
            noun_plural = "holographic malware projections",
            target_verb = "are ringed by holographic malware projections:is ringed by holographic malware projections:NA",
            craft_verb = "compile a malware program:compiles a malware program:NA",
            
            -- Logic: Injects SILENCE_CLASS (HACKED)
            injects_silence = true
        },

        GUARD = {
            name = "Firewall",
            verb_root = "guard",
            token_prefix = "GUARD",
            role = "DEFENSE",
            
            -- Flavor
            noun_singular = "holographic shield generator",
            noun_plural = "holographic shield generators",
            target_verb = "are surrounded by a %s firewall:is surrounded by a %s firewall:NA",
            craft_verb = "compile a firewall program:compiles a firewall program:NA",
            
            -- Logic: Injects FIREWALL class to block Offense
            syn_class_prefix = "FIREWALL" 
        }
    }
}