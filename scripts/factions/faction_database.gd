extends Resource
class_name FactionDatabase

# FactionDatabase - расширенная база фракций (10+ фракций)

const FACTIONS = {
	# === ОСНОВНЫЕ ФРАКЦИИ (5) ===
	"survivors": {
		"name": "Выжившие",
		"description": "Группа мирных выживших, пытающихся пережить апокалипсис.",
		"start_relation": 10.0,
		"base_position": Vector2(0, 0),
		"color": Color.GREEN,
		"trades": ["food", "medicine", "basic_tools"],
		"missions": ["kill_zombies", "fetch_supplies", "rescue_survivors"],
		"relations": {
			"militia": 20.0,
			"bandits": -50.0,
			"scientists": 15.0,
			"cultists": -30.0
		}
	},
	"militia": {
		"name": "Ополчение",
		"description": "Военизированная группа, поддерживающая порядок.",
		"start_relation": 0.0,
		"base_position": Vector2(500, -300),
		"color": Color.BLUE,
		"trades": ["weapons", "ammo", "military_gear"],
		"missions": ["patrol", "defend", "eliminate_threats"],
		"relations": {
			"survivors": 20.0,
			"bandits": -80.0,
			"scientists": 0.0,
			"cultists": -60.0
		}
	},
	"bandits": {
		"name": "Бандиты",
		"description": "Грабители и мародеры, охотящиеся на других выживших.",
		"start_relation": -30.0,
		"base_position": Vector2(-600, 400),
		"color": Color.RED,
		"trades": ["stolen_goods", "weapons", "information"],
		"missions": ["raid", "rob", "intimidate"],
		"relations": {
			"survivors": -50.0,
			"militia": -80.0,
			"scientists": -20.0,
			"cultists": 10.0
		}
	},
	"scientists": {
		"name": "Учёные",
		"description": "Группа исследователей, ищущих способ остановить заразу.",
		"start_relation": 20.0,
		"base_position": Vector2(-400, -500),
		"color": Color.CYAN,
		"trades": ["medicine", "electronics", "research_data"],
		"missions": ["collect_samples", "research", "find_lab"],
		"relations": {
			"survivors": 15.0,
			"militia": 0.0,
			"bandits": -20.0,
			"cultists": -40.0
		}
	},
	"cultists": {
		"name": "Культисты",
		"description": "Религиозная секта, поклоняющаяся заразе как божеству.",
		"start_relation": -10.0,
		"base_position": Vector2(800, 600),
		"color": Color.PURPLE,
		"trades": ["drugs", "mutagen", "dark_knowledge"],
		"missions": ["spread_infection", "recruit", "ritual"],
		"relations": {
			"survivors": -30.0,
			"militia": -60.0,
			"bandits": 10.0,
			"scientists": -40.0
		}
	},
	
	# === СПЕЦИАЛЬНЫЕ ФРАКЦИИ (5) ===
	"merchants": {
		"name": "Торговцы",
		"description": "Нейтральная гильдия торговцев.",
		"start_relation": 15.0,
		"base_position": Vector2(200, 200),
		"color": Color.YELLOW,
		"trades": ["everything"],
		"missions": ["deliver_goods", "trade_caravan", "find_rare_items"],
		"relations": {
			"survivors": 20.0,
			"militia": 10.0,
			"bandits": -10.0,
			"scientists": 15.0,
			"cultists": -5.0
		}
	},
	"hunters": {
		"name": "Охотники",
		"description": "Группа опытных охотников и следопытов.",
		"start_relation": 5.0,
		"base_position": Vector2(-300, -700),
		"color": Color.ORANGE,
		"trades": ["meat", "hides", "tracking_info"],
		"missions": ["hunt_beast", "track_prey", "clear_wilderness"],
		"relations": {
			"survivors": 10.0,
			"militia": 5.0,
			"bandits": -20.0,
			"scientists": 10.0,
			"cultists": -15.0
		}
	},
	"medics": {
		"name": "Медики",
		"description": "Группа врачей и медиков, помогающих всем.",
		"start_relation": 25.0,
		"base_position": Vector2(100, -400),
		"color": Color.WHITE,
		"trades": ["medicine", "medical_supplies", "healing"],
		"missions": ["heal_sick", "find_medicine", "quarantine"],
		"relations": {
			"survivors": 30.0,
			"militia": 20.0,
			"bandits": -10.0,
			"scientists": 25.0,
			"cultists": -20.0
		}
	},
	"engineers": {
		"name": "Инженеры",
		"description": "Группа строителей и механиков.",
		"start_relation": 10.0,
		"base_position": Vector2(-200, 300),
		"color": Color.GRAY,
		"trades": ["tools", "parts", "construction_materials"],
		"missions": ["repair_building", "build_defense", "fix_vehicle"],
		"relations": {
			"survivors": 15.0,
			"militia": 10.0,
			"bandits": -15.0,
			"scientists": 20.0,
			"cultists": -10.0
		}
	},
	"hermits": {
		"name": "Отшельники",
		"description": "Изолированные группы, не доверяющие никому.",
		"start_relation": -5.0,
		"base_position": Vector2(700, -600),
		"color": Color.DIM_GRAY,
		"trades": ["rare_herbs", "handmade_goods"],
		"missions": ["gather_herbs", "craft_item"],
		"relations": {
			"survivors": -5.0,
			"militia": -15.0,
			"bandits": -30.0,
			"scientists": 0.0,
			"cultists": -25.0
		}
	}
}

const FACTION_RANKS = {
	"hostile": {"min": -100, "max": -50, "can_trade": false, "can_mission": false},
	"unfriendly": {"min": -50, "max": -20, "can_trade": false, "can_mission": false},
	"neutral": {"min": -20, "max": 20, "can_trade": true, "can_mission": false},
	"friendly": {"min": 20, "max": 50, "can_trade": true, "can_mission": true},
	"allied": {"min": 50, "max": 100, "can_trade": true, "can_mission": true}
}

static func get_faction(faction_id: String) -> Dictionary:
	return FACTIONS.get(faction_id, {})

static func get_all_factions() -> Array:
	return FACTIONS.keys()

static func get_faction_relation(faction1_id: String, faction2_id: String) -> float:
	var faction1 = get_faction(faction1_id)
	if faction1.is_empty():
		return 0.0
	
	var relations = faction1.get("relations", {})
	return relations.get(faction2_id, 0.0)

static func get_rank(relation: float) -> String:
	for rank_id in FACTION_RANKS:
		var rank = FACTION_RANKS[rank_id]
		if relation >= rank["min"] and relation < rank["max"]:
			return rank_id
	return "neutral"

static func can_trade(faction_id: String, relation: float) -> bool:
	var rank = get_rank(relation)
	return FACTION_RANKS[rank]["can_trade"]

static func can_mission(faction_id: String, relation: float) -> bool:
	var rank = get_rank(relation)
	return FACTION_RANKS[rank]["can_mission"]
