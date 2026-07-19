extends Resource
class_name NPCFaction

# NPCFaction - фракция НПС
# Группы НПС с общими целями и отношениями

signal faction_relation_changed(faction_id, new_relation)

enum Relation { HOSTILE, UNFRIENDLY, NEUTRAL, FRIENDLY, ALLIED }

@export var faction_id: String = ""
@export var faction_name: String = ""
@export var description: String = ""
@export var leader_id: String = ""
@export var member_ids: Array[String] = []
@export var base_position: Vector2 = Vector2.ZERO

# Отношения с другими фракциями
var faction_relations: Dictionary = {}  # faction_id: Relation

# Отношения с игроком (-100 до 100)
var player_relation: float = 0.0

func _init():
	pass

# Получить отношение к фракции
func get_relation() -> Relation:
	if player_relation <= -50:
		return Relation.HOSTILE
	elif player_relation <= -20:
		return Relation.UNFRIENDLY
	elif player_relation <= 20:
		return Relation.NEUTRAL
	elif player_relation <= 50:
		return Relation.FRIENDLY
	else:
		return Relation.ALLIED

# Изменить отношение с игроком
func modify_relation(amount: float):
	player_relation = clamp(player_relation + amount, -100, 100)
	emit_signal("faction_relation_changed", faction_id, get_relation())
	print("[Faction] %s relation: %.0f (%d)" % [faction_name, player_relation, get_relation()])

# Получить отношение к другой фракции
func get_faction_relation(other_faction_id: String) -> Relation:
	if faction_relations.has(other_faction_id):
		return faction_relations[other_faction_id]
	return Relation.NEUTRAL

# Установить отношение к другой фракции
func set_faction_relation(other_faction_id: String, relation: Relation):
	faction_relations[other_faction_id] = relation

# Добавить члена фракции
func add_member(npc_id: String):
	if not member_ids.has(npc_id):
		member_ids.append(npc_id)

# Удалить члена фракции
func remove_member(npc_id: String):
	member_ids.erase(npc_id)

# Проверить, является ли НПС членом фракции
func is_member(npc_id: String) -> bool:
	return member_ids.has(npc_id)
