extends Resource
class_name DialogueNode

# DialogueNode - узел диалога
# Поддерживает условия, эффекты и ветвление

@export var node_id: String = ""
@export var speaker: String = ""
@export var text: String = ""
@export var choices: Array[Dictionary] = []
@export var is_end: bool = false
@export var on_enter_effect: String = ""
@export var auto_next: String = ""
@export var emotion: String = ""  # happy, sad, angry, scared

func _init():
	pass

func get_available_choices(player: Node = null) -> Array[Dictionary]:
	var available: Array[Dictionary] = []
	for choice in choices:
		if choice.has("condition") and choice["condition"] != "":
			if not _check_condition(choice["condition"], player):
				continue
		available.append(choice)
	return available

func _check_condition(condition: String, player: Node) -> bool:
	var parts = condition.split(":")
	if parts.size() < 2:
		return true
	
	match parts[0]:
		"has_item":
			if player and player.has_method("inventory"):
				return player.inventory.get_item_count(parts[1]) >= int(parts[2])
		"quest_completed":
			if QuestManager:
				return QuestManager.completed_quests.has(parts[1])
		"quest_active":
			if QuestManager:
				for q in QuestManager.active_quests:
					if q.quest_id == parts[1]:
						return true
				return false
		"faction_relation":
			if FactionManager and parts.size() >= 3:
				var faction = FactionManager.get_faction(parts[1])
				if faction:
					return faction.player_relation >= float(parts[2])
		"skill_level":
			if player and player.has_method("get_skill_level"):
				return player.get_skill_level(parts[1]) >= int(parts[2])
		"has_money":
			# Упрощённая проверка
			return true
		"random":
			return randf() < float(parts[1])
	
	return true
