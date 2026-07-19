extends Node

# FactionManager - менеджер фракций
# Управляет всеми фракциями и их отношениями

var factions: Dictionary = {}  # faction_id: NPCFaction

# Определения фракций
const FACTION_DEFINITIONS = {
	"survivors": {
		"name": "Выжившие",
		"description": "Группа мирных выживших, пытающихся пережить апокалипсис.",
		"start_relation": 10.0,
		"relations": {
			"bandits": Relation.HOSTILE,
			"militia": Relation.NEUTRAL,
			"scientists": Relation.FRIENDLY
		}
	},
	"bandits": {
		"name": "Бандиты",
		"description": "Грабители и мародеры, охотящиеся на других выживших.",
		"start_relation": -30.0,
		"relations": {
			"survivors": Relation.HOSTILE,
			"militia": Relation.UNFRIENDLY,
			"scientists": Relation.NEUTRAL
		}
	},
	"militia": {
		"name": "Ополчение",
		"description": "Военизированная группа, поддерживающая порядок.",
		"start_relation": 0.0,
		"relations": {
			"survivors": Relation.FRIENDLY,
			"bandits": Relation.HOSTILE,
			"scientists": Relation.NEUTRAL
		}
	},
	"scientists": {
		"name": "Учёные",
		"description": "Группа исследователей, ищущих способ остановить заразу.",
		"start_relation": 20.0,
		"relations": {
			"survivors": Relation.FRIENDLY,
			"bandits": Relation.UNFRIENDLY,
			"militia": Relation.NEUTRAL
		}
	},
	"cultists": {
		"name": "Культисты",
		"description": "Религиозная секта, поклоняющаяся заразе как божеству.",
		"start_relation": -10.0,
		"relations": {
			"survivors": Relation.UNFRIENDLY,
			"bandits": Relation.NEUTRAL,
			"militia": Relation.HOSTILE,
			"scientists": Relation.HOSTILE
		}
	}
}

func _ready():
	_initialize_factions()
	print("[FactionManager] Initialized")

func _initialize_factions():
	for faction_id in FACTION_DEFINITIONS:
		var def = FACTION_DEFINITIONS[faction_id]
		var faction = NPCFaction.new()
		
		faction.faction_id = faction_id
		faction.faction_name = def["name"]
		faction.description = def["description"]
		faction.player_relation = def["start_relation"]
		
		# Устанавливаем отношения с другими фракциями
		for other_id in def["relations"]:
			faction.set_faction_relation(other_id, def["relations"][other_id])
		
		factions[faction_id] = faction
		faction.connect("faction_relation_changed", func(fid, rel): _on_relation_changed(fid, rel))

# Получить фракцию
func get_faction(faction_id: String) -> NPCFaction:
	if factions.has(faction_id):
		return factions[faction_id]
	return null

# Получить все фракции
func get_all_factions() -> Array:
	return factions.values()

# Изменить отношение к фракции
func modify_relation(faction_id: String, amount: float):
	if factions.has(faction_id):
		factions[faction_id].modify_relation(amount)

# Получить отношение к фракции
func get_player_relation(faction_id: String) -> float:
	if factions.has(faction_id):
		return factions[faction_id].player_relation
	return 0.0

# Получить статус отношений
func get_relation_status(faction_id: String) -> NPCFaction.Relation:
	if factions.has(faction_id):
		return factions[faction_id].get_relation()
	return NPCFaction.Relation.NEUTRAL

# Получить фракцию по имени
func get_faction_by_name(name: String) -> NPCFaction:
	for faction in factions.values():
		if faction.faction_name == name:
			return faction
	return null

# Получить дружественные фракции
func get_friendly_factions() -> Array:
	var result = []
	for faction in factions.values():
		if faction.get_relation() in [NPCFaction.Relation.FRIENDLY, NPCFaction.Relation.ALLIED]:
			result.append(faction)
	return result

# Получить враждебные фракции
func get_hostile_factions() -> Array:
	var result = []
	for faction in factions.values():
		if faction.get_relation() in [NPCFaction.Relation.HOSTILE, NPCFaction.Relation.UNFRIENDLY]:
			result.append(faction)
	return result

func _on_relation_changed(faction_id: String, new_relation: NPCFaction.Relation):
	var faction = factions[faction_id]
	print("[FactionManager] %s is now %d to player" % [faction.faction_name, new_relation])
	
	# Обновляем всех НПС этой фракции
	var npcs = get_tree().get_nodes_in_group("npcs")
	for npc in npcs:
		if npc.has_method("get_faction") and npc.get_faction() == faction_id:
			npc.update_faction_standing()

# Сериализация
func serialize_data() -> Dictionary:
	var data = {}
	for faction_id in factions:
		data[faction_id] = {
			"player_relation": factions[faction_id].player_relation,
			"members": factions[faction_id].member_ids
		}
	return data

# Десериализация
func deserialize_data(data: Dictionary):
	for faction_id in data:
		if factions.has(faction_id):
			factions[faction_id].player_relation = data[faction_id].get("player_relation", 0)
			factions[faction_id].member_ids = data[faction_id].get("members", [])
