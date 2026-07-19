extends Node

# SquadManager - менеджер отряда
# Управляет членами отряда, миссиями и заданиями на базе

signal member_recruited(member)
signal member_left(member)
signal mission_started(member, mission)
signal mission_completed(member, mission, success)
signal base_task_started(member, task)

var squad_members: Array[SquadMember] = []
var max_squad_size: int = 5

# Отношения с НПС (npc_id: relation_value)
var npc_relations: Dictionary = {}

# Доступные миссии
var available_missions: Array[Dictionary] = []

# Задания на базе
var base_tasks: Dictionary = {}

func _ready():
	_initialize_missions()
	_initialize_base_tasks()
	print("[SquadManager] Initialized")

func _process(delta):
	_update_missions(delta)
	_update_members(delta)

# Инициализация миссий
func _initialize_missions():
	available_missions = [
		{
			"id": "scout_area",
			"name": "Разведка местности",
			"description": "Исследовать окрестности и найти ресурсы.",
			"type": "scout",
			"duration": 120.0,
			"difficulty": 1,
			"xp_reward": 30,
			"required_role": SquadMember.Role.SCOUT,
			"success_chance": 0.8,
			"rewards": {"xp": 30, "morale": 10}
		},
		{
			"id": "gather_food",
			"name": "Сбор еды",
			"description": "Найти и собрать еду для отряда.",
			"type": "gather",
			"duration": 90.0,
			"difficulty": 1,
			"xp_reward": 25,
			"required_role": SquadMember.Role.WORKER,
			"success_chance": 0.9,
			"rewards": {"xp": 25, "morale": 5}
		},
		{
			"id": "clear_zombies",
			"name": "Зачистка зомби",
			"description": "Уничтожить группу зомби в районе.",
			"type": "combat",
			"duration": 180.0,
			"difficulty": 2,
			"xp_reward": 60,
			"required_role": SquadMember.Role.FIGHTER,
			"success_chance": 0.7,
			"rewards": {"xp": 60, "morale": 15}
		},
		{
			"id": "scavenge_materials",
			"name": "Поиск материалов",
			"description": "Найти строительные материалы и ресурсы.",
			"type": "scavenge",
			"duration": 150.0,
			"difficulty": 2,
			"xp_reward": 40,
			"required_role": SquadMember.Role.WORKER,
			"success_chance": 0.75,
			"rewards": {"xp": 40, "morale": 10}
		},
		{
			"id": "rescue_survivors",
			"name": "Спасение выживших",
			"description": "Найти и спасти группу выживших.",
			"type": "rescue",
			"duration": 240.0,
			"difficulty": 3,
			"xp_reward": 100,
			"required_role": SquadMember.Role.FIGHTER,
			"success_chance": 0.6,
			"rewards": {"xp": 100, "morale": 20}
		},
		{
			"id": "patrol_perimeter",
			"name": "Патрулирование периметра",
			"description": "Обойти периметр базы и проверить угрозы.",
			"type": "patrol",
			"duration": 60.0,
			"difficulty": 1,
			"xp_reward": 20,
			"required_role": SquadMember.Role.SCOUT,
			"success_chance": 0.95,
			"rewards": {"xp": 20, "morale": 5}
		},
		{
			"id": "trade_caravan",
			"name": "Торговый караван",
			"description": "Отправить товары на торговую точку.",
			"type": "trade",
			"duration": 300.0,
			"difficulty": 2,
			"xp_reward": 50,
			"required_role": SquadMember.Role.TRADER,
			"success_chance": 0.7,
			"rewards": {"xp": 50, "morale": 10}
		}
	]

# Инициализация заданий на базе
func _initialize_base_tasks():
	base_tasks = {
		"guard_duty": {
			"name": "Караул",
			"description": "Стоять на страже базы.",
			"duration": 300.0,
			"required_role": SquadMember.Role.FIGHTER,
			"morale_bonus": 5,
			"loyalty_bonus": 2
		},
		"cooking": {
			"name": "Готовка",
			"description": "Готовить еду для отряда.",
			"duration": 120.0,
			"required_role": SquadMember.Role.WORKER,
			"morale_bonus": 10,
			"loyalty_bonus": 3
		},
		"crafting": {
			"name": "Ремесло",
			"description": "Создавать предметы и улучшения.",
			"duration": 180.0,
			"required_role": SquadMember.Role.WORKER,
			"morale_bonus": 8,
			"loyalty_bonus": 4
		},
		"medical_duty": {
			"name": "Медицинская помощь",
			"description": "Лечить раненых членов отряда.",
			"duration": 240.0,
			"required_role": SquadMember.Role.MEDIC,
			"morale_bonus": 15,
			"loyalty_bonus": 5
		},
		"training": {
			"name": "Тренировка",
			"description": "Тренировать боевые навыки.",
			"duration": 200.0,
			"required_role": SquadMember.Role.FIGHTER,
			"morale_bonus": 5,
			"loyalty_bonus": 3
		},
		"rest": {
			"name": "Отдых",
			"description": "Восстановить силы.",
			"duration": 600.0,
			"required_role": -1,  # Любая роль
			"morale_bonus": 20,
			"loyalty_bonus": 5
		}
	}

