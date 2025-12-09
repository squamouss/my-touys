local log = _G.log or function(...) end
log("FIREWALL_RULES: Loading firewall calculation rules.")

local M = {}

M.ARCHETYPE_BASE = {
    ["LOCASTE"] = 0,
    ["HICASTE"] = 0,
    ["EXCASTE"] = 0,
    ["NUCASTE"] = 1,
    ["BIOMACHINE"] = 1,
    ["CYBERMACHINE"] = 2,
    ["NECROMACHINE"] = 1,
    ["NANOMACHINE"] = 1,
    ["HOLOMACHINE"] = 2,
    ["CHIMERA"] = 0,
    ["PROTOCHIMERA"] = 0,
    ["POLYMERID"] = 0,
    ["MACROCELL"] = 0,
    ["DEFAULT"] = 1
}


M.RATING_MODIFIERS = {

    ["INCURSION"] = 1,
    ["EXISTENTIAL"] = 2,
    ["AVATAR"] = 1,
    ["HOSTILE"] = 2,
	
    ["VESSEL"] = 0,
    ["DEVIANT"] = 0,
    ["SOPHONT"] = 0,
    
    ["DANGEROUS"] = 1,
    ["HAZARDOUS"] = 0,
    ["PROBLEMATIC"] = 0,
    ["BENIGN"] = -1,
    
    ["VERMIN"] = -2,
    ["AMBIENT"] = -3,
    
    ["DOMESTIC"] = -2,
    ["COMPANION"] = -3,
    ["SANITATION"] = -2,
    ["HUNTER"] = -2,
    ["MILITARY"] = 1,
    ["WEAPON"] = 1,
    ["VEHICLE"] = 1,
    ["NOMAD"] = 1,
    ["CARRIER"] = 0,
    ["SERVANT"] = 0,
    ["LABOR"] = -1,
    ["PRODUCT"] = -2
}

M.SUB_ARCHETYPE_MODIFIERS = {
    ["BLINDSIGHT"] = 1,    
    ["CYBORG"] = 0,    
    ["FULLBODY"] = 1,     
    ["HORROR"] = -1,    
    ["DEVIL"] = 1,     
    ["OGRE"] = 0,     
    ["HUMAN"] = 1,    
    ["ANDROID"] = 1,    
    ["INDUSTRIAL"] = 1,     
    ["DOLL"] = 0,     
    ["SCRAP"] = -1,
    ["WET"] = -1,    
    ["CORRUPT"] = 0,     
    ["PRISTINE"] = 1,   
    ["MECHA"] = 1,    
    ["SWARM"] = 0,     
    ["FRANKENSTEIN"] = -1,   
    ["HYBRID"] = 1,    
    ["GLITCH"] = 1,     
    ["FAIRY"] = 2,   
    ["UNKNOWN"] = 0
}

return M