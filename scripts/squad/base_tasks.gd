extends Resource
class_name BaseTasks

# BaseTasks - система заданий на базе
# Управляет работами, которые члены отряда могут выполнять на базе

enum TaskType { GUARD, COOK, CRAFT, HEAL, TRAIN, REST, FARM, REPAIR, RESEARCH }

# Доступные задания
const TASK_DEFINITIONS = {
	"guard_duty": {
		"name": "Караул",
		"description": "Стоять на страже базы. Повышает безопасность.",
		"type": TaskType.GUARD,
		"duration": 300.0,
		"required_role": SquadMember.Role.FIGHTER,
		"effects": {"security": 10, "morale": 5}
	},
	"cook_meal": {
		"name": "Приготовить еду",
		"description": "Готовит еду для отряда. Повышает мораль.",
		"type": TaskType.COOK,
		"duration": 120.0,
		"required_role": SquadMember.Role.WORKER,
		"effects": {"morale": 15, "food": 5}
	},
	"craft_items": {
		"name": "Создать предметы",
		"description": "Крафт предметов и улучшений для базы.",
		"type": TaskType.CRAFT,
		"duration": 180.0,
		"required_role": SquadMember.Role.WORKER,
		"effects": {"materials": -5, "equipment": 1}
	},
	"heal_patients": {
		"name": "Лечить раненых",
		"description": "Оказывает медицинскую помощь членам отряда.",
		"type": TaskType.HEAL,
		"duration": 240.0,
		"required_role": SquadMember.Role.MEDIC,
		"effects": {"health": 30, "morale": 10}
	},
	"train_combat": {
		"name": "Тренировка",
		"description": "Тренировка боевых навыков.",
		"type": TaskType.TRAIN,
		"duration": 200.0,
		"required_role": SquadMember.Role.FIGHTER,
		"effects": {"combat_skill": 1, "morale": 5}
	},
	"rest_recover": {
		"name": "Отдых",
		"description": "Восстановление сил и морали.",
		"type": TaskType.REST,
		"duration": 600.0,
		"required_role": -1,  # Любая роль
		"effects": {"health": 50, "morale": 25}
	},
	"farm_work": {
		"name": "Работа на ферме",
		"description": "Уход за посевами на базе.",
		"type": TaskType.FARM,
		"duration": 300.0,
		"required_role": SquadMember.Role.WORKER,
		"effects": {"food": 10, "morale": 5}
	},
	"repair_base": {
		"name": "Ремонт базы",
		"description": "Починка укреплений и зданий.",
		"type": TaskType.REPAIR,
		"duration": 240.0,
		"required_role": SquadMember.Role.WORKER,
		"effects": {"defense": 10, "morale": 3}
	},
	"research": {
		"name": "Исследования",
		"description": "Изучение новых технологий и рецептов.",
		"type": TaskType.RESEARCH,
		"duration": 360.0,
		"required_role": SquadMember.Role.SCOUT,
		"effects": {"research": 1, "morale": 8}
	}
}

# Активные задания
var active_tasks: Dictionary = {}  # task_id: {member_id, timer}

func _ready():
	print("[BaseTasks] Initialized")

# Получить доступные задания для члена отряда
func get_available_tasks(member: SquadMember) -> Array[String]:
	var result = []
	
	for task_id in TASK_DEFINITIONS:
		var task = TASK_DEFINITIONS[task_id]
		
		# Проверяем роль
		if task["required_role"] != -1 and task["required_role"] != member.member_role:
			continue
		
		# Проверяем, не занято ли уже
		if not active_tasks.has(task_id):
			result.append(task_id)
	
	return result

# Начать задание
func start_task(task_id: String, member: SquadMember) -> bool:
	if not TASK_DEFINITIONS.has(task_id):
		return false
	
	if active_tasks.has(task_id):
		return false
	
	var task = TASK_DEFINITIONS[task_id]
	
	active_tasks[task_id] = {
		"member_id": member.npc_id,
		"timer": task["duration"]
	}
	
	member.member_state = SquadMember.State.AT_BASE
	
	print("[BaseTasks] %s started: %s" % [member.npc_name, task["name"]])
	return true

# Обновить задания
func update(delta: float):
	var completed = []
	
	for task_id in active_tasks:
		var task_data = active_tasks[task_id]
		task_data["timer"] -= delta
		
		if task_data["timer"] <= 0:
			completed.append(task_id)
	
	for task_id in completed:
		_complete_task(task_id)

# Завершить задание
func _complete_task(task_id: String):
	if not active_tasks.has(task_id):
		return
	
	var task = TASK_DEFINITIONS[task_id]
	var task_data = active_tasks[task_id]
	
	# Находим члена отряда
	var member = null
	for m in SquadManager.squad_members:
		if m.npc_id == task_data["member_id"]:
			member = m
			break
	
	if member:
		# Применяем эффекты
		var effects = task["effects"]
		if effects.has("morale"):
			member.modify_morale(effects["morale"])
		if effects.has("health"):
			member.heal(effects["health"])
		if effects.has("combat_skill"):
			member.combat_skill += effects["combat_skill"]
		
		member.member_state = SquadMember.State.IDLE
		print("[BaseTasks] %s completed: %s" % [member.npc_name, task["name"]])
	
	active_tasks.erase(task_id)

# Получить информацию о задании
func get_task_info(task_id: String) -> Dictionary:
	if TASK_DEFINITIONS.has(task_id):
		return TASK_DEFINITIONS[task_id]
	return {}