# Обновление миссий
func _update_missions(delta):
	for member in squad_members:
		if member.member_state == SquadMember.State.ON_MISSION:
			member.mission_timer -= delta
			if member.mission_timer <= 0:
				_complete_mission(member)

# Обновление членов отряда
func _update_members(delta):
	for member in squad_members:
		if member.member_state == SquadMember.State.RESTING:
			member.morale = min(member.morale + delta * 0.5, 100)
			member.health = min(member.health + delta * 2.0, member.max_health)

# Завершить миссию
func _complete_mission(member: SquadMember):
	var mission = member.current_mission
	var success = randf() < mission.get("success_chance", 0.7)
	
	if success:
		member.complete_mission(true)
		emit_signal("mission_completed", member, mission, true)
		print("[SquadManager] Mission completed: %s by %s" % [mission["name"], member.npc_name])
	else:
		member.complete_mission(false)
		emit_signal("mission_completed", member, mission, false)
		print("[SquadManager] Mission failed: %s by %s" % [mission["name"], member.npc_name])

# Нанять НПС в отряд
func recruit_npc(npc: NPC) -> bool:
	if squad_members.size() >= max_squad_size:
		print("[SquadManager] Squad is full!")
		return false
	
	# Проверяем лояльность
	var relation = get_npc_relation(npc.npc_id)
	if relation < 30:
		print("[SquadManager] NPC doesn't trust you enough!")
		return false
	
	var member = SquadMember.new()
	member.npc_id = npc.npc_id
	member.npc_name = npc.npc_name
	member.health = npc.health
	member.max_health = npc.max_health
	
	squad_members.append(member)
	
	# Удаляем НПС из мира
	npc.queue_free()
	
	emit_signal("member_recruited", member)
	print("[SquadManager] Recruited: %s" % member.npc_name)
	
	return true

# Уволить члена отряда
func dismiss_member(member: SquadMember):
	squad_members.erase(member)
	emit_signal("member_left", member)
	print("[SquadManager] Dismissed: %s" % member.npc_name)

# Отправить на миссию
func send_on_mission(member: SquadMember, mission_id: String) -> bool:
	if not member.can_do_mission(mission_id):
		return false
	
	var mission = null
	for m in available_missions:
		if m["id"] == mission_id:
			mission = m
			break
	
	if not mission:
		return false
	
	member.start_mission(mission)
	emit_signal("mission_started", member, mission)
	print("[SquadManager] %s sent on mission: %s" % [member.npc_name, mission["name"]])
	
	return true

# Назначить задание на базе
func assign_base_task(member: SquadMember, task_id: String) -> bool:
	if member.member_state != SquadMember.State.IDLE:
		return false
	
	if not base_tasks.has(task_id):
		return false
	
	var task = base_tasks[task_id]
	member.member_state = SquadMember.State.AT_BASE
	
	# Применяем бонусы
	member.modify_morale(task.get("morale_bonus", 0))
	member.modify_loyalty(task.get("loyalty_bonus", 0))
	
	emit_signal("base_task_started", member, task)
	print("[SquadManager] %s assigned to: %s" % [member.npc_name, task["name"]])
	
	return true

# Получить отношение к НПС
func get_npc_relation(npc_id: String) -> float:
	return npc_relations.get(npc_id, 0.0)

# Изменить отношение к НПС
func modify_npc_relation(npc_id: String, amount: float):
	var current = npc_relations.get(npc_id, 0.0)
	npc_relations[npc_id] = clamp(current + amount, -100, 100)

# Получить членов отряда по роли
func get_members_by_role(role: SquadMember.Role) -> Array[SquadMember]:
	var result: Array[SquadMember] = []
	for member in squad_members:
		if member.member_role == role:
			result.append(member)
	return result

# Получить свободных членов отряда
func get_available_members() -> Array[SquadMember]:
	var result: Array[SquadMember] = []
	for member in squad_members:
		if member.member_state == SquadMember.State.IDLE:
			result.append(member)
	return result

# Получить миссии для члена отряда
func get_available_missions_for(member: SquadMember) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for mission in available_missions:
		if mission["required_role"] == -1 or mission["required_role"] == member.member_role:
			result.append(mission)
	return result

# Сериализация
func serialize_data() -> Dictionary:
	var members_data = []
	for member in squad_members:
		members_data.append(member.serialize())
	
	return {
		"members": members_data,
		"relations": npc_relations,
		"max_size": max_squad_size
	}

# Десериализация
func deserialize_data(data: Dictionary):
	squad_members.clear()
	for member_data in data.get("members", []):
		var member = SquadMember.new()
		member.deserialize(member_data)
		squad_members.append(member)
	
	npc_relations = data.get("relations", {})
	max_squad_size = data.get("max_size", 5)
