extends Resource
class_name SkillSet

# SkillSet - набор навыков персонажа
# Система прокачки через использование (как в CDDA)

signal skill_leveled_up(skill_id, new_level)
signal skill_xp_gained(skill_id, amount, total)

# Категории навыков
enum Category { COMBAT, SURVIVAL, CRAFTING, SOCIAL, INTELLECTUAL }

# Определения навыков
const SKILL_DEFINITIONS = {
	# Боевые навыки
	"melee": {
		"name": "Ближний бой",
		"description": "Мастерство владения холодным оружием",
		"category": Category.COMBAT,
		"icon": ""
	},
	"ranged": {
		"name": "Стрельба",
		"description": "Умение стрелять из огнестрельного оружия",
		"category": Category.COMBAT,
		"icon": ""
	},
	"dodge": {
		"name": "Уклонение",
		"description": "Способность уворачиваться от атак",
		"category": Category.COMBAT,
		"icon": ""
	},
	"athletics": {
		"name": "Атлетика",
		"description": "Физическая подготовка, выносливость, скорость",
		"category": Category.COMBAT,
		"icon": ""
	},
	
	# Выживание
	"survival": {
		"name": "Выживание",
		"description": "Поиск следов, сбор ресурсов, ориентирование",
		"category": Category.SURVIVAL,
		"icon": ""
	},
	"cooking": {
		"name": "Кулинария",
		"description": "Приготовление пищи, консервирование",
		"category": Category.SURVIVAL,
		"icon": ""
	},
	"farming": {
		"name": "Фермерство",
		"description": "Выращивание растений, уход за посевами",
		"category": Category.SURVIVAL,
		"icon": ""
	},
	"foraging": {
		"name": "Собирательство",
		"description": "Поиск дикорастущих растений и грибов",
		"category": Category.SURVIVAL,
		"icon": ""
	},
	"fishing": {
		"name": "Рыбалка",
		"description": "Ловля рыбы",
		"category": Category.SURVIVAL,
		"icon": ""
	},
	
	# Ремесло
	"mechanics": {
		"name": "Механика",
		"description": "Ремонт и обслуживание техники",
		"category": Category.CRAFTING,
		"icon": ""
	},
	"electronics": {
		"name": "Электроника",
		"description": "Работа с электронными устройствами",
		"category": Category.CRAFTING,
		"icon": ""
	},
	"construction": {
		"name": "Строительство",
		"description": "Возведение зданий и сооружений",
		"category": Category.CRAFTING,
		"icon": ""
	},
	"tailoring": {
		"name": "Шитьё",
		"description": "Создание одежды из ткани",
		"category": Category.CRAFTING,
		"icon": ""
	},
	"metalwork": {
		"name": "Металлообработка",
		"description": "Ковка и обработка металла",
		"category": Category.CRAFTING,
		"icon": ""
	},
	"carpentry": {
		"name": "Плотничество",
		"description": "Работа с деревом",
		"category": Category.CRAFTING,
		"icon": ""
	},
	
	# Социальные
	"speech": {
		"name": "Красноречие",
		"description": "Убеждение, торговля, запугивание",
		"category": Category.SOCIAL,
		"icon": ""
	},
	"intimidation": {
		"name": "Запугивание",
		"description": "Устраивание для получения желаемого",
		"category": Category.SOCIAL,
		"icon": ""
	},
	"barter": {
		"name": "Торговля",
		"description": "Умение торговаться и оценивать товар",
		"category": Category.SOCIAL,
		"icon": ""
	},
	
	# Интеллектуальные
	"medicine": {
		"name": "Медицина",
		"description": "Лечение ран, приготовление лекарств",
		"category": Category.INTELLECTUAL,
		"icon": ""
	},
	"computer": {
		"name": "Компьютеры",
		"description": "Программирование, взлом",
		"category": Category.INTELLECTUAL,
		"icon": ""
	},
	"first_aid": {
		"name": "Первая помощь",
		"description": "Оказание экстренной медицинской помощи",
		"category": Category.INTELLECTUAL,
		"icon": ""
	}
}

# Данные навыков игрока
var skills: Dictionary = {}  # skill_id: {xp: float, level: int}

func _init():
	_initialize_skills()

func _initialize_skills():
	for skill_id in SKILL_DEFINITIONS:
		skills[skill_id] = {
			"xp": 0.0,
			"level": 0
		}

# Получить уровень навыка
func get_level(skill_id: String) -> int:
	if skills.has(skill_id):
		return skills[skill_id]["level"]
	return 0

# Получить текущий опыт навыка
func get_xp(skill_id: String) -> float:
	if skills.has(skill_id):
		return skills[skill_id]["xp"]
	return 0.0

# Получить опыт для следующего уровня
func get_xp_for_next_level(skill_id: String) -> float:
	var current_level = get_level(skill_id)
	return _calculate_xp_for_level(current_level + 1)

# Получить прогресс до следующего уровня (0.0 - 1.0)
func get_level_progress(skill_id: String) -> float:
	var current_level = get_level(skill_id)
	var xp_for_current = _calculate_xp_for_level(current_level)
	var xp_for_next = _calculate_xp_for_level(current_level + 1)
	var current_xp = get_xp(skill_id)
	
	if xp_for_next - xp_for_current <= 0:
		return 1.0
	
	return (current_xp - xp_for_current) / (xp_for_next - xp_for_current)

# Добавить опыт к навыку
func add_xp(skill_id: String, amount: float):
	if not skills.has(skill_id):
		return
	
	skills[skill_id]["xp"] += amount
	emit_signal("skill_xp_gained", skill_id, amount, skills[skill_id]["xp"])
	
	# Проверяем повышение уровня
	_check_level_up(skill_id)

# Проверка и применение повышения уровня
func _check_level_up(skill_id: String):
	var xp = skills[skill_id]["xp"]
	var current_level = skills[skill_id]["level"]
	var next_level_xp = _calculate_xp_for_level(current_level + 1)
	
	while xp >= next_level_xp and current_level < 20:
		current_level += 1
		skills[skill_id]["level"] = current_level
		emit_signal("skill_leveled_up", skill_id, current_level)
		next_level_xp = _calculate_xp_for_level(current_level + 1)

# Расчёт опыта для уровня (экспоненциальный рост)
func _calculate_xp_for_level(level: int) -> float:
	if level <= 0:
		return 0.0
	return 100.0 * pow(1.5, level - 1)

# Получить бонус от уровня навыка (для расчётов)
func get_level_bonus(skill_id: String) -> float:
	var level = get_level(skill_id)
	return level * 0.05  # 5% за уровень

# Получить все навыки категории
func get_skills_by_category(category: Category) -> Array:
	var result = []
	for skill_id in SKILL_DEFINITIONS:
		if SKILL_DEFINITIONS[skill_id]["category"] == category:
			result.append(skill_id)
	return result

# Сериализация
func serialize() -> Dictionary:
	return {"skills": skills}

# Десериализация
func deserialize(data: Dictionary):
	if data.has("skills"):
		for skill_id in data["skills"]:
			if skills.has(skill_id):
				skills[skill_id] = data["skills"][skill_id]
