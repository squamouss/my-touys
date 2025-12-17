return {
    -- =========================================================================
    -- PHYSICAL ATTRIBUTES
    -- Generator Type: "PHYSICAL" -> Uses [CE_PHYS_ATT_CHANGE]
    -- =========================================================================
    {
        id = "AGILITY",             -- The DF Attribute Token
        type = "PHYSICAL",          -- Logic Type
        buff_name = "Agility",      -- Display Name
        buff_noun = "agility",      -- "enhances <noun>"
        
        id_prefix = "ENHANCEAGILITY",
        secret_prefix = "ENHANCEAGILITY",
        payload_prefix = "AGILITYENHANCE",
        
        verbs = {
            PRIMARY     = "extrude many small thruster rockets from all over your body:extrudes many small thruster rockets from all over their body:NA",
            SECONDARY   = "extrude multiple small thruster rockets from all over your body:extrudes multiple small thruster rockets from all over their body:NA",
            TERTIARY    = "extrude multiple small thruster rockets from parts of your body:extrudes multiple small thruster rockets from parts of their body:NA",
            QUATERNARY  = "extrude several small thruster rockets from parts of your body:extrudes several small thruster rockets from parts of their body:NA"
        }
    },
    {
        id = "ENDURANCE",
        type = "PHYSICAL",
        buff_name = "Endurance",
        buff_noun = "endurance",
        
        id_prefix = "ENHANCEENDURANCE",
        secret_prefix = "ENHANCEENDURANCE",
        payload_prefix = "ENDURANCEENHANCE",
        
        verbs = {
            PRIMARY     = "emit massive amounts of heat exhaust and glow from your internal reactor:emits massive amounts of heat exhaust and glows from their internal reactor:NA",
            SECONDARY   = "emit large amounts of heat exhaust and a slight glow from your internal reactor:emits large amounts of heat exhaust and a slight glow from their internal reactor:NA",
            TERTIARY    = "emit large amounts of heat exhaust from your internal reactor:emits large amounts of heat exhaust from their internal reactor:NA",
            QUATERNARY  = "emit visible amounts of heat exhaust from your internal reactor:emits visible amounts of heat exhaust from their internal reactor:NA"
        }
    },
    {
        id = "STRENGTH",
        type = "PHYSICAL",
        buff_name = "Strength",
        buff_noun = "strength",
        
        id_prefix = "ENHANCESTRENGTH",
        secret_prefix = "ENHANCESTRENGTH",
        payload_prefix = "STRENGTHENHANCE",
        
        verbs = {
            PRIMARY     = "are enveloped in grotesquely thick bundles of artificial muscle:is enveloped in grotesquely thick bundles of artificial muscle:NA",
            SECONDARY   = "are enveloped in thick bundles of artificial muscle:is enveloped in thick bundles of artificial muscle:NA",
            TERTIARY    = "are covered by a dense exterior of artificial muscle:is covered by a dense exterior of artificial muscle:NA",
            QUATERNARY  = "are covered by a thin exterior of artificial muscle:is covered by a thin exterior of artificial muscle:NA"
        }
    },
    {
        id = "TOUGHNESS",
        type = "PHYSICAL",
        buff_name = "Toughness",
        buff_noun = "toughness",
        
        id_prefix = "ENHANCETOUGHNESS",
        secret_prefix = "ENHANCETOUGHNESS",
        payload_prefix = "TOUGHNESSENHANCE",
        
        verbs = {
            PRIMARY     = "are covered by thick slabs of metal that obscure your original form:are covered by thick slabs of metal that obscures their original form:NA",
            SECONDARY   = "are covered by thick slabs of metal adhering to your body:is covered by thick slabs of metal adhering to their body:NA",
            TERTIARY    = "are covered by thin segments of metal adhering to your body:are covered by thin segments of metal adhering to their body:NA",
            QUATERNARY  = "are partially covered by thin segments of metal adhering to your body:are partially covered by thin segments of metal adhering to their body:NA"
        }
    },
    {
        id = "RECUPERATION",
        type = "PHYSICAL",
        buff_name = "Recuperation",
        buff_noun = "recuperation",
        
        id_prefix = "ENHANCERECUPERATION",
        secret_prefix = "ENHANCERECUPERATION",
        payload_prefix = "RECUPERATIONENHANCE",
        
        verbs = {
            PRIMARY     = "are coated in a writhing layer of reparative nanites:is coated in a writhing layer of reparative nanites:NA",
            SECONDARY   = "are enmeshed in writhing tendrils of reparative nanites:is enmeshed in writhing tendrils of reparative nanites:NA",
            TERTIARY    = "construct many writhing tendrils of reparative nanites:constructs many writhing tendrils of reparative nanites:NA",
            QUATERNARY  = "construct several writhing tendrils of reparative nanites:constructs several writhing tendrils of reparative nanites:NA"
        }
    },
    {
        id = "DISEASE_RESISTANCE",
        type = "PHYSICAL",
        buff_name = "Disease Resistance",
        buff_noun = "disease resistance",
        
        id_prefix = "ENHANCEDISEASE_RESISTANCE",
        secret_prefix = "ENHANCEDISEASE_RESISTANCE",
        payload_prefix = "DISEASE_RESISTANCEENHANCE",
        
        verbs = {
            PRIMARY     = "emit a billowing cloud of sterilizing nanites:emits a billowing cloud of sterilizing nanites:NA",
            SECONDARY   = "emit a trailing cloud of sterilizing nanites:emits a trailing cloud of sterilizing nanites:NA",
            TERTIARY    = "emit a thick layer of sterilizing nanites:emits a thick layer of sterilizing nanites:NA",
            QUATERNARY  = "emit a thin layer of sterilizing nanites:emits a thin layer of sterilizing nanites:NA"
        }
    },

    -- =========================================================================
    -- MENTAL ATTRIBUTES
    -- =========================================================================
    {
        id = "FOCUS",
        type = "MENTAL",
        buff_name = "Focus",
        buff_noun = "focus",
        
        id_prefix = "ENHANCEFOCUS",
        secret_prefix = "ENHANCEFOCUS",
        payload_prefix = "FOCUSENHANCE",
        
        verbs = {
            PRIMARY     = "construct four times the amount of eyes on your head:constructs four times the amount of eyes on their head:NA",
            SECONDARY   = "construct three times the amount of eyes on your head:constructs three times the amount of eyes on their head:NA",
            TERTIARY    = "construct twice the amount of eyes on your head:constructs twice the amount of eyes on their head:NA",
            QUATERNARY  = "construct an additional eye on your head:constructs an additional eye on their head:NA"
        }
    },
    {
        id = "INTUITION",
        type = "MENTAL",
        buff_name = "Intuition",
        buff_noun = "intuition",
        
        id_prefix = "ENHANCEINTUITION",
        secret_prefix = "ENHANCEINTUITION",
        payload_prefix = "INTUITIONENHANCE",
        
        verbs = {
            PRIMARY     = "construct many ocular lenses all over your body:constructs many ocular lenses all over their body:NA",
            SECONDARY   = "construct multiple ocular lenses all over your body:constructs multiple ocular lenses all over their body:NA",
            TERTIARY    = "construct multiple ocular lenses on parts of your body:constructs multiple ocular lenses on parts of their body:NA",
            QUATERNARY  = "construct several ocular lenses on parts of your body:constructs several ocular lenses on parts of their body:NA"
        }
    },
    {
        id = "SPATIAL_SENSE",
        type = "MENTAL",
        buff_name = "Spatial Sense",
        buff_noun = "spatial sense",
        
        id_prefix = "ENHANCESPATIAL_SENSE",
        secret_prefix = "ENHANCESPATIAL_SENSE",
        payload_prefix = "SPATIAL_SENSEENHANCE",
        
        verbs = {
            PRIMARY     = "extrude countless long sensory filaments around your body:extrudes countless long sensory filaments around their body:NA",
            SECONDARY   = "extrude many long sensory filaments around your body:extrudes many long sensory filaments around their body:NA",
            TERTIARY    = "extrude multiple long sensory filaments around your body:extrudes multiple long sensory filaments around their body:NA",
            QUATERNARY  = "extrude several long sensory filaments around your body:extrudes several long sensory filaments around their body:NA"
        }
    },
    {
        id = "KINESTHETIC_SENSE",
        type = "MENTAL",
        buff_name = "Kinesthetic Sense",
        buff_noun = "kinesthetic sense",
        
        id_prefix = "ENHANCEKINESTHETIC_SENSE",
        secret_prefix = "ENHANCEKINESTHETIC_SENSE",
        payload_prefix = "KINESTHETIC_SENSEENHANCE",
        
        verbs = {
            PRIMARY     = "begin to visibly blur as you vibrate at immense speeds:begins to visibly blur as they vibrate at immense speeds:NA",
            SECONDARY   = "begin to visibly blur as you vibrate at high speeds:begins to visibly blur as they vibrate at high speeds:NA",
            TERTIARY    = "begin to blur slightly as you vibrate at high speeds:begins to blur slightly as they vibrate at high speeds:NA",
            QUATERNARY  = "begin to visibly vibrate:begins to visibly vibrate:NA"
        }
    },
    {
        id = "WILLPOWER",
        type = "MENTAL",
        buff_name = "Willpower",
        buff_noun = "willpower",
        
        id_prefix = "ENHANCEWILLPOWER",
        secret_prefix = "ENHANCEWILLPOWER",
        payload_prefix = "WILLPOWERENHANCE",
        
        verbs = {
            PRIMARY     = "begin to visibly blur as you vibrate at immense speeds:begins to visibly blur as they vibrate at immense speeds:NA",
            SECONDARY   = "begin to visibly blur as you vibrate at high speeds:begins to visibly blur as they vibrate at high speeds:NA",
            TERTIARY    = "begin to blur slightly as you vibrate at high speeds:begins to blur slightly as they vibrate at high speeds:NA",
            QUATERNARY  = "begin to visibly vibrate:begins to visibly vibrate:NA"
        }
    },
    {
        id = "SOCIAL_AWARENESS",
        type = "MENTAL",
        buff_name = "Social Awareness",
        buff_noun = "social awareness",
        usage_hint = "GREETING", -- CUSTOM USAGE HINT
        
        id_prefix = "ENHANCESOCIAL_AWARENESS",
        secret_prefix = "ENHANCESOCIAL_AWARENESS",
        payload_prefix = "SOCIAL_AWARENESSENHANCE",
        
        verbs = {
            PRIMARY     = "begin to visibly blur as you vibrate at immense speeds:begins to visibly blur as they vibrate at immense speeds:NA",
            SECONDARY   = "begin to visibly blur as you vibrate at high speeds:begins to visibly blur as they vibrate at high speeds:NA",
            TERTIARY    = "begin to blur slightly as you vibrate at high speeds:begins to blur slightly as they vibrate at high speeds:NA",
            QUATERNARY  = "begin to visibly vibrate:begins to visibly vibrate:NA"
        }
    },
    {
        id = "LINGUISTIC_ABILITY",
        type = "MENTAL",
        buff_name = "Linguistic Ability",
        buff_noun = "linguistic ability",
        
        id_prefix = "ENHANCELINGUISTIC_ABILITY",
        secret_prefix = "ENHANCELINGUISTIC_ABILITY",
        payload_prefix = "LINGUISTIC_ABILITYENHANCE",
        
        verbs = {
            PRIMARY     = "begin to speak in verbalized machine-code:begins to speak in verbalized machine-code:NA",
            SECONDARY   = "begin to speak with multiple overlapping distorted voices:begins to speak with multiple overlapping distorted voices:NA",
            TERTIARY    = "begin speaking with a heavily distorted voice:begins speaking with a heavily distorted voice:NA",
            QUATERNARY  = "begin speaking with a distorted voice:begins speaking with a distorted voice:NA"
        }
    },
    {
        id = "PATIENCE",
        type = "MENTAL",
        buff_name = "Patience",
        buff_noun = "patience",
        
        id_prefix = "ENHANCEPATIENCE",
        secret_prefix = "ENHANCEPATIENCE",
        payload_prefix = "PATIENCEENHANCE",
        
        verbs = {
            PRIMARY     = "begin to visibly blur as you vibrate at immense speeds:begins to visibly blur as they vibrate at immense speeds:NA",
            SECONDARY   = "begin to visibly blur as you vibrate at high speeds:begins to visibly blur as they vibrate at high speeds:NA",
            TERTIARY    = "begin to blur slightly as you vibrate at high speeds:begins to blur slightly as they vibrate at high speeds:NA",
            QUATERNARY  = "begin to visibly vibrate:begins to visibly vibrate:NA"
        }
    },
    {
        id = "ANALYTICAL_ABILITY",
        type = "MENTAL",
        buff_name = "Analytical Ability",
        buff_noun = "analytical ability",
        usage_hint = "GREETING", -- CUSTOM USAGE HINT
        
        id_prefix = "ENHANCEANALYTICAL_ABILITY",
        secret_prefix = "ENHANCEANALYTICAL_ABILITY",
        payload_prefix = "ANALYTICAL_ABILITYENHANCE",
        
        verbs = {
            PRIMARY     = "emit holographic screens of scrolling data around your body:emits holographic screens of scrolling data around their body:NA",
            SECONDARY   = "emit holographic screens of scrolling data around your head:emits holographic screens of scrolling data around their head:NA",
            TERTIARY    = "emit a holographic screen of scrolling data around your head:emits a holographic screen of scrolling data around their head:NA",
            QUATERNARY  = "emit holographic lines of scrolling data around your body:emits holographic lines of scrolling data around their body:NA",
        }
    },

    -- =========================================================================
    -- SPEED
    -- Generator Type: "SPEED" -> Uses [CE_SPEED_CHANGE]
    -- =========================================================================
    {
        id = "SPEED_PERC", 
        type = "SPEED",
        buff_name = "Speed",
        buff_noun = "speed",
        
        id_prefix = "ENHANCESPEED",
        secret_prefix = "ENHANCESPEED",
        payload_prefix = "SPEEDENHANCE",
        
        verbs = {
            PRIMARY     = "extrude multiple large thruster rockets on the back and limbs of your body:extrudes multiple large thruster rockets on the back and limbs of their body:NA",
            SECONDARY   = "extrude several large thruster rockets on the back and limbs of your body:extrudes several large thruster rockets on the back and limbs of their body:NA",
            TERTIARY    = "extrude several large thruster rockets on the back your body:extrudes several large thruster rockets on the back of their body:NA",
            QUATERNARY  = "extrude a large thruster rocket on the back your body:extrudes a large thruster rocket on the back of their body:NA"
        }
    }
}