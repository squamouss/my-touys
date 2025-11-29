--[[
    MOD EXPERIMENT CONFIG (mod_experiment_config.lua)

    This is your "recipe book" for all experiment generation.
    Define your archetypes and experiment "recipes" here.
]]

-- ===========================================================================
-- GLOBAL SETTINGS
-- ===========================================================================

LOG_CURRENT_ENTRY = true

-- Requirement 2: Tracks generated creature tokens to prevent duplicates this worldgen
_G.MOD_GENERATED_EXPERIMENT_TOKENS = _G.MOD_GENERATED_EXPERIMENT_TOKENS or {}

-- ===========================================================================
-- ARCHETYPE DEFINITIONS
-- ===========================================================================

_G.MOD_ARCHETYPE_MAP = _G.MOD_ARCHETYPE_MAP or {
    ["UNCASTETRANSHUMAN"] = "TRANSHUMAN",
    ["UNCASTECYBORG"] = "UNCASTECYBORG", 
    ["SHELL"] = "SHELL",                 
    ["HUSK"] = "HUSK",
    
}

-- ===========================================================================
-- EXPERIMENT RECIPES (Requirements 1, 2, 3)
-- ===========================================================================

_G.MOD_EXPERIMENT_RECIPES = _G.MOD_EXPERIMENT_RECIPES or {
    
    {
        experimenter_archetype = "CYCASTE",
        subject_archetype = "UNCASTE", "LOCASTE", "HICASTE", "EXCASTE" 
        experiment_type = "humanoid",
        
        required_subject_tags = {"DEMIMACHINE"}, 
        
        config_file_to_use = "config_demimachine.lua",
        legends_string = "reassembling them into more pliable forms after much trauma and suffering",
        
        required_output_tags = {"SOPHONT", "MEDIUM"} 
    },
    {
        experimenter_archetype = "CYCASTE",
        subject_archetype = "UNCASTE", "LOCASTE", "HICASTE", "EXCASTE" 
        experiment_type = "humanoid",
        
        required_subject_tags = {"BIOMACHINE"}, 
        
        config_file_to_use = "config_biomachine.lua",
        legends_string = "rebirthing them as tools in their service in exchange for their lives",
        
        required_output_tags = {"SOPHONT", "MEDIUM"}
    },
    {
        experimenter_archetype = "CYCASTE",
        subject_archetype = "UNCASTE", "LOCASTE", "HICASTE", "EXCASTE" 
        experiment_type = "humanoid",
        
        required_subject_tags = {"EGOMACHINE"}, 
        
        config_file_to_use = "config_egomachine.lua",
        legends_string = "murdering them all in the process, and breaking their uploaded copies into submission",
        
        required_output_tags = {"SOPHONT", "MEDIUM"} 
    },
    
    -- FALLBACK RECIPE 
    {
        experimenter_archetype = "ANY",
        subject_archetype = "ANY",
        experiment_type = "ANY",
        
        config_file_to_use = nil, 
        
        legends_string = "after horrible experiments" 
    }
}

return {
    LOG_CURRENT_ENTRY = LOG_CURRENT_ENTRY,
    MOD_GENERATED_EXPERIMENT_TOKENS = _G.MOD_GENERATED_EXPERIMENT_TOKENS,
    MOD_ARCHETYPE_MAP = _G.MOD_ARCHETYPE_MAP,
    MOD_EXPERIMENT_RECIPES = _G.MOD_EXPERIMENT_RECIPES
}

