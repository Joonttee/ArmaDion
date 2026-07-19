extends Resource
class_name RelationshipSystem

# RelationshipSystem - система отношений с НПС
# Управляет улучшением отношений и вербовкой

# Уровни отношений
enum Level { HATED, UNFRIENDLY, NEUTRAL, FRIENDLY, TRUSTED, RECRUITED }

# Действия, влияющие на отношения
const RELATION_EFFECTS = {
	"give_gift": 10.0,
	"help_in_combat": 15.0,
	"trade_fair": 5.0,
	"trade_unfair": -10.0,
	"complete_quest": 20.0,
	"refuse_quest": -5.0,
	"attack": -50.0,
	"heal": 12.0,
	"share_food": 8.0,
	"insult": -15.0,
	"compliment": 5.0
}

# Пороги отношений
const RELATION_THRESHOLDS = {
	Level.HATED: -100.0,
	Level.UNFRIENDLY: -50.0,
	Level.NEUTRAL: -10.0,
	Level.FRIENDLY: 30.0,
	Level.TRUSTED: 60.0,
	Level.RECRUITED: 100.0
}

# Отношения с каждым НПС
var relationships: Dictionary = {}  # npc_id: relation_value

func _init():
	pass

# Получить уровень отношений
func get_relation_level(npc_id: String) -> Level:
	var value = relationships.get(npc_id, 0.0)
	
	if value <= RELATION_THRESHOLDS[Level.UNFRIENDLY]:
		return Level.HATED
	elif value <= RELATION_THRESHOLDS[Level.NEUTRAL]:
		return Level.UNFRIENDLY
	elif value <= RELATION_THRESHOLDS[Level.FRIENDLY]:
		return Level.NEUTRAL
	elif value <= RELATION_THRESHOLDS[Level.TRUSTED]:
		return Level.FRIENDLY
	else:
		return Level.TRUSTED

# Изменить отношения
func modify_relation(npc_id: String, action: String):
	if RELATION_EFFECTS.has(action):
		var current = relationships.get(npc_id, 0.0)
		relationships[npc_id] = clamp(current + RELATION_EFFECTS[action], -100, 100)
		print("[Relationship] %s: %s (%.0f)" % [npc_id, action, relationships[npc_id]])

# Можно ли вербовать
func can_recruit(npc_id: String) -> bool:
	return get_relation_level(npc_id) >= Level.TRUSTED

# Получить значение отношений
func get_relation_value(npc_id: String) -> float:
	return relationships.get(npc_id, 0.0)

# Сериализация
func serialize() -> Dictionary:
	return relationships

# Десериализация
func deserialize(data: Dictionary):
	relationships = data
