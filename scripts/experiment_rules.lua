local log = _G.log or function(...) end

local config_biomachine = require("config_biomachine")
local config_cycaste = require("config_cycaste") 

local rules = {}

-- ============================================================================
-- UNIVERSAL FALLBACK CONFIGURATION
-- ============================================================================

rules.universal_fallback_profile = {
    config = config_nanomachine,
    forced_rating = "DEVIANT", 
    forced_sub_archetypes = {"WET"},
    forced_size = {"MDM", "LRG", "HGE"},
    description_generator = function(ctx)
        return " It was born from failed experiments, ambient N-matter sparking feral nanotechne colonies into half-formed life."
    end
}
-- ============================================================================
-- RULE STRUCTURE
-- ============================================================================
rules.outcomes_by_experimenter_tag = {
    
    ["BIOMACHINE"] = {
        sub_archetype_inheritance = {
            ["DEVIL"] = {"DEVIL", "HUMAN"}, 
            ["HUMAN"] = {"HUMAN", "DEVIL"},
            ["OGRE"] = {"OGRE"},            
            ["HORROR"] = {"HORROR"}
        },

        cases = {
            {
                required_secondary_tag = "SOPHONT",
                allowed_targets = {"LOCASTE", "HICASTE", "NUCASTE", "EXCASTE"},
                outcomes = {
                    {
                        config = config_biomachine,
                        forced_rating = "SOPHONT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was engineered by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " through retroviral injections and invasive surgeries."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "DEVIANT",
                allowed_targets = {"LOCASTE", "HICASTE", "NUCASTE", "EXCASTE"},
                outcomes = {
                    {
                        config = config_biomachine,
                        forced_rating = "DEVIANT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was engineered by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " through retroviral injections and invasive surgeries."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "AVATAR",
                allowed_targets = {"LOCASTE", "HICASTE", "NUCASTE", "EXCASTE", "CYCASTE"},
                outcomes = {
                    {
                        config = config_biomachine,
                        forced_rating = "SOPHONT",
                        weight = 100,
                        forced_size = {"LRG", "HGE", "GNT", "TTN"},
                        description_generator = function(ctx)
                            return " Its lineage was engineered by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " through great expenditure of N-matter, in exchange for servitude."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "INCURSION",
                allowed_targets = {"LOCASTE", "HICASTE", "NUCASTE", "EXCASTE"},
                outcomes = {
                    {
                        config = config_biomachine,
                        forced_rating = "VESSEL",
                        weight = 100,
                        forced_size = {"LRG", "HGE", "GNT", "TTN"},
                        description_generator = function(ctx)
                            return " Its lineage was engineered by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " through retroviral injections and invasive surgeries."
                        end
                    }
                }
            }
        }
    },
    
    ["CYBERMACHINE"] = {
        sub_archetype_inheritance = {
            ["ANDROID"] = {"ANDROID", "INDUSTRIAL"}, 
            ["DOLL"] = {"DOLL", "INDUSTRIAL"},
            ["INDUSTRIAL"] = {"INDUSTRIAL", "SCRAP"},            
            ["SCRAP"] = {"SCRAP"}
        },

        cases = {
            {
                required_secondary_tag = "SOPHONT",
                outcomes = {
                    {
                        config = config_cybermachine,
                        forced_rating = "SOPHONT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "DEVIANT",
                outcomes = {
                    {
                        config = config_cybermachine,
                        forced_rating = "DEVIANT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "INCURSION",
                outcomes = {
                    {
                        config = config_cybermachine,
                        forced_rating = "VESSEL",
                        weight = 100,
                        forced_size = {"LRG", "HGE", "GNT", "TTN"}, 
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            }
        }
    },

    ["NECROMACHINE"] = {
        sub_archetype_inheritance = {
            ["MECHA"] = {"MECHA", "FRANKENSTEIN"}, 
            ["SWARM"] = {"SWARM"},
            ["FRANKENSTEIN"] = {"FRANKENSTEIN", "MECHA"}
        },
        cases = {
            {
                required_secondary_tag = "SOPHONT",
                outcomes = {
                    {
                        config = config_necromachine,
                        forced_rating = "SOPHONT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "DEVIANT",
                outcomes = {
                    {
                        config = config_necromachine,
                        forced_rating = "DEVIANT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "INCURSION",
                outcomes = {
                    {
                        config = config_necromachine,
                        forced_rating = "VESSEL",
                        weight = 100,
                        forced_size = {"LRG", "HGE", "GNT", "TTN"}, 
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            }
        }
    },
	
    ["NANOMACHINE"] = {
        sub_archetype_inheritance = {
            ["PRISTINE"] = {"PRISTINE"}, 
            ["CORRUPT"] = {"CORRUPT", "WET"}, 
            ["WET"] = {"WET"}
        },
        cases = {
            {
                required_secondary_tag = "SOPHONT",
                outcomes = {
                    {
                        config = config_nanomachine,
                        forced_rating = "SOPHONT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "DEVIANT",
                outcomes = {
                    {
                        config = config_nanomachine,
                        forced_rating = "DEVIANT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "INCURSION",
                outcomes = {
                    {
                        config = config_nanomachine,
                        forced_rating = "VESSEL",
                        weight = 100,
                        forced_size = {"LRG", "HGE", "GNT", "TTN"}, 
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            }
        }
    },
	
    ["HOLOMACHINE"] = {
        sub_archetype_inheritance = {
            ["HYBRID"] = {"HYBRID", "FAIRY"}, 
            ["FAIRY"] = {"FAIRY", "HYBRID"},
            ["GLITCH"] = {"GLITCH"}
        },
        cases = {
            {
                required_secondary_tag = "SOPHONT",
                outcomes = {
                    {
                        config = config_holomachine,
                        forced_rating = "SOPHONT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "DEVIANT",
                outcomes = {
                    {
                        config = config_holomachine,
                        forced_rating = "DEVIANT",
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            },
            {
                required_secondary_tag = "INCURSION",
                outcomes = {
                    {
                        config = config_holomachine,
                        forced_rating = "VESSEL",
                        weight = 100,
                        forced_size = {"LRG", "HGE", "GNT", "TTN"}, 
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by scanning, eliminating, and copying the egos of the population."
                        end
                    }
                }
            }
        }
    },

    
    ["CYCASTE"] = {
        cases = {
            {
                outcomes = {
                    {
                        config = config_biomachine, 
                        forced_rating = "SOPHONT",
                        weight = 50,
                        forced_size = "any",
                        forced_sub_archetypes = {"OGRE"}, 
                        description_generator = function(ctx)
                            return " Its lineage was manufactured by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " from the defeated populace of their enemy."
                        end
                    },
                    {
                        config = config_cycaste, 
                        forced_rating = "SOPHONT", 
                        weight = 50,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was founded by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by granting defeated foes conversion in exchange for servitude."
                        end
                    }
                }
            }
        }
    },

    ["HICASTE"] = {
        cases = {
            {
                outcomes = {
                    {
                        config = config_cycaste, 
                        forced_rating = "SOPHONT", 
                        weight = 50,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was founded by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by granting defeated foes conversion in exchange for servitude."
                        end
                    }
                }
            }
        }
    },

    ["LOCASTE"] = {
        cases = {
            {
                outcomes = {
                    {
                        config = config_cycaste, 
                        forced_rating = "SOPHONT", 
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was founded by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by granting defeated foes conversion in exchange for servitude."
                        end
                    }
                }
            }
        }
    },

    ["NUCASTE"] = {
        cases = {
            {
                outcomes = {
                    {
                        config = config_cycaste, 
                        forced_rating = "SOPHONT", 
                        weight = 100,
                        forced_size = "any",
                        description_generator = function(ctx)
                            return " Its lineage was founded by " .. ctx.race .. " " .. ctx.name .. " of " .. ctx.civ .. " in " .. ctx.year .. " by granting defeated foes conversion in exchange for servitude."
                        end
                    }
                }
            }
        }
    }
}

return rules


