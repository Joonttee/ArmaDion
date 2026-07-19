extends Resource
class_name Quest

# Quest - квест/задание
# Поддерживает цепочки квестов и условия

signal quest_accepted(quest)
signal quest_completed(quest)
signal quest_failed(quest)
signal quest_updated(quest)

enum Type { KILL, FETCH, DELIVER, EXPLORE, ESCORT, CRAFT, DEFEND, TALK }
enum Status { AVAILABLE, ACTIVE, COMPLETED, FAILED, TURNED_IN }

@export var quest_id: String = ""
@export var title: String = ""
@export var description: String = ""
@export var quest_type: Type = Type.KILL
@export var giver_npc_id: String = ""
@export var target_npc_id: String = ""

# Цели квеста
@export var target_item_id: String = ""
@export var target_count: int = 1
@export var current_count: int = 0
@export var target_position: Vector2 = Vector2.ZERO
@export var target_radius: float = 100.0
@export var target_enemy_type: String = ""
@export var target_dialogue: String = ""

# Прогресс
var status: Status = Status.AVAILABLE

# Награды
@export var reward_xp: int = 50
@export var reward_items: Dictionary = {}  # item_id: count
@export var reward_money: int = 0
@export var reward_reputation: int = 10
@export var reward_faction_id: String = ""
@export var reward_skill_xp: String = ""  # Навык для награды
@export var reward_skill_xp_amount: int = 0

# Требования
@export var required_level: int = 0
@export var required_quests: Array[String] = []
@export var required_faction_standing: float = -50.0
@export var required_item: String = ""

# Цепочка квестов
@export var next_quest_id: String = ""  # Следующий квест в цепочке
@export var is_main_quest: bool = false

# Таймер (опционально)
@export var has_time_limit: bool = false
@export var time_limit: float = 0.0
var time_remaining: float = 0.0

func _init():
	pass

# Принять квест
func accept():
	if status == Status.AVAILABLE:
		status = Status.ACTIVE
		if has_time_limit:
			time_remaining = time_limit
		emit_signal("quest_accepted", self)

# Обновить прогресс
func update_progress(amount: int = 1):
	if status != Status.ACTIVE:
		return
	
	current_count = min(current_count + amount, target_count)
	emit_signal("quest_updated", self)
	
	if current_count >= target_count:
		status = Status.COMPLETED
		emit_signal("quest_completed", self)

# Завершить квест (сдать)
func turn_in():
	if status == Status.COMPLETED:
		status = Status.TURNED_IN
		_apply_rewards()

# Провалить квест
func fail():
	if status == Status.ACTIVE:
		status = Status.FAILED
		emit_signal("quest_failed", self)

# Применить награды
func _apply_rewards():
	# Опыт
	if reward_xp > 0 and GameManager.player:
		if GameManager.player.has_method("gain_skill_xp"):
			if reward_skill_xp != "":
				GameManager.player.gain_skill_xp(reward_skill_xp, float(reward_skill_xp_amount if reward_skill_xp_amount > 0 else reward_xp))
			else:
				GameManager.player.gain_skill_xp("survival", float(reward_xp))
	
	# Предметы
	if GameManager.player and GameManager.player.has_method("inventory"):
		for item_id in reward_items:
			for i in range(reward_items[item_id]):
				var item = ItemDatabase.get_item_copy(item_id)
				if item:
					GameManager.player.inventory.add_item(item)
	
	# Репутация
	if reward_faction_id != "" and FactionManager:
		FactionManager.modify_relation(reward_faction_id, reward_reputation)

# Получить прогресс в процентах
func get_progress_percent() -> float:
	if target_count <= 0:
		return 100.0
	return (float(current_count) / float(target_count)) * 100.0

# Получить текст прогресса
func get_progress_text() -> String:
	return "%d/%d" % [current_count, target_count]

# Проверить, можно ли взять квест
func can_accept(player_level: int, completed_quests: Array, faction_standing: float) -> bool:
	if status != Status.AVAILABLE:
		return false
	
	if player_level < required_level:
		return false
	
	for req_quest in required_quests:
		if not completed_quests.has(req_quest):
			return false
	
	if faction_standing < required_faction_standing:
		return false
	
	return true

# Обновить таймер
func update_timer(delta: float):
	if has_time_limit and status == Status.ACTIVE:
		time_remaining -= delta
		if time_remaining <= 0:
			fail()

# Сериализация
func serialize() -> Dictionary:
	return {
		"quest_id": quest_id,
		"status": status,
		"current_count": current_count,
		"time_remaining": time_remaining
	}

# Десериализация
func deserialize(data: Dictionary):
	status = data.get("status", Status.AVAILABLE)
	current_count = data.get("current_count", 0)
	time_remaining = data.get("time_remaining", 0.0)
