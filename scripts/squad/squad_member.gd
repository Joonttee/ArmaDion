extends Node
class_name SquadMember

# SquadMember - член отряда игрока
# Хранит данные о рекрутированном НПС

signal member_leveled_up(member)
signal member_morale_changed(member, new_morale)
signal member_injured(member)

enum State { IDLE, ON_MISSION, AT_BASE, INJURED, RESTING }
enum Role { FIGHTER, SCOUT, WORKER, MEDIC, TRADER }

@export var npc_id: String = ""
@export var npc_name: String = ""
@export var member_state: State = State.IDLE
@export var member_role: Role = Role.FIGHTER

# Характеристики
var level: int = 1
var experience: int = 0
var health: float = 100.0
var max_health: float = 100.0
var morale: float = 50.0  # 0-100
var loyalty: float = 50.0  # 0-100

# Навыки члена отряда
var combat_skill: int = 1
var survival_skill: int = 1
var crafting_skill: int = 1
var scouting_skill: int = 1

# Текущее задание
var current_mission: Dictionary = {}
var mission_timer: float = 0.0

# Снаряжение
var equipped_weapon: String = ""
var equipped_armor: String = ""

func _init():
	pass

# Добавить опыт
func add_experience(amount: int):
	experience += amount
	var xp_needed = _xp_for_next_level()
	if experience >= xp_needed:
		level_up()

func _xp_for_next_level() -> int:
	return 100 * level

func level_up():
	level += 1
	experience = 0
	max_health += 10
	health = max_health
	emit_signal("member_leveled_up", self)
	print("[SquadMember] %s leveled up to %d!" % [npc_name, level])

# Изменить мораль
func modify_morale(amount: float):
	morale = clamp(morale + amount, 0, 100)
	emit_signal("member_morale_changed", self, morale)
	
	if morale < 20:
		print("[SquadMember] %s has low morale!" % npc_name)

# Изменить лояльность
func modify_loyalty(amount: float):
	loyalty = clamp(loyalty + amount, 0, 100)

# Получить урон
func take_damage(amount: float):
	health -= amount
	if health <= 0:
		health = 0
		member_state = State.INJURED
		emit_signal("member_injured", self)

# Исцелить
func heal(amount: float):
	health = min(health + amount, max_health)
	if health > 0 and member_state == State.INJURED:
		member_state = State.IDLE

# Назначить роль
func set_role(new_role: Role):
	member_role = new_role

# Получить бонус к навыку
func get_skill_bonus(skill_name: String) -> float:
	match skill_name:
		"combat":
			return combat_skill * 0.05
		"survival":
			return survival_skill * 0.05
		"crafting":
			return crafting_skill * 0.05
		"scouting":
			return scouting_skill * 0.05
		_:
			return 0.0

# Проверить, может ли выполнять задание
func can_do_mission(mission_type: String) -> bool:
	if member_state != State.IDLE:
		return false
	if morale < 20:
		return false
	return true

# Начать задание
func start_mission(mission: Dictionary):
	current_mission = mission
	member_state = State.ON_MISSION
	mission_timer = mission.get("duration", 60.0)

# Завершить задание
func complete_mission(success: bool):
	if success:
		add_experience(current_mission.get("xp_reward", 50))
		modify_morale(10)
		modify_loyalty(5)
	else:
		modify_morale(-20)
		modify_loyalty(-10)
	
	current_mission = {}
	member_state = State.IDLE
	mission_timer = 0.0

# Сериализация
func serialize() -> Dictionary:
	return {
		"npc_id": npc_id,
		"npc_name": npc_name,
		"state": member_state,
		"role": member_role,
		"level": level,
		"experience": experience,
		"health": health,
		"max_health": max_health,
		"morale": morale,
		"loyalty": loyalty,
		"combat_skill": combat_skill,
		"survival_skill": survival_skill,
		"crafting_skill": crafting_skill,
		"scouting_skill": scouting_skill
	}

# Десериализация
func deserialize(data: Dictionary):
	npc_id = data.get("npc_id", "")
	npc_name = data.get("npc_name", "")
	member_state = data.get("state", State.IDLE)
	member_role = data.get("role", Role.FIGHTER)
	level = data.get("level", 1)
	experience = data.get("experience", 0)
	health = data.get("health", 100.0)
	max_health = data.get("max_health", 100.0)
	morale = data.get("morale", 50.0)
	loyalty = data.get("loyalty", 50.0)
	combat_skill = data.get("combat_skill", 1)
	survival_skill = data.get("survival_skill", 1)
	crafting_skill = data.get("crafting_skill", 1)
	scouting_skill = data.get("scouting_skill", 1)
