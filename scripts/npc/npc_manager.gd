extends Node

# NPCManager - оптимизированный менеджер НПС

signal npc_spawned(npc)
signal npc_removed(npc)

var npcs: Array[NPC] = []
var npc_scene: PackedScene = preload("res://scenes/npc/npc.tscn")

# Кэш для быстрого поиска
var _npc_by_id: Dictionary = {}
var _npcs_by_faction: Dictionary = {}

# Пресеты НПС (сокращённые для производительности)
const NPC_PRESETS = {
	"survivor": {"name": "Выживший", "type": 0, "faction": "survivors"},
	"trader": {"name": "Торговец", "type": 1, "profession": 4, "faction": "survivors"},
	"guard": {"name": "Охранник", "type": 0, "profession": 1, "faction": "militia"},
	"doctor": {"name": "Врач", "type": 0, "profession": 3, "faction": "scientists"},
	"bandit": {"name": "Бандит", "type": 2, "faction": "bandits"},
	"scavenger": {"name": "Мусорщик", "type": 1, "faction": "survivors"},
	"scientist": {"name": "Учёный", "type": 0, "faction": "scientists"},
	"cultist": {"name": "Культист", "type": 2, "faction": "cultists"},
	"child": {"name": "Ребёнок", "type": 0, "faction": "survivors"},
	"old_timer": {"name": "Старик", "type": 0, "faction": "survivors"},
	"farmer": {"name": "Фермер", "type": 0, "profession": 2, "faction": "survivors"},
	"mechanic": {"name": "Механик", "type": 0, "profession": 0, "faction": "survivors"},
	"soldier": {"name": "Солдат", "type": 0, "profession": 1, "faction": "militia"},
	"scout": {"name": "Разведчик", "type": 1, "faction": "militia"},
	"hermit": {"name": "Отшельник", "type": 1, "faction": ""},
	"refugee": {"name": "Беженец", "type": 0, "faction": "survivors"},
	"hunter": {"name": "Охотник", "type": 1, "faction": "survivors"},
	"engineer": {"name": "Инженер", "type": 0, "faction": "scientists"},
	"police": {"name": "Полицейский", "type": 0, "profession": 1, "faction": "militia"},
	"firefighter": {"name": "Пожарный", "type": 0, "profession": 1, "faction": "survivors"},
	"prisoner": {"name": "Заключённый", "type": 1, "faction": ""},
	"lone_wolf": {"name": "Одиночка", "type": 1, "faction": ""},
	"barkeeper": {"name": "Бармен", "type": 1, "faction": "survivors"},
	"blacksmith": {"name": "Кузнец", "type": 1, "faction": "survivors"},
	"preacher": {"name": "Священник", "type": 0, "faction": "survivors"},
	"thief": {"name": "Вор", "type": 1, "faction": ""},
	"veteran": {"name": "Ветеран", "type": 1, "faction": "militia"},
	"musician": {"name": "Музыкант", "type": 1, "faction": "survivors"},
	"cook": {"name": "Повар", "type": 1, "faction": "survivors"},
	"librarian": {"name": "Библиотекарь", "type": 1, "faction": "scientists"},
	"wounded": {"name": "Раненый", "type": 0, "faction": "survivors"},
	"radio_operator": {"name": "Радист", "type": 1, "faction": "militia"}
}

func _ready():
	print("[NPCManager] Initialized")

func spawn_npc(preset_id: String, position: Vector2) -> NPC:
	if not NPC_PRESETS.has(preset_id):
		return null
	
	var preset = NPC_PRESETS[preset_id]
	var npc = npc_scene.instantiate()
	
	npc.npc_id = preset_id + "_" + str(randi())
	npc.npc_name = preset["name"]
	npc.npc_type = preset.get("type", 0)
	npc.npc_profession = preset.get("profession", 0)
	npc.faction_id = preset.get("faction", "")
	npc.global_position = position
	npc.dialogue_lines = _get_dialogue_lines(preset_id)
	
	get_tree().current_scene.add_child(npc)
	npcs.append(npc)
	
	# Обновляем кэш
	_npc_by_id[npc.npc_id] = npc
	if npc.faction_id != "":
		if not _npcs_by_faction.has(npc.faction_id):
			_npcs_by_faction[npc.faction_id] = []
		_npcs_by_faction[npc.faction_id].append(npc)
	
	npc.connect("npc_died", func(n): _on_npc_died(n))
	
	emit_signal("npc_spawned", npc)
	return npc

func _get_dialogue_lines(preset_id: String) -> Array[String]:
	var dialogue = DialogueDatabase.get_dialogue(preset_id)
	return dialogue.get("responses", ["..."])

func _on_npc_died(npc: NPC):
	npcs.erase(npc)
	_npc_by_id.erase(npc.npc_id)
	if npc.faction_id != "" and _npcs_by_faction.has(npc.faction_id):
		_npcs_by_faction[npc.faction_id].erase(npc)

func get_nearest_npc(position: Vector2, max_distance: float = 100.0) -> NPC:
	var nearest: NPC = null
	var min_dist = max_distance
	
	for npc in npcs:
		if npc.is_dead:
			continue
		var dist = position.distance_to(npc.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = npc
	
	return nearest

func get_npcs_in_range(position: Vector2, range: float) -> Array[NPC]:
	return npcs.filter(func(n): return not n.is_dead and position.distance_to(n.global_position) <= range)

func get_traders() -> Array[NPC]:
	return npcs.filter(func(n): return n.can_trade and not n.is_dead)

func get_npcs_by_faction(faction_id: String) -> Array[NPC]:
	return _npcs_by_faction.get(faction_id, [])

func remove_npc(npc: NPC):
	npcs.erase(npc)
	emit_signal("npc_removed", npc)
	npc.queue_free()

func clear_all():
	for npc in npcs:
		npc.queue_free()
	npcs.clear()
	_npc_by_id.clear()
	_npcs_by_faction.clear()

func serialize_data() -> Array:
	return npcs.map(func(n): return n.serialize())

func deserialize_data(data: Array):
	clear_all()
	for npc_data in data:
		var npc = npc_scene.instantiate()
		npc.deserialize(npc_data)
		get_tree().current_scene.add_child(npc)
		npcs.append(npc)
