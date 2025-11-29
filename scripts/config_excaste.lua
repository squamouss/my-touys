
return {
    -- ============================================================================
    -- Basic Configuration
    -- ============================================================================
    ARCHETYPE_CLASS = "EXCASTE",
    MIN_CREATURES = 40,
    MAX_CREATURES = 80,
    BASE_CREATURE_NAME_PREFIX = "excaste ID",
    OUTPUT_FILENAME = "generated_excaste_creatures.txt",
    SAVE_TO_FILE_TOGGLE = true,
    SAVE_PARTIAL_OUTPUT_ON_ERROR = true,
    ENABLE_SIZE_AND_CHILD_GENERATION = true,

    -- ============================================================================
    -- Name & Component Configuration
    -- ============================================================================
    TRANSCENDENT_NAME_ROOT_SINGULAR = "excaste",
    TRANSCENDENT_NAME_ROOT_PLURAL = "excastes",

    TRAIT_NAME_MODIFIERS = {
        ["SOPHONT"] = "SPNT",
        ["HOSTILE"] = "HSTL", 
        ["VESSEL"] = "VSSL", 
        ["DEVIANT"] = "DVNT", 
        ["AVATAR"] = "AVTR", 
        ["INCURSION"] = "NCUR", 
		
        ["DANGEROUS"] = "DNGR",
        ["BENIGN"] = "BNGN", 
        ["HAZARDOUS"] = "HZRD", 
        ["PROBLEMATIC"] = "PRBM",
        ["EXISTENTIAL"] = "EXST",  
		
        ["VERMIN"] = "VRMN", 
        ["AMBIENT"] = "AMBT",
		
        ["DOMESTIC"] = "DMST",
        ["VEHICLE"] = "VHCL", 
        ["CARRIER"] = "CRER", 
        ["NOMAD"] = "NMAD", 
        ["WEAPON"] = "WEPN", 
        ["LABOR"] = "LABR", 
        ["SERVANT"] = "SRVT", 
        ["HUNTER"] = "HNTR", 
        ["SANITATION"] = "SNTN", 
        ["PRODUCT"] = "PRDC"
    },

    COMPONENT_TABLES = {
        { name = "component_1", table_key = "procgen_addon_table_1" },
    },

    -- ============================================================================
    -- RAW String Blocks
    -- ============================================================================
    BASE_RAWS = [[
        [COLOR:3:0:0]
        [CREATURE_CLASS:EXCASTE]
        [CREATURE_CLASS:UNPET]
        [CREATURE_CLASS:NOPOWER]
        [CREATURE_CLASS:ORGANIC_VULNERABLE]
	
	[PERSONALITY:CURIOUS:0:25:50]
	[PERSONALITY:BASHFUL:0:25:50]
	[PERSONALITY:PRIVACY:0:25:50]
	[PERSONALITY:THOUGHTLESSNESS:25:75:100]
	[PERSONALITY:ORDERLINESS:0:25:50]
	[PERSONALITY:IMAGINATION:0:25:50]
	[PERSONALITY:ABSTRACT_INCLINED:0:25:50]



        [GENERATED]
    ]],
    
    COMMON_BODY_DETAIL_RAWS = [[
	[SELECT_CASTE:ALL]

    [BODY_DETAIL_PLAN:STANDARD_MATERIALS]
        [BODY_DETAIL_PLAN:STANDARD_TISSUES]
        [BODY_DETAIL_PLAN:VERTEBRATE_TISSUE_LAYERS:SKIN:FAT:MUSCLE:BONE:CARTILAGE]
        [BODY_DETAIL_PLAN:CYBORG_MATERIALS]
        [BODY_DETAIL_PLAN:CYBORG_TISSUES]
        [BODY_DETAIL_PLAN:CYBORG_TISSUE_LAYERS:ENDOSKELETON:TUBE:EXTERIOR]
        [USE_MATERIAL_TEMPLATE:NAIL:NAIL_TEMPLATE]
        [USE_TISSUE_TEMPLATE:NAIL:NAIL_TEMPLATE]
        [TISSUE_LAYER:BY_CATEGORY:FINGER:NAIL:FRONT]
        [TISSUE_LAYER:BY_CATEGORY:TOE:NAIL:FRONT]
        [SELECT_TISSUE_LAYER:HEART:BY_CATEGORY:HEART]
        [PLUS_TISSUE_LAYER:SKIN:BY_CATEGORY:THROAT]
            [TL_MAJOR_ARTERIES]
        [BODY_DETAIL_PLAN:STANDARD_HEAD_POSITIONS]
        [BODY_DETAIL_PLAN:HUMANOID_HEAD_POSITIONS]
        [BODY_DETAIL_PLAN:HUMANOID_RIBCAGE_POSITIONS]
        [BODY_DETAIL_PLAN:HUMANOID_RELSIZES]
        [USE_MATERIAL_TEMPLATE:SINEW:SINEW_TEMPLATE]
        [TENDONS:LOCAL_CREATURE_MAT:SINEW:200]
        [LIGAMENTS:LOCAL_CREATURE_MAT:SINEW:200]
        [HAS_NERVES]
        [USE_MATERIAL_TEMPLATE:BLOOD:BLOOD_TEMPLATE]
        [BLOOD:LOCAL_CREATURE_MAT:BLOOD:LIQUID]
        [CREATURE_CLASS:GENERAL_POISON]
        [GETS_WOUND_INFECTIONS]
        [GETS_INFECTIONS_FROM_ROT]
        [USE_MATERIAL_TEMPLATE:PUS:PUS_TEMPLATE]
        [PUS:LOCAL_CREATURE_MAT:PUS:LIQUID]
        [USE_MATERIAL_TEMPLATE:SWEAT:SWEAT_TEMPLATE]
        [USE_MATERIAL_TEMPLATE:TEARS:TEARS_TEMPLATE]
        [USE_MATERIAL_TEMPLATE:SPIT:SPIT_TEMPLATE]
        [SECRETION:LOCAL_CREATURE_MAT:SWEAT:LIQUID:BY_CATEGORY:ALL:SKIN:EXERTION]
        [SECRETION:LOCAL_CREATURE_MAT:TEARS:LIQUID:BY_CATEGORY:EYE:ALL:EXTREME_EMOTION]
        [BODY_DETAIL_PLAN:HEAD_HAIR_TISSUE_LAYERS]
        [USE_TISSUE_TEMPLATE:EYEBROW:EYEBROW_TEMPLATE]
        [TISSUE_LAYER:BY_CATEGORY:HEAD:EYEBROW:ABOVE:BY_CATEGORY:EYE]
        [USE_TISSUE_TEMPLATE:EYELASH:EYELASH_TEMPLATE]
        [TISSUE_LAYER:BY_CATEGORY:EYELID:EYELASH:FRONT]
        [BODY_DETAIL_PLAN:FACIAL_HAIR_TISSUES]
        [BABY:1]
		
        [ATTACK:PUNCH:BODYPART:BY_TYPE:GRASP]
            [ATTACK_SKILL:GRASP_STRIKE]
            [ATTACK_VERB:punch:punches]
            [ATTACK_CONTACT_PERC:100]
            [ATTACK_PREPARE_AND_RECOVER:3:3]
            [ATTACK_FLAG_WITH]
            [ATTACK_PRIORITY:MAIN]
        [ATTACK:KICK:BODYPART:BY_TYPE:STANCE]
            [ATTACK_SKILL:STANCE_STRIKE]
            [ATTACK_VERB:kick:kicks]
            [ATTACK_CONTACT_PERC:100]
            [ATTACK_PREPARE_AND_RECOVER:4:4]
            [ATTACK_FLAG_WITH]
            [ATTACK_PRIORITY:SECOND]
            [ATTACK_FLAG_BAD_MULTIATTACK]
        [ATTACK:SCRATCH:CHILD_TISSUE_LAYER_GROUP:BY_TYPE:GRASP:BY_CATEGORY:FINGER:NAIL]
            [ATTACK_SKILL:GRASP_STRIKE]
            [ATTACK_VERB:scratch:scratches]
            [ATTACK_CONTACT_PERC:100]
            [ATTACK_PENETRATION_PERC:100]
            [ATTACK_FLAG_EDGE]
            [ATTACK_PREPARE_AND_RECOVER:3:3]
            [ATTACK_PRIORITY:SECOND]
        [ATTACK:BITE:CHILD_BODYPART_GROUP:BY_CATEGORY:HEAD:BY_CATEGORY:TOOTH]
            [ATTACK_SKILL:BITE]
            [ATTACK_VERB:bite:bites]
            [ATTACK_CONTACT_PERC:100]
            [ATTACK_PENETRATION_PERC:100]
            [ATTACK_FLAG_EDGE]
            [ATTACK_PREPARE_AND_RECOVER:3:3]
            [ATTACK_PRIORITY:SECOND]
            [ATTACK_FLAG_CANLATCH]
        [SMELL_TRIGGER:90]
        [HOMEOTHERM:10067]
        [MUNDANE]
        [DIURNAL]
        [MANNERISM_FINGERS:finger:fingers]
        [MANNERISM_NOSE:nose]
        [MANNERISM_EAR:ear]
        [MANNERISM_HEAD:head]
        [MANNERISM_EYES:eyes]
        [MANNERISM_MOUTH:mouth]
        [MANNERISM_HAIR:hair]
        [MANNERISM_KNUCKLES:knuckles]
        [MANNERISM_LIPS:lips]
        [MANNERISM_CHEEK:cheek]
        [MANNERISM_NAILS:nails]
        [MANNERISM_FEET:feet]
        [MANNERISM_ARMS:arms]
        [MANNERISM_HANDS:hands]
        [MANNERISM_TONGUE:tongue]
        [MANNERISM_LEG:leg]
        [MANNERISM_LAUGH]
        [MANNERISM_SMILE]
        [MANNERISM_WALK]
        [MANNERISM_SIT]
        [MANNERISM_BREATH]
        [MANNERISM_POSTURE]
        [MANNERISM_STRETCH]
        [MANNERISM_EYELIDS]h
	[APPLY_CREATURE_VARIATION:STANDARD_CRAWLING_GAITS:2990:2257:1525:731:4300:6100] 12 kph, NO DATA
    ]],

    COMMON_APPEARANCE_RAWS = [[
        [BODY_APPEARANCE_MODIFIER:HEIGHT:75:95:98:100:102:105:125]
            [APP_MOD_IMPORTANCE:500]
        [BODY_APPEARANCE_MODIFIER:BROADNESS:75:95:98:100:102:105:125]
            [APP_MOD_IMPORTANCE:500]
        [SET_BP_GROUP:BY_CATEGORY:EYE]
            [BP_APPEARANCE_MODIFIER:CLOSE_SET:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:eyes:PLURAL]
            [BP_APPEARANCE_MODIFIER:DEEP_SET:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:eyes:PLURAL]
            [BP_APPEARANCE_MODIFIER:ROUND_VS_NARROW:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:eyes:PLURAL]
            [BP_APPEARANCE_MODIFIER:LARGE_IRIS:25:70:90:100:110:130:200]
                [APP_MOD_NOUN:eyes:PLURAL]
                [APP_MOD_DESC_RANGE:30:60:90:110:150:190]
        [SET_BP_GROUP:BY_CATEGORY:LIP]
            [BP_APPEARANCE_MODIFIER:THICKNESS:50:70:90:100:110:130:200]
                [APP_MOD_NOUN:lips:PLURAL]
                [APP_MOD_DESC_RANGE:55:70:90:110:150:190]
        [SET_BP_GROUP:BY_CATEGORY:NOSE]
            [BP_APPEARANCE_MODIFIER:BROADNESS:25:70:90:100:110:130:200]
                [APP_MOD_DESC_RANGE:30:60:90:110:150:190]
            [BP_APPEARANCE_MODIFIER:LENGTH:25:70:90:100:110:130:200]
                [APP_MOD_DESC_RANGE:30:60:90:110:150:190]
            [BP_APPEARANCE_MODIFIER:UPTURNED:0:70:90:100:110:130:200]
            [BP_APPEARANCE_MODIFIER:CONVEX:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:nose bridge:SINGULAR]
        [SET_BP_GROUP:BY_CATEGORY:EAR]
            [BP_APPEARANCE_MODIFIER:SPLAYED_OUT:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:ears:PLURAL]
            [BP_APPEARANCE_MODIFIER:HANGING_LOBES:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:ears:PLURAL]
            [BP_APPEARANCE_MODIFIER:BROADNESS:90:95:98:100:102:105:110]
                [APP_MOD_IMPORTANCE:700]
                [APP_MOD_NOUN:ears:PLURAL]
                [APP_MOD_DESC_RANGE:91:94:98:102:106:109]
            [BP_APPEARANCE_MODIFIER:HEIGHT:90:95:98:100:102:105:110]
                [APP_MOD_IMPORTANCE:700]
                [APP_MOD_NOUN:ears:PLURAL]
                [APP_MOD_DESC_RANGE:91:94:98:102:106:109]
        [SET_BP_GROUP:BY_CATEGORY:TOOTH]
            [BP_APPEARANCE_MODIFIER:GAPS:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:teeth:PLURAL]
        [SET_BP_GROUP:BY_CATEGORY:SKULL]
            [BP_APPEARANCE_MODIFIER:HIGH_CHEEKBONES:0:70:90:100:110:130:200]
            [BP_APPEARANCE_MODIFIER:BROAD_CHIN:0:70:90:100:110:130:200]
            [BP_APPEARANCE_MODIFIER:JUTTING_CHIN:0:70:90:100:110:130:200]
            [BP_APPEARANCE_MODIFIER:SQUARE_CHIN:0:70:90:100:110:130:200]
        [SET_BP_GROUP:BY_CATEGORY:THROAT]
            [BP_APPEARANCE_MODIFIER:DEEP_VOICE:0:70:90:100:110:130:200]
            [BP_APPEARANCE_MODIFIER:RASPY_VOICE:0:70:90:100:110:130:200]
        [SET_BP_GROUP:BY_CATEGORY:HEAD]
            [BP_APPEARANCE_MODIFIER:BROADNESS:90:95:98:100:102:105:110]
                [APP_MOD_IMPORTANCE:700]
                [APP_MOD_DESC_RANGE:91:94:98:102:106:109]
            [BP_APPEARANCE_MODIFIER:HEIGHT:90:95:98:100:102:105:110]
                [APP_MOD_IMPORTANCE:700]
                [APP_MOD_DESC_RANGE:91:94:98:102:106:109]
        [SET_TL_GROUP:BY_CATEGORY:EYE:EYE]
		[TL_COLOR_MODIFIER:BLACK:1:BLACK:1:BLACK:1:BLACK:1:BLACK:1:BLACK:1:BLACK:1:BLACK:1:BLACK:1:BLACK:1]
                [TLCM_NOUN:eyes:PLURAL]
			[TL_COLOR_MODIFIER:GRAY:1]
				[TLCM_NOUN:crash avoiding placeholder:SINGULAR]
				[TLCM_TIMING:ROOT:50000:0:90000:0]
		
    ]],

    -- ============================================================================
    -- Data Tables
    -- ============================================================================
    generic_creature_lore_snippets = {
        "The Excaste are humans who have broken free from the genetic caste system of the Solar Empire without exceeding the capabilities of the rest of pan-humanity, in this case through extreme biomodding into forms more capable of survival in the wild Megastructures. A relic of both the Transitional Era and the Fade, populations who sought to correct their damaged genomes or adapt to the new, hostile environment of the Megastructures without fully understanding the dangers often diverged from humanity to the point of excasteerating into nonsapient fauna. While some species persist as sophonts, others have been subsumed by the posthuman technosystem of the Long Night, becoming another danger for travellers and prey for even worse monstrosities. ",
    },

    interaction_rating = {
        {
            desc_part = "It is classified as Sophontic; it is an intelligent being capable of reason and metacognition, aligned with human values and psychology. ",
            tok = {[[
            [INTELLIGENT][EQUIPS][CANOPENDOORS][OUTSIDER_CONTROLLABLE][LOCAL_POPS_PRODUCE_HEROES]
            [BENIGN]
            [CREATURE_CLASS:SOPHONT]
            ]]},
            tags = {"SOPHONT"},
            weight = 5,
            enabled = true,
            minimum_number = 1
        },
        {
            desc_part = "It is classified as Hostile; while effectively sapient in terms of problem solving skill, its behaviors are dictated by deep-set programming which align it against other sophonts. ",
            tok = {[[
            [INTELLIGENT][EQUIPS][CANOPENDOORS]
            [NIGHT_CREATURE_HUNTER]	
            [LAIR_HUNTER]
            [LAIR:SIMPLE_BURROW:50]
            [LAIR:SIMPLE_MOUND:50]
            [LAIR:LABYRINTH:25]
            [LAIR:SHRINE:25]
            [LAIR_CHARACTERISTIC:HAS_DOORS:50]
            [HABIT_NUM:TEST_ALL]
            [HABIT:GRIND_BONE_MEAL:50]
            [HABIT:COOK_BLOOD:50]
            [HABIT:GRIND_VERMIN:50]
            [HABIT:COOK_VERMIN:50]
            [HABIT:COOK_PEOPLE:50]
            [HABIT:COLLECT_TROPHIES:50]
            [HABIT:COLLECT_WEALTH:50]
            [HABIT:USE_ANY_MELEE_WEAPON:100]
            [CREATURE_CLASS:HOSTILE]
            [FREQUENCY:5]
            ]]},
            tags = {"HOSTILE"},
            weight = 5,
            enabled = true,
            minimum_number = 0 
        },
        {
            desc_part = "It is classified as Existential; It represents a threat to entire settlements or even civilizations and cannot be reasoned with. ",
            tok = {[[
            [ATTACK_TRIGGER:3:3:3]
            [BUILDINGDESTROYER:2]
            [FEATURE_BEAST]
            [CREATURE_CLASS:EXISTENTIAL]
            ]]},
            tags = {"EXISTENTIAL"},
            weight = 1,
            enabled = false,
            minimum_number = 0 
        },
        {
            desc_part = "It is classified as Dangerous; it is an active threat to other organisms and will deliberately harm or kill those it comes across, and is capable of and willing to target sophonts. ",
            tok = {[[
            [LARGE_PREDATOR][CRAZED][AMBUSHPREDATOR]
            
            [CREATURE_CLASS:DANGEROUS]
            [FREQUENCY:10]
            ]]},
            tags = {"DANGEROUS"},
            weight = 10,
            enabled = true,
            minimum_number = 0 
        },
        {
            desc_part = "It is classified as Hazardous; it does not deliberately prey on other organisms but will attack any that come near, and may come into conflict with sophonts over mutual food or energy sources. ",
            tok = {[[
            [CURIOUSBEAST_GUZZLER][CURIOUSBEAST_EATER]
            
            [CREATURE_CLASS:HAZARDOUS]
            [FREQUENCY:20]
            ]]},
            tags = {"HAZARDOUS"},
            weight = 30,
            enabled = true,
            minimum_number = 0 
        },
        {
            desc_part = "It is classified as Benign; it avoids conflict and generally does not pose a danger unless in an extreme situation, and will generally avoid the attention of sophonts. ",
            tok = {[[
            [BENIGN]
            [CREATURE_CLASS:BENIGN]
            [FREQUENCY:50]
            ]]},
            tags = {"BENIGN"},
            weight = 30,
            enabled = true,
            minimum_number = 0 
        },
        {
            desc_part = "It is classified as Problematic; it generally avoids violence but may steal supplies, food, or energy stores, and can infiltrate poorly maintained settlements and otherwise cause minor issues. ",
            tok = {[[
            [CURIOUSBEAST_GUZZLER][CURIOUSBEAST_EATER][CURIOUSBEAST_ITEM]
            [TRAPAVOID][MISCHIEVOUS][BENIGN]
            
            [CREATURE_CLASS:PROBLEMATIC]
            [FREQUENCY:30]
            ]]},
            tags = {"PROBLEMATIC"},
            weight = 20,
            enabled = true,
            minimum_number = 0 
        },
        {
            desc_part = "It is classified as Vermin; it is very small but can infest settlements or otherwise inconvenience other organisms. ",
            tok = {[[
            [FISHITEM]
            [CREATURE_CLASS:VERMIN]
            [FREQUENCY:100]
            ]]},
            tags = {"VERMIN"},
            weight = 10,
            enabled = false
        },
        {
            desc_part = "It is classified as Ambient; it is very small and mostly benign. ",
            tok = {[[
            [FISHITEM]
            [CREATURE_CLASS:AMBIENT]
            [FREQUENCY:100]
            ]]},
            tags = {"AMBIENT"},
            weight = 10,
            enabled = false
        },
        {
            desc_part = "It is classified as Deviant; it is an intelligent being capable of reason and metacognition, but has abandoned or lost human values and psychology in favor of competitiveness within the technosystem. ",
            tok = {[[
            [INTELLIGENT][EQUIPS][CANOPENDOORS][OUTSIDER_CONTROLLABLE][LOCAL_POPS_PRODUCE_HEROES]
            
            [CREATURE_CLASS:DEVIANT]            [COLOR:3:0:0]

            ]]},
            tags = {"DEVIANT"},
            weight = 5,
            enabled = false,
            minimum_number = 1
        },
        {
            desc_part = "It is classified as an Avatar; it is a host body of an immense hyperintelligence within the Datasphere. ",
            tok = {[[
            [INTELLIGENT][EQUIPS][CANOPENDOORS]
            
            [CREATURE_CLASS:AVATAR][POWER]            [COLOR:3:0:0]
			[POWER]

            ]]},
            tags = {"AVATAR"},
            weight = 1,
            enabled = false,
            minimum_number = 1
        },
        {
            desc_part = "It is classified as a Vessel; it is a node of a distributed system or intelligence, bound to the will of its creator. ",
            tok = {[[
            [CAN_LEARN][EQUIPS][CANOPENDOORS]
            
            [CREATURE_CLASS:VESSEL]            [COLOR:3:0:0]

            ]]},
            tags = {"VESSEL"},
            weight = 1,
            enabled = false
        }
    },

    generic_body_size_variants = {
        {
            name_part = "MCR",
            desc_part = "It is approximately %su in mass. ",
            min_raw_size_factor = 1,
            base_adult_size_for_random = 1,
            body_size_index_and_child_count = 0,
            eligible_rating_tags = {"AMBIENT", "VERMIN"},
            size_tags = {"MICRO"}, 
            tok = {[[
            [VERMIN_MICRO]
            [SMALL_REMAINS][VERMIN_HATEABLE]
            [CREATURE_TILE:250]
            [POPULATION_NUMBER:5000:10000]
            ]]}, 
            weight = 10, 
            enabled = false
        },
        {
            name_part = "MNL", 
            desc_part = "It is approximately %su in mass. ",
            min_raw_size_factor = 10,
            base_adult_size_for_random = 10, 
            body_size_index_and_child_count = 0, 
            eligible_rating_tags = {"AMBIENT", "VERMIN"},
            size_tags = {"MINIMAL"}, 
            tok = {[[
            [VERMIN_GROUNDER]
            [NOT_BUTCHERABLE][SMALL_REMAINS][VERMIN_HATEABLE]
            [CREATURE_TILE:250]
            [POPULATION_NUMBER:1000:2000]
            ]]}, 
            weight = 10, 
            enabled = false
        },
        {
            name_part = "SML", 
            desc_part = "It is approximately %su in mass. ",
            min_raw_size_factor = 100,
            base_adult_size_for_random = 100,
            body_size_index_and_child_count = 0,
            eligible_rating_tags = {"AMBIENT", "VERMIN", "BENIGN", "PROBLEMATIC"},
            size_tags = {"SMALL"}, 
            tok = {[[
            [VERMIN_GROUNDER]
            [NOT_BUTCHERABLE][SMALL_REMAINS][VERMIN_HATEABLE]
            [CREATURE_TILE:249]
            [POPULATION_NUMBER:500:1000]
            ]]}, 
            weight = 10, 
            enabled = false
        },
        {
            name_part = "LSR", 
            desc_part = "It is approximately %su in mass. ",
            min_raw_size_factor = 10,
            base_adult_size_for_random = 1000,
            body_size_index_and_child_count = 1,
            eligible_rating_tags = {"BENIGN", "PROBLEMATIC"},
            size_tags = {"LESSER"}, 
            tok = {[[
            [CREATURE_TILE:'e'][CREATURE_CLASS:SIZE_LESSER]
            
            [POPULATION_NUMBER:250:500]
            ]]}, 
            weight = 30, 
            enabled = true
        },
        {
            name_part = "MDM",
            desc_part = "It is approximately %su in mass. ",
            min_raw_size_factor = 100,
            base_adult_size_for_random = 10000,
            body_size_index_and_child_count = 5,
            eligible_rating_tags = {"HAZARDOUS", "BENIGN", "PROBLEMATIC", "SOPHONT", "HOSTILE", "DANGEROUS"},
            size_tags = {"MEDIUM"}, 
            weight = 70, 
            favored_size_multiplier_enabled = true, 
            rating_specific_weights = { 
            ["SOPHONT"] = { [1]=0, [2]=0, [3]=0, [4]=0, [5]=10, [6]=10, [7]=40, [8]=20, [9]=10 }, 
            ["DEVIANT"] = { [1]=0, [2]=0, [3]=0, [4]=0, [5]=10, [6]=10, [7]=40, [8]=20, [9]=10 }, 
            ["HOSTILE"] = { [1]=0, [2]=0, [3]=0, [4]=0, [5]=10, [6]=10, [7]=40, [8]=20, [9]=10 }, 
            ["VESSEL"] =  { [1]=0, [2]=0, [3]=0, [4]=0, [5]=10, [6]=10, [7]=40, [8]=20, [9]=10 }, 
			},
            tok = {[[
           
        [CREATURE_TILE:'e']
        [CREATURE_SOLDIER_TILE:137]CREATURE_CLASS:SIZE_MEDIUM]
            
            [POPULATION_NUMBER:50:200]
            [CREATURE_CLASS:NORMALHEAD]
            [CREATURE_CLASS:NORMALARMS]
            [CREATURE_CLASS:NORMALSHOULDERS]
            [CREATURE_CLASS:NORMALHIPS]
            [CREATURE_CLASS:NORMALLEGS]
            [CREATURE_CLASS:NORMALBODY]
            ]]}, 
            enabled = true
        },
        {
            name_part = "LRG", 
            desc_part = "This variant is approximately %su in mass. ",
            min_raw_size_factor = 1000,
            base_adult_size_for_random = 100000,
            body_size_index_and_child_count = 10,
            eligible_rating_tags = {"DANGEROUS", "HAZARDOUS", "SOPHONT", "HOSTILE"},
            size_tags = {"LARGE"}, 
            weight = 10, 
        favored_size_multiplier_enabled = true,
			rating_specific_weights = {
				["SOPHONT"] = { [1]=90, [2]=80, [3]=70, [4]=60, [5]=50, [6]=40, [7]=30, [8]=20, [9]=10 }, 
				["DEVIANT"] = { [1]=90, [2]=80, [3]=70, [4]=60, [5]=50, [6]=40, [7]=30, [8]=20, [9]=10 }, 
				["HOSTILE"] = { [1]=90, [2]=80, [3]=70, [4]=60, [5]=50, [6]=40, [7]=30, [8]=20, [9]=10 }, 
				["VESSEL"] =  { [1]=90, [2]=80, [3]=70, [4]=60, [5]=50, [6]=40, [7]=30, [8]=20, [9]=10 }, 
				},
            tok = {[[
            [CREATURE_TILE:'E'][CREATURE_CLASS:SIZE_LARGE]
            
            [POPULATION_NUMBER:20:100]
            [CREATURE_CLASS:LARGEHEAD]
            [CREATURE_CLASS:LARGEARMS]
            [CREATURE_CLASS:LARGESHOULDERS]
            [CREATURE_CLASS:LARGEHIPS]
            [CREATURE_CLASS:LARGELEGS]
            [CREATURE_CLASS:LARGEBODY]
            ]]}, 
            enabled = true
        },
        {
            name_part = "HGE",
            desc_part = "This variant is approximately %su in mass. ",
            min_raw_size_factor = 10000,
            base_adult_size_for_random = 1000000,
            body_size_index_and_child_count = 15,
            eligible_rating_tags = {"DANGEROUS", "HAZARDOUS", "SOPHONT", "HOSTILE", "BENIGN", "EXISTENTIAL"},
            size_tags = {"HUGE"}, 
            tok = {[[
            [CREATURE_TILE:'E'][CREATURE_CLASS:SIZE_HUGE][SAVAGE]
            
            [POPULATION_NUMBER:10:50]
            [CREATURE_CLASS:HUGEHEAD]
            [CREATURE_CLASS:HUGEARMS]
            [CREATURE_CLASS:HUGESHOULDERS]
            [CREATURE_CLASS:HUGEHIPS]
            [CREATURE_CLASS:HUGELEGS]
            [CREATURE_CLASS:HUGEBODY]
            ]]}, 
            weight = 10, 
            enabled = false
        },
        {
            name_part = "GNT", 
            desc_part = "This variant is approximately %su in mass. ",
            min_raw_size_factor = 10000,
            base_adult_size_for_random = 10000000,
            body_size_index_and_child_count = 20,
            eligible_rating_tags = {"DANGEROUS", "HAZARDOUS", "HOSTILE", "BENIGN", "EXISTENTIAL"},
            size_tags = {"GIANT"}, 
            tok = {[[
            [CREATURE_TILE:'E'][CREATURE_CLASS:SIZE_GIANT]
            
            [POPULATION_NUMBER:5:10]
            [CREATURE_CLASS:HUGEHEAD]
            [CREATURE_CLASS:HUGEARMS]
            [CREATURE_CLASS:HUGESHOULDERS]
            [CREATURE_CLASS:HUGEHIPS]
            [CREATURE_CLASS:HUGELEGS]
            [CREATURE_CLASS:HUGEBODY]
            ]]}, 
            weight = 2,
            enabled = false
        },
        {
            name_part = "TTN", 
            desc_part = "This variant is approximately %su in mass. ",
            min_raw_size_factor = 10000,
            base_adult_size_for_random = 100000000,
            body_size_index_and_child_count = 20,
            eligible_rating_tags = {"EXISTENTIAL"},
            size_tags = {"TITANIC"}, 
            tok = {[[
            [CREATURE_TILE:'E'][CREATURE_CLASS:SIZE_TITAN]
            ]]}, 
            weight = 1,
            enabled = false
        }
    },

    procgen_addon_table_1 = {
        {
            body_token = "HUMANOID_NECK:2EYES:2EARS:NOSE:2LUNGS:HEART:GUTS:ORGANS:HUMANOID_JOINTS:THROAT:NECK:SPINE:BRAIN:SKULL:5FINGERS:5TOES:MOUTH:TONGUE:FACIAL_FEATURES:TEETH:RIBCAGE",
            transcendent_body_token = "HUMANOID_NECK:2EYES:HUMANOID_JOINTS:5FINGERS:5TOES:NOSE:2EARS:FACIAL_FEATURES:MOUTH:TEETH2:CORE", 
            desc_part = "A humanoid with a mixture of primitive and uncanny facial features; eyes without whites, a prognathous jaw, a short forehead. A robust excaste configuration notorious for its success, both among its sophonts and the beasts they so often become. ",
            transcendent_desc_part = "A postbiological organism resembling an uncanny, bestial humanoid in body plan, comprised entirely synthetic tissues derived from N-matter, merging the regenerative powers of biology with the durability and strength of machinery. It has a set of mechanical ports along its spine that can interface with vehicles or cybernetic enhancements, and its body is partially covered with metal plating and cybernetics, density and configuration varying by individual. ",
            eligible_rating_tags = {"SOPHONT", "HOSTILE"},
            eligible_size_tags = {"MEDIUM", "LARGE"}, 
            tok = {[[
			
        [SET_TL_GROUP:BY_CATEGORY:ALL:SKIN]
            [TL_COLOR_MODIFIER:PALE_PINK:1:PINK:1:PALE_TAN:1:TAN:1:DARK_TAN:1:PALE_BROWN:1:BROWN:1:DARK_BROWN:1:YELLOW_BROWN:1:PALE_YELLOW:1]
                [TLCM_NOUN:skin:SINGULAR]
			[TL_COLOR_MODIFIER:GRAY:1]
				[TLCM_NOUN:crash avoiding placeholder:SINGULAR]
				[TLCM_TIMING:ROOT:50000:0:90000:0]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:WRINKLY:0:0:0:0:0:0:0]
                [APP_MOD_RATE:1:YEARLY:0:100:40:0:NO_END]
                [APP_MOD_NOUN:skin:SINGULAR]
                [APP_MOD_DESC_RANGE:0:0:0:1:25:50]
				
		
        [SET_TL_GROUP:BY_CATEGORY:HEAD:HAIR]
         [PLUS_TL_GROUP:BY_CATEGORY:CHEEK:CHEEK_WHISKERS]
         [PLUS_TL_GROUP:BY_CATEGORY:HEAD:CHIN_WHISKERS]
         [PLUS_TL_GROUP:BY_CATEGORY:HEAD:MOUSTACHE]
         [PLUS_TL_GROUP:BY_CATEGORY:HEAD:SIDEBURNS]
         [PLUS_TL_GROUP:BY_CATEGORY:HEAD:EYEBROW]
         [PLUS_TL_GROUP:BY_CATEGORY:EYELID:EYELASH]
                        [TL_COLOR_MODIFIER:BLACK:1:LIGHT_BROWN:1:BROWN:1:DARK_BROWN:1:LIGHT_YELLOW:1:RED_BROWN:1:YELLOW_BROWN:1:WHITE:1:RED:1:BLUE_GRAY:1]
                [TLCM_NOUN:hair:SINGULAR]
            [TL_COLOR_MODIFIER:GRAY:1]
                [TLCM_NOUN:hair:SINGULAR]
                [TLCM_TIMING:ROOT:50:0:90:0]
        [SET_TL_GROUP:BY_CATEGORY:HEAD:EYEBROW]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:LENGTH:50:80:90:100:110:120:150]
                [APP_MOD_NOUN:eyebrows:PLURAL]
                [APP_MOD_DESC_RANGE:55:70:90:110:130:145]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:DENSE:50:80:90:100:110:120:150]
                [APP_MOD_NOUN:eyebrows:PLURAL]
                [APP_MOD_DESC_RANGE:55:70:90:110:130:145]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:HIGH_POSITION:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:eyebrows:PLURAL]
        [SET_TL_GROUP:BY_CATEGORY:EYELID:EYELASH]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:LENGTH:50:80:90:100:110:120:150]
                [APP_MOD_NOUN:eyelashes:PLURAL]
                [APP_MOD_DESC_RANGE:55:70:90:110:130:145]
        [SET_TL_GROUP:BY_CATEGORY:HEAD:HAIR]
         [PLUS_TL_GROUP:BY_CATEGORY:CHEEK:CHEEK_WHISKERS]
         [PLUS_TL_GROUP:BY_CATEGORY:HEAD:CHIN_WHISKERS]
         [PLUS_TL_GROUP:BY_CATEGORY:HEAD:MOUSTACHE]
         [PLUS_TL_GROUP:BY_CATEGORY:HEAD:SIDEBURNS]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:LENGTH:0:0:0:0:0:0:0]
                [APP_MOD_NOUN:hair:SINGULAR]
                [APP_MOD_RATE:1:DAILY:0:1000:0:0:NO_END]
                [APP_MOD_DESC_RANGE:10:25:75:125:200:300]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:CURLY:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:hair:SINGULAR]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:GREASY:0:70:90:100:110:130:200]
                [APP_MOD_NOUN:hair:SINGULAR]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:DENSE:50:80:90:100:110:120:150]
                [APP_MOD_NOUN:hair:SINGULAR]
                [APP_MOD_DESC_RANGE:55:70:90:110:130:145]
        [SET_TL_GROUP:BY_CATEGORY:HEAD:HAIR]
            [TISSUE_STYLE_UNIT:HAIR:STANDARD_HAIR_SHAPINGS]
                [TSU_NOUN:hair:SINGULAR]
        [SET_TL_GROUP:BY_CATEGORY:HEAD:CHEEK_WHISKERS]
         [PLUS_TL_GROUP:BY_CATEGORY:HEAD:CHIN_WHISKERS]
            [TISSUE_STYLE_UNIT:BEARD:STANDARD_BEARD_SHAPINGS]
                [TSU_NOUN:beard:SINGULAR]
        [SET_TL_GROUP:BY_CATEGORY:HEAD:MOUSTACHE]
            [TISSUE_STYLE_UNIT:MOUSTACHE:STANDARD_MOUSTACHE_SHAPINGS]
                [TSU_NOUN:moustache:SINGULAR]
        [SET_TL_GROUP:BY_CATEGORY:HEAD:SIDEBURNS]
            [TISSUE_STYLE_UNIT:SIDEBURNS:STANDARD_SIDEBURNS_SHAPINGS]
                [TSU_NOUN:sideburns:PLURAL]
			
			]]}, 
			transcendent_tok = {[[
			
			
			[SET_TL_GROUP:BY_CATEGORY:ALL:SKIN]
			[TL_COLOR_MODIFIER:LIGHT_GRAY:1:DARK_GRAY:1:GRAY:1:LIGHT_GRAY:1:DARK_GRAY:1:GRAY:1:WHITE:1:BLACK:1:WHITE:1:BLACK:1]
				[TLCM_NOUN:integument:SINGULAR]
			[TL_COLOR_MODIFIER:GRAY:1]
				[TLCM_NOUN:crash avoiding placeholder:SINGULAR]
				[TLCM_TIMING:ROOT:50000:0:90000:0]
			
		[SET_TL_GROUP:BY_CATEGORY:HEAD:HAIR]
		 [PLUS_TL_GROUP:BY_CATEGORY:CHEEK:CHEEK_WHISKERS]
		 [PLUS_TL_GROUP:BY_CATEGORY:HEAD:CHIN_WHISKERS]
		 [PLUS_TL_GROUP:BY_CATEGORY:HEAD:MOUSTACHE]
		 [PLUS_TL_GROUP:BY_CATEGORY:HEAD:SIDEBURNS]
		 [PLUS_TL_GROUP:BY_CATEGORY:HEAD:EYEBROW]
		 [PLUS_TL_GROUP:BY_CATEGORY:EYELID:EYELASH]
            [TL_COLOR_MODIFIER:BLACK:1:WHITE:1:GRAY:1:LIGHT_GRAY:1:DARK_GRAY:1:WHITE:1:BLACK:1:CLEAR:1:CLEAR:1:GRAY:1]
				[TLCM_NOUN:hair:SINGULAR]
			[TL_COLOR_MODIFIER:GRAY:1]
				[TLCM_NOUN:crash avoiding placeholder:SINGULAR]
				[TLCM_TIMING:ROOT:50000:0:90000:0]
		
		[SET_TL_GROUP:BY_CATEGORY:HEAD:EYEBROW]
			[TISSUE_LAYER_APPEARANCE_MODIFIER:LENGTH:50:80:90:100:110:120:150]
				[APP_MOD_NOUN:eyebrows:PLURAL]
				[APP_MOD_DESC_RANGE:55:70:90:110:130:145]
			[TISSUE_LAYER_APPEARANCE_MODIFIER:DENSE:50:80:90:100:110:120:150]
				[APP_MOD_NOUN:eyebrows:PLURAL]
				[APP_MOD_DESC_RANGE:55:70:90:110:130:145]
			[TISSUE_LAYER_APPEARANCE_MODIFIER:HIGH_POSITION:0:70:90:100:110:130:200]
				[APP_MOD_NOUN:eyebrows:PLURAL]
		[SET_TL_GROUP:BY_CATEGORY:EYELID:EYELASH]
			[TISSUE_LAYER_APPEARANCE_MODIFIER:LENGTH:50:80:90:100:110:120:150]
				[APP_MOD_NOUN:eyelashes:PLURAL]
				[APP_MOD_DESC_RANGE:55:70:90:110:130:145]
		[SET_TL_GROUP:BY_CATEGORY:HEAD:HAIR]
		 [PLUS_TL_GROUP:BY_CATEGORY:CHEEK:CHEEK_WHISKERS]
		 [PLUS_TL_GROUP:BY_CATEGORY:HEAD:CHIN_WHISKERS]
		 [PLUS_TL_GROUP:BY_CATEGORY:HEAD:MOUSTACHE]
		 [PLUS_TL_GROUP:BY_CATEGORY:HEAD:SIDEBURNS]
			[TISSUE_LAYER_APPEARANCE_MODIFIER:LENGTH:0:0:0:0:0:0:0]
				[APP_MOD_NOUN:hair:SINGULAR]
				[APP_MOD_RATE:1:DAILY:0:1000:0:0:NO_END]
				[APP_MOD_DESC_RANGE:10:25:75:125:200:300]
			[TISSUE_LAYER_APPEARANCE_MODIFIER:CURLY:0:70:90:100:110:130:200]
				[APP_MOD_NOUN:hair:SINGULAR]
		[SET_TL_GROUP:BY_CATEGORY:HEAD:HAIR]
			[TISSUE_STYLE_UNIT:HAIR:STANDARD_HAIR_SHAPINGS]
				[TSU_NOUN:hair:SINGULAR]
		[SET_TL_GROUP:BY_CATEGORY:HEAD:CHEEK_WHISKERS]
		 [PLUS_TL_GROUP:BY_CATEGORY:HEAD:CHIN_WHISKERS]
			[TISSUE_STYLE_UNIT:BEARD:STANDARD_BEARD_SHAPINGS]
				[TSU_NOUN:beard:SINGULAR]
		[SET_TL_GROUP:BY_CATEGORY:HEAD:MOUSTACHE]
			[TISSUE_STYLE_UNIT:MOUSTACHE:STANDARD_MOUSTACHE_SHAPINGS]
				[TSU_NOUN:moustache:SINGULAR]
		[SET_TL_GROUP:BY_CATEGORY:HEAD:SIDEBURNS]
			[TISSUE_STYLE_UNIT:SIDEBURNS:STANDARD_SIDEBURNS_SHAPINGS]
				[TSU_NOUN:sideburns:PLURAL]
			
			]]}, 
            weight = 10,
			next_tables = {"procgen_subchart_table_1_1"}
        },
        {
            body_token = "HUMANOID_NECK:2EYES:2EARS:NOSE:2LUNGS:HEART:GUTS:ORGANS:HUMANOID_JOINTS:THROAT:NECK:SPINE:BRAIN:SKULL:5FINGERS:5TOES:MOUTH:TONGUE:FACIAL_FEATURES:TEETH:RIBCAGE",
            desc_part = "A humanoid with a mixture of primitive and uncanny facial features; eyes without whites, a prognathous jaw, a short forehead. A robust excaste configuration notorious for its success, both among its sophonts and the beasts they so often become. This specimen has adapted to the cold, with a broad, squat body and a thick pelt of fur, draped over its head, neck, and back. ",
            eligible_rating_tags = {"BENIGN", "PROBLEMATIC", "DANGEROUS", "HAZARDOUS"},
            eligible_size_tags = {"LESSER", "MEDIUM", "LARGE"}, 
            tok = {[[
			
			
        [SET_TL_GROUP:BY_CATEGORY:ALL:SKIN]
            [TL_COLOR_MODIFIER:PALE_PINK:1:PINK:1:PALE_TAN:1:TAN:1:DARK_TAN:1:PALE_BROWN:1:BROWN:1:DARK_BROWN:1:YELLOW_BROWN:1:PALE_YELLOW:1]
                [TLCM_NOUN:skin:SINGULAR]
			[TL_COLOR_MODIFIER:GRAY:1]
				[TLCM_NOUN:crash avoiding placeholder:SINGULAR]
				[TLCM_TIMING:ROOT:50000:0:90000:0]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:WRINKLY:0:0:0:0:0:0:0]
                [APP_MOD_RATE:1:YEARLY:0:100:40:0:NO_END]
                [APP_MOD_NOUN:skin:SINGULAR]
                [APP_MOD_DESC_RANGE:0:0:0:1:25:50]
				
	[BODY_DETAIL_PLAN:BODY_HAIR_TISSUE_LAYERS:HAIR]
			[SET_TL_GROUP:BY_CATEGORY:ALL:HAIR]
                        [TL_COLOR_MODIFIER:BLACK:1:LIGHT_BROWN:1:BROWN:1:DARK_BROWN:1:LIGHT_YELLOW:1:RED_BROWN:1:YELLOW_BROWN:1:WHITE:1:RED:1:BLUE_GRAY:1]
                [TLCM_NOUN:hair:SINGULAR]
            [TL_COLOR_MODIFIER:GRAY:1]
                [TLCM_NOUN:hair:SINGULAR]
                [TLCM_TIMING:ROOT:1:0:2:0]
				
			[BIOME:TUNDRA][BIOME:GLACIER]
			]]}, 
            weight = 10
        },
        {
            body_token = "HUMANOID_NECK:2EYES:2EARS:NOSE:2LUNGS:HEART:GUTS:ORGANS:HUMANOID_JOINTS:THROAT:NECK:SPINE:BRAIN:SKULL:5FINGERS:5TOES:MOUTH:TONGUE:FACIAL_FEATURES:TEETH:RIBCAGE",
            desc_part = "A humanoid with a mixture of primitive and uncanny facial features; eyes without whites, a prognathous jaw, a short forehead. A robust excaste configuration notorious for its success, both among its sophonts and the beasts they so often become. This specimen has adapted to the inhospitable developed regions of the Megastructure, with hairless, leathery skin and coarse, short hair protecting it from the elements. ",
            eligible_rating_tags = {"BENIGN", "PROBLEMATIC", "DANGEROUS", "HAZARDOUS"},
            eligible_size_tags = {"LESSER", "MEDIUM", "LARGE"}, 
            tok = {[[
			[BIOME:ANY_GRASSLAND]
			[BIOME:ANY_SHRUBLAND]
			[BIOME:ANY_SAVANNA]
			[BIOME:ANY_FOREST]
			[BIOME:MOUNTAIN]
			[BIOME:ANY_DESERT]
			
			
        [SET_TL_GROUP:BY_CATEGORY:ALL:SKIN]
            [TL_COLOR_MODIFIER:PALE_PINK:1:PINK:1:PALE_TAN:1:TAN:1:DARK_TAN:1:PALE_BROWN:1:BROWN:1:DARK_BROWN:1:YELLOW_BROWN:1:PALE_YELLOW:1]
                [TLCM_NOUN:skin:SINGULAR]
			[TL_COLOR_MODIFIER:GRAY:1]
				[TLCM_NOUN:crash avoiding placeholder:SINGULAR]
				[TLCM_TIMING:ROOT:50000:0:90000:0]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:WRINKLY:0:0:0:0:0:0:0]
                [APP_MOD_RATE:1:YEARLY:0:100:40:0:NO_END]
                [APP_MOD_NOUN:skin:SINGULAR]
                [APP_MOD_DESC_RANGE:0:0:0:1:25:50]
				
				
	[BODY_DETAIL_PLAN:BODY_HAIR_TISSUE_LAYERS:HAIR]
			[SET_TL_GROUP:BY_CATEGORY:ALL:HAIR]
                        [TL_COLOR_MODIFIER:BLACK:1:LIGHT_BROWN:1:BROWN:1:DARK_BROWN:1:LIGHT_YELLOW:1:RED_BROWN:1:YELLOW_BROWN:1:WHITE:1:RED:1:BLUE_GRAY:1]
                [TLCM_NOUN:hair:SINGULAR]
            [TL_COLOR_MODIFIER:GRAY:1]
                [TLCM_NOUN:hair:SINGULAR]
                [TLCM_TIMING:ROOT:1:0:2:0]
				
			
			]]}, 
            weight = 20
        },
        {
            body_token = "HUMANOID_NECK:2EYES:2EARS:NOSE:2LUNGS:HEART:GUTS:ORGANS:HUMANOID_JOINTS:THROAT:NECK:SPINE:BRAIN:SKULL:5FINGERS:5TOES:MOUTH:TONGUE:FACIAL_FEATURES:TEETH:RIBCAGE",
            desc_part = "A humanoid with a mixture of primitive and uncanny facial features; eyes without whites, a prognathous jaw, a short forehead. A robust excaste configuration notorious for its success, both among its sophonts and the beasts they so often become. This specimen has adapted to the innards of the Megastructure, with hairless, loose skin allowing it to easily twist and squirm through gaps, a short torso, and long limbs.",
            eligible_rating_tags = {"BENIGN", "PROBLEMATIC", "DANGEROUS", "HAZARDOUS"},
            eligible_size_tags = {"LESSER", "MEDIUM", "LARGE"}, 
            tok = {[[
			
			
        [SET_TL_GROUP:BY_CATEGORY:ALL:SKIN]
            [TL_COLOR_MODIFIER:PALE_PINK:10000:PINK:1:PALE_TAN:1:TAN:1:DARK_TAN:1:PALE_BROWN:1:BROWN:1:DARK_BROWN:1:YELLOW_BROWN:1:PALE_YELLOW:1]
                [TLCM_NOUN:skin:SINGULAR]
			[TL_COLOR_MODIFIER:GRAY:1]
				[TLCM_NOUN:crash avoiding placeholder:SINGULAR]
				[TLCM_TIMING:ROOT:50000:0:90000:0]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:WRINKLY:0:0:0:0:0:0:0]
                [APP_MOD_RATE:1:YEARLY:0:100:40:0:NO_END]
                [APP_MOD_NOUN:skin:SINGULAR]
                [APP_MOD_DESC_RANGE:0:0:0:1:25:50]
				
			
                    [LOW_LIGHT_VISION:10000]
			[BIOME:SUBTERRANEAN_CHASM]
			[UNDERGROUND_DEPTH:1:3]
			]]}, 
            weight = 20,
        },
        {
            body_token = "HUMANOID_NECK:2EYES:2EARS:NOSE:2LUNGS:HEART:GUTS:ORGANS:HUMANOID_JOINTS:THROAT:NECK:SPINE:BRAIN:SKULL:5FINGERS:5TOES:MOUTH:TONGUE:FACIAL_FEATURES:TEETH:RIBCAGE",
            desc_part = "A humanoid with a mixture of primitive and uncanny facial features; eyes without whites, a prognathous jaw, a short forehead. A robust excaste configuration notorious for its success, both among its sophonts and the beasts they so often become. This specimen has adapted to the waters of the megastructure, with external gills protruding from its ribs and long, webbed digits.",
            eligible_rating_tags = {"BENIGN", "PROBLEMATIC", "DANGEROUS", "HAZARDOUS"},
            eligible_size_tags = {"LESSER", "MEDIUM", "LARGE"}, 
            tok = {[[
			
			
        [SET_TL_GROUP:BY_CATEGORY:ALL:SKIN]
            [TL_COLOR_MODIFIER:PALE_PINK:1:PINK:1:PALE_TAN:1:TAN:1:DARK_TAN:1:PALE_BROWN:1:BROWN:1:DARK_BROWN:1:YELLOW_BROWN:1:PALE_YELLOW:1]
                [TLCM_NOUN:skin:SINGULAR]
			[TL_COLOR_MODIFIER:GRAY:1]
				[TLCM_NOUN:crash avoiding placeholder:SINGULAR]
				[TLCM_TIMING:ROOT:50000:0:90000:0]
            [TISSUE_LAYER_APPEARANCE_MODIFIER:WRINKLY:0:0:0:0:0:0:0]
                [APP_MOD_RATE:1:YEARLY:0:100:40:0:NO_END]
                [APP_MOD_NOUN:skin:SINGULAR]
                [APP_MOD_DESC_RANGE:0:0:0:1:25:50]
				
			[AMPHIBIOUS]
			[BIOME:ANY_RIVER]
			[BIOME:ANY_LAKE]
			[BIOME:ANY_OCEAN]
			]]}, 
            weight = 20
        }
    },
    
    -- ============================================================================
    -- Flowchart Data
    -- ============================================================================
    flowchart_data = {
   
        procgen_subchart_table_1_1 = {
			{
                body_token = "",
                desc_part = "It is relatively normal aside from its general excasteeration; eschewing speciation into a niche in favor of a generalist body. ",
				transcendent_desc_part = "",
				eligible_rating_tags = {"SOPHONT", "HOSTILE"},
				eligible_size_tags = {"MEDIUM", "LARGE"}, 
				tok = {[[
				[SWIMS_LEARNED]
				[PHYS_ATT_RANGE:RECUPERATION:450:950:1150:1250:1350:1550:2250]
				[APPLY_CREATURE_VARIATION:STANDARD_SWIMMING_GAITS:5341:4723:4112:1254:6433:7900]
				]]}, 
				transcendent_tok = {[[]]}, 
                weight = 50, 
				next_tables = {"procgen_subchart_table_2_1"}
            },
            {
                body_token = "",
                desc_part = "It has a barrel chest and strong lungs, with high endurance; remnant traits of ancestors grown for low-oxygen environments on partially terraformed moons and planets, such as Mars or Venus. ",
				transcendent_desc_part = "It has a barrel chest and thick abdominal plating. ",
				eligible_rating_tags = {"SOPHONT", "HOSTILE"},
				eligible_size_tags = {"MEDIUM", "LARGE"}, 
				tok = {[[
				[SWIMS_LEARNED]
				[PHYS_ATT_RANGE:ENDURANCE:450:950:1150:1250:1350:1550:2250]
				[APPLY_CREATURE_VARIATION:STANDARD_SWIMMING_GAITS:5341:4723:4112:1254:6433:7900]
				]]}, 
				transcendent_tok = {[[]]}, 
                weight = 10, 
				next_tables = {"procgen_subchart_table_2_1"}
            },
            {
                body_token = "",
                desc_part = "It has external gills protruding from its ribs and long, webbed digits; remnant traits of ancestors grown for aquatic habitats in the seas of Earth and Europa. ",
				transcendent_desc_part = "It has sleek, shimmering skin, perfectly hydrodynamic. ",
				eligible_rating_tags = {"SOPHONT", "HOSTILE"},
				eligible_size_tags = {"MEDIUM", "LARGE"}, 
                tok = {[[
				[AMPHIBIOUS][SWIMS_INNATE]
				]]},
				transcendent_tok = {[[]]}, 
                weight = 5, 
				next_tables = {"procgen_subchart_table_2_1"}
            },
            {
                body_token = "",
                desc_part = "It has an elongated, thin body and has excellent sense of space and direction; remnant traits of ancestors grown for low or zero-G environments such as space stations or asteroid colonies. ",
				transcendent_desc_part = "It has an elongated, graceful body and limbs. ",
            eligible_rating_tags = {"SOPHONT", "HOSTILE"},
            eligible_size_tags = {"MEDIUM", "LARGE"}, 
                tok = {[[
				[SWIMS_LEARNED]
				[MENT_ATT_RANGE:SPATIAL_SENSE:450:950:1150:1250:1350:1550:2250]
				[MENT_ATT_RANGE:KINESTHETIC_SENSE:450:950:1150:1250:1350:1550:2250]
				[PHYS_ATT_RANGE:STRENGTH:150:600:800:900:1000:1100:1500]
				[APPLY_CREATURE_VARIATION:STANDARD_SWIMMING_GAITS:5341:4723:4112:1254:6433:7900]
				]]},
				transcendent_tok = {[[]]}, 
                weight = 10, 
				next_tables = {"procgen_subchart_table_2_1"}
            },
            {
                body_token = "",
                desc_part = "It is squat, muscular, and thick-bodied; remnant traits of ancestors grown for harsh gravity or cramped environments. ",
				transcendent_desc_part = "It is short and thick-bodied, with broad limbs. ",
            eligible_rating_tags = {"SOPHONT", "HOSTILE"},
            eligible_size_tags = {"MEDIUM", "LARGE"}, 
                tok = {[[
				[SWIMS_LEARNED]
				[PHYS_ATT_RANGE:STRENGTH:450:950:1150:1250:1350:1550:2250]
				[APPLY_CREATURE_VARIATION:STANDARD_SWIMMING_GAITS:5341:4723:4112:1254:6433:7900]
				]]},
				transcendent_tok = {[[]]}, 
                weight = 10, 
				next_tables = {"procgen_subchart_table_2_1"}
            }
    },
    
        procgen_subchart_table_2_1 = {
            {     
                body_token = "", 
                desc_part = "It has no particular niche specialty, relying on its generalized physiology to survive in any part of the Megastructures which suits its form. ",
				transcendent_desc_part = "",
            eligible_rating_tags = {"SOPHONT", "HOSTILE"},
            eligible_size_tags = {"MEDIUM", "LARGE"}, 
                tok = {[[
                   [DIURNAL]
				   [APPLY_CREATURE_VARIATION:STANDARD_BIPED_GAITS:900:711:521:293:1900:2900]
                ]]},
                transcendent_tok = {[[]]}, 
                weight = 50 
            },
            {
                body_token = "", 
                desc_part = "It can survive of metabolizing alcohol or other fluids instead of water, allowing it to survive in unconventional niche territories, but often suffers when forced to go without. ",
				transcendent_desc_part = "Short cylinders emerge from its back, storing excess energy. ",
            eligible_rating_tags = {"SOPHONT", "HOSTILE"},
            eligible_size_tags = {"MEDIUM", "LARGE"}, 
                tok = {[[
                   [DIURNAL]
                    [ALCOHOL_DEPENDENT]
				   [APPLY_CREATURE_VARIATION:STANDARD_BIPED_GAITS:900:711:521:293:1900:2900]
                ]]},
                transcendent_tok = {[[]]}, 
                weight = 10 
            },
            {
                body_token = "", 
                desc_part = "It is an obligate carnivore but has a more advanced metabolism, possessing much greater muscle density on average. ",
				transcendent_desc_part = "It possesses a powerful, muscular frame, with long claws and jutting tusks. ",
            eligible_rating_tags = {"SOPHONT", "HOSTILE"},
            eligible_size_tags = {"MEDIUM", "LARGE"}, 
                tok = {[[
					[PHYS_ATT_RANGE:STRENGTH:700:1200:1400:1500:1600:1800:2500]    ++
                   [DIURNAL]
                    [BONECARN]
				   [APPLY_CREATURE_VARIATION:STANDARD_BIPED_GAITS:900:711:521:293:1900:2900]
                ]]},
                transcendent_tok = {[[]]}, 
                weight = 10 
            },
            {
                body_token = "",
                desc_part = "It has large, round eyes with nictating membranes, capable of seeing in the dark, but is nocturnal and will adapt to low-light conditions. ",
				transcendent_desc_part = "Pinpricks of light flicker in its large, round eyes. ",
            eligible_rating_tags = {"SOPHONT", "HOSTILE"},
            eligible_size_tags = {"MEDIUM", "LARGE"}, 
                tok = {[[
                    [NOCTURNAL][CAVE_ADAPT]
                    [LOW_LIGHT_VISION:10000]
				   [APPLY_CREATURE_VARIATION:STANDARD_BIPED_GAITS:900:711:521:293:1900:2900]
                ]]},
                transcendent_tok = {[[]]}, 
                weight = 10
            }
            }
    },
    
    -- ============================================================================
    -- RESTRUCTURED: Non-Sophont Caste Data
    -- ============================================================================
    non_sophont_caste_groups = {
        {
            castes = {
                {
                    tokens = [[
					[CASTE:FEMALE][FEMALE][CREATURE_CLASS:EXCASTE_FEMALE]
					]],
                    description_addon = ""
                },
                {
                    tokens = [[
					[CASTE:MALE][MALE][CREATURE_CLASS:EXCASTE_MALE]
					]],
                    description_addon = ""
                }
            },
            shared_tokens = [[
			[SELECT_CASTE:ALL][POP_RATIO:100]
			[SET_BP_GROUP:BY_TYPE:LOWERBODY][BP_ADD_TYPE:GELDABLE]
			]],
            weight = 100,
				eligible_rating_tags = {"SOPHONT"},
				eligible_size_tags = {"SMALL", "LESSER", "MEDIUM", "LARGE", "HUGE", "GIANT"}, 
        },
        {
            castes = {
                {
                    tokens = [[
					[CASTE:FEMALE][FEMALE][CREATURE_CLASS:EXCASTE_FEMALE]
					]],
                    description_addon = ""
                },
                {
                    tokens = [[
					[CASTE:MALE][MALE][CREATURE_CLASS:EXCASTE_MALE]
					]],
                    description_addon = ""
                }
            },
            shared_tokens = [[
			[SELECT_CASTE:ALL][POP_RATIO:100][SET_BP_GROUP:BY_TYPE:LOWERBODY][BP_ADD_TYPE:GELDABLE]
			]],
            weight = 100,
				eligible_rating_tags = {"BENIGN", "PROBLEMATIC", "HAZARDOUS", "DANGEROUS", "AMBIENT", "VERMIN", "HOSTILE"},
				eligible_size_tags = {"SMALL", "LESSER", "MEDIUM", "LARGE", "HUGE", "GIANT"} 
        }
    },

	-- ============================================================================
    -- CASTE FUNCTION RULES
    -- ============================================================================
    generate_caste_raws = function(config, components, lines, final_mass, utils)

        local compatible_castes = utils.filter_components_by_tags(
            config.non_sophont_caste_groups, 
            components.creature_tags, 
            components.size_variant.size_tags or {}
        )
        local chosen_caste_group = utils.pick_random(compatible_castes)
        
        if chosen_caste_group and chosen_caste_group.castes then
            -- This is your NEW logic. It is being preserved.
            -- A specific caste group was found (e.g., for Sophonts or a specific non-sophont)
            local body_str = utils.body_string_constructor(config, components, "non_sophont")
            for _, caste_def in ipairs(chosen_caste_group.castes) do
                local caste_desc = utils.description_constructor(config, components, final_mass, caste_def.description_addon, true, "non_sophont")
                utils.split_to_lines(lines, caste_def.tokens)
                utils.split_to_lines(lines, "[DESCRIPTION:" .. caste_desc .. "]")
                utils.split_to_lines(lines, body_str)
            end
            if chosen_caste_group.shared_tokens then
                utils.split_to_lines(lines, chosen_caste_group.shared_tokens)
            end

            -- This is part of your NEW logic.
            return chosen_caste_group.shared_descriptor_tokens
        else
            -- [[ START: FIXED FALLBACK BLOCK WITH WARNING ]]
            
            -- Grab the log function (print if _G.log isn't available)
            local log_func = _G.log or print
            
            -- Build the specific warning message
            local rating_tag = (components.rating and components.rating.tags and components.rating.tags[1]) or "UNKNOWN_RATING"
            local size_tags = (components.size_variant and components.size_variant.size_tags and table.concat(components.size_variant.size_tags, ", ")) or "NO_SIZE_TAGS"
            local log_prefix = (config and config.ARCHETYPE_CLASS or "UNKNOWN_CONFIG") .. "_GENERATOR_LOG"
            
            log_func(log_prefix .. ": CASTE WARNING - Using fallback caste generation. No specific caste group was found for Rating: [" .. rating_tag .. "] and Size Tags: [" .. size_tags .. "].")

            -- This is the working fallback code from your older config_biomachine.lua file.
            -- It will now correctly generate a male/female pair.
            local body_str = utils.body_string_constructor(config, components, "non_sophont")
            local female_desc = utils.description_constructor(config, components, final_mass, "", true, "non_sophont")
            utils.split_to_lines(lines, "[CASTE:FEMALE][FEMALE]")
            utils.split_to_lines(lines, "[DESCRIPTION:" .. female_desc .. "]")
            utils.split_to_lines(lines, body_str)

            local male_desc = utils.description_constructor(config, components, final_mass, "", true, "non_sophont")
            utils.split_to_lines(lines, "[CASTE:MALE][MALE]")
            utils.split_to_lines(lines, "[DESCRIPTION:" .. male_desc .. "]")
            utils.split_to_lines(lines, body_str)
            -- [[ END: FIXED FALLBACK BLOCK ]]
        end

        -- This is part of your NEW logic.
        return nil
    end,
}