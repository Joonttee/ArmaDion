extends Resource
class_name SkillSet

# SkillSet - набор навыков персонажа
# Система прокачки через использование (как в CDDA)

signal skill_leveled_up(skill_id, new_level)
signal skill_xp_gained(skill_id, amount, total)

# Категории навыков
enum Category { 
	COMBAT, 
	SURVIVAL, 
	CRAFTING, 
	SOCIAL, 
	INTELLECTUAL,
	STEALTH,
	MAGIC
}

# Определения навыков
const SKILL_DEFINITIONS = {
	# ============ БОЕВЫЕ НАВЫКИ ============
	"melee": {
		"name": "Ближний бой",
		"description": "Мастерство владения холодным оружием. Увеличивает урон и точность ударов.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"melee_damage": 0.04, "melee_chance": 0.02}
	},
	"ranged": {
		"name": "Стрельба",
		"description": "Умение стрелять из огнестрельного оружия. Точность, скорострельность, урон.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"ranged_damage": 0.03, "accuracy": 0.05}
	},
	"dodge": {
		"name": "Уклонение",
		"description": "Способность уворачиваться от атак. Шанс избежать удара.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"dodge_chance": 0.03}
	},
	"athletics": {
		"name": "Атлетика",
		"description": "Физическая подготовка. Скорость бега, выносливость, сопротивление усталости.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"move_speed": 0.02, "stamina_regen": 0.05}
	},
	"bashing": {
		"name": "Дробящее оружие",
		"description": "Владение дубинками, молотками, кувалдами. Больше урона и шанс оглушить.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"bash_damage": 0.05, "stun_chance": 0.02}
	},
	"piercing": {
		"name": "Колющее оружие",
		"description": "Владение ножами, копьями, шпагами. Шанс критического удара.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"pierce_damage": 0.05, "crit_chance": 0.03}
	},
	"slashing": {
		"name": "Рубящее оружие",
		"description": "Владение мечами, топорами, мачете. Урон по площади.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"slash_damage": 0.05, "cleave": 0.02}
	},
	"throwing": {
		"name": "Метательное оружие",
		"description": "Метание ножей, гранат, копий. Дальность и точность.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"throw_range": 0.05, "throw_accuracy": 0.04}
	},
	"grappling": {
		"name": "Борьба",
		"description": "Удары без оружия, захваты, броски. Шанс обезоружить.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"unarmed_damage": 0.06, "disarm_chance": 0.02}
	},
	"archery": {
		"name": "Стрельба из лука",
		"description": "Владение луками и арбалетами. Точность и урон на дальних дистанциях.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"bow_damage": 0.04, "bow_accuracy": 0.05}
	},
	"firearms": {
		"name": "Стрелковое дело",
		"description": "Обслуживание и модификация огнестрельного оружия. Меньше застреваний.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"jam_chance": -0.05, "reload_speed": 0.03}
	},
	"marksmanship": {
		"name": "Снайперская подготовка",
		"description": "Точная стрельба на дальние дистанции. Критический урон.",
		"category": Category.COMBAT,
	"icon": "",
		"effects": {"headshot_chance": 0.03, "crit_damage": 0.05}
	},
	"defense": {
		"name": "Защита",
		"description": "Блокирование ударов щитом и оружием. Снижение получаемого урона.",
		"category": Category.COMBAT,
		"icon": "",
		"effects": {"block_chance": 0.04, "damage_reduction": 0.02}
	},
	
	# ============ ВЫЖИВАНИЕ ============
	"survival": {
		"name": "Выживание",
		"description": "Базовые навыки выживания. Поиск ресурсов, ориентирование, укрытия.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"resource_find": 0.05, "shelter_quality": 0.03}
	},
	"cooking": {
		"name": "Кулинария",
		"description": "Приготовление пищи. Лучшее качество блюд, меньше отравлений.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"food_quality": 0.05, "food_preservation": 0.03}
	},
	"farming": {
		"name": "Фермерство",
		"description": "Выращивание растений. Быстрый рост, больше урожая.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"growth_speed": 0.04, "harvest_yield": 0.04}
	},
	"foraging": {
		"name": "Собирательство",
		"description": "Поиск дикорастущих растений, грибов, ягод. Больше находок.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"forage_find": 0.06, "identify_plants": 0.05}
	},
	"fishing": {
		"name": "Рыбалка",
		"description": "Ловля рыбы. Больше шанс поймать, редкие виды.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"fish_catch": 0.05, "rare_fish": 0.02}
	},
	"hunting": {
		"name": "Охота",
		"description": "Отслеживание и добыча дичи. Качество трофеев.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"track_animals": 0.05, "hunt_success": 0.04}
	},
	"trapping": {
		"name": "Ловушки",
		"description": "Установка и создание ловушек. Эффективность и маскировка.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"trap_effectiveness": 0.06, "trap_stealth": 0.04}
	},
	"tracking": {
		"name": "Следопыт",
		"description": "Чтение следов, выслеживание существ. Определение опасности.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"track_reading": 0.06, "detect_threats": 0.04}
	},
	"firearms_safety": {
		"name": "Безопасность обращения",
		"description": "Правильное обращение с оружием. Меньше несчастных случаев.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"accident_chance": -0.1, "weapon_durability": 0.05}
	},
	"swimming": {
		"name": "Плавание",
		"description": "Умение плавать. Скорость в воде, сопротивление течению.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"swim_speed": 0.05, "drown_resist": 0.05}
	},
	"climbing": {
		"name": "Альпинизм",
		"description": "Лазание по стенам, деревьям, скалам. Шанс упасть.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"climb_speed": 0.04, "fall_chance": -0.05}
	},
	"navigation": {
		"name": "Навигация",
		"description": "Ориентирование по карте, компасу, звёздам. Меньше шанс заблудиться.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"map_accuracy": 0.05, "get_lost": -0.05}
	},
	"weather_sense": {
		"name": "Чувство погоды",
		"description": "Предсказание погоды по признакам. Подготовка к штормам.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"weather_predict": 0.06, "weather_resist": 0.03}
	},
	"camping": {
		"name": "Кемпинг",
		"description": "Установка лагеря, разведение костра. Отдых и восстановление.",
		"category": Category.SURVIVAL,
		"icon": "",
		"effects": {"camp_quality": 0.05, "rest_efficiency": 0.04}
	},
	
	# ============ РЕМЕСЛО ============
	"mechanics": {
		"name": "Механика",
		"description": "Ремонт и обслуживание техники. Автомобили, генераторы.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"repair_speed": 0.05, "repair_quality": 0.04}
	},
	"electronics": {
		"name": "Электроника",
		"description": "Работа с электронными устройствами. Схемы, пайка.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"craft_electronics": 0.06, "hack_chance": 0.04}
	},
	"construction": {
		"name": "Строительство",
		"description": "Возведение зданий и сооружений. Прочность и скорость.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"build_speed": 0.04, "structure_health": 0.05}
	},
	"tailoring": {
		"name": "Шитьё",
		"description": "Создание одежды из ткани. Качество и защита.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"craft_clothes": 0.05, "armor_quality": 0.04}
	},
	"metalwork": {
		"name": "Металлообработка",
		"description": "Ковка и обработка металла. Оружие и инструменты.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"craft_metal": 0.06, "metal_quality": 0.04}
	},
	"carpentry": {
		"name": "Плотничество",
		"description": "Работа с деревом. Мебель, укрепления, оружие.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"craft_wood": 0.06, "wood_quality": 0.04}
	},
	"masonry": {
		"name": "Каменная кладка",
		"description": "Работа с камнем и кирпичом. Прочные стены и фундаменты.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"craft_stone": 0.06, "stone_quality": 0.04}
	},
	"plumbing": {
		"name": "Сантехника",
		"description": "Установка и ремонт водопровода. Доступ к воде.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"water_system": 0.05, "water_efficiency": 0.04}
	},
	"chemistry": {
		"name": "Химия",
		"description": "Создание химических соединений. Взрывчатка, лекарства.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"craft_chemicals": 0.06, "explosive_power": 0.04}
	},
	"cooking_advanced": {
		"name": "Продвинутая кулинария",
		"description": "Сложные рецепты, консервирование, ферментация.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"complex_recipes": 0.05, "food_preservation": 0.06}
	},
	"brewing": {
		"name": "Пивоварение",
		"description": "Создание алкоголя и напитков. Качество и крепость.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"brew_quality": 0.06, "alcohol_yield": 0.04}
	},
	"glassworking": {
		"name": "Стеклообработка",
		"description": "Создание стеклянных предметов. Бутылки, линзы.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"craft_glass": 0.06, "glass_quality": 0.04}
	},
	"leatherworking": {
		"name": "Кожевничество",
		"description": "Обработка кожи. Броня, сумки, обувь.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"craft_leather": 0.06, "leather_quality": 0.04}
	},
	"scrap": {
		name": "Разборка",
		"description": "Эффективная разборка предметов на запчасти. Больше материалов.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"scrap_yield": 0.07, "scrap_quality": 0.03}
	},
	"artisan": {
		"name": "Ремесленник",
		"description": "Общее мастерство. Бонус ко всем крафт-навыкам.",
		"category": Category.CRAFTING,
		"icon": "",
		"effects": {"all_craft": 0.02, "craft_speed": 0.03}
	},
	
	# ============ СОЦИАЛЬНЫЕ ============
	"speech": {
		"name": "Красноречие",
		"description": "Убеждение и дипломатия. Успешные переговоры.",
		"category": Category.SOCIAL,
		"icon": "",
		"effects": {"persuasion": 0.05, "npc_trust": 0.04}
	},
	"intimidation": {
		"name": "Запугивание",
		"description": "Устраивание для получения желаемого. Страх у врагов.",
		"category": Category.SOCIAL,
		"icon": "",
		"effects": {"intimidate": 0.05, "enemy_fear": 0.04}
	},
	"barter": {
		"name": "Торговля",
		"description": "Умение торговаться. Лучшие цены покупки и продажи.",
		"category": Category.SOCIAL,
		"icon": "",
		"effects": {"buy_price": -0.03, "sell_price": 0.03}
	},
	"leadership": {
		"name": "Лидерство",
		"description": "Умение вести за собой. Бонус спутников.",
		"category": Category.SOCIAL,
		"icon": "",
		"effects": {"follower_bonus": 0.05, "morale_bonus": 0.04}
	},
	"deception": {
		"name": "Обман",
		"description": "Ложь, маскировка, отвлечение. Обман NPC.",
		"category": Category.SOCIAL,
		"icon": "",
		"effects": {"lie_success": 0.05, "disguise": 0.04}
	},
	"empathy": {
		"name": "Эмпатия",
		"description": "Понимание эмоций других. Успокоение, поддержка.",
		"category": Category.SOCIAL,
		"icon": "",
		"effects": {"calm_npc": 0.05, "detect_lies": 0.04}
	},
	"teaching": {
		"name": "Обучение",
		"description": "Обучение других навыков. Передача знаний.",
		"category": Category.SOCIAL,
		"icon": "",
		"effects": {"teach_speed": 0.06, "learn_speed_others": 0.04}
	},
	"performance": {
		"name": "Выступление",
		"description": "Музыка, театр, речь. Поднятие морали.",
		"category": Category.SOCIAL,
		"icon": "",
		"effects": {"morale_boost": 0.05, "distraction": 0.04}
	},
	
	# ============ ИНТЕЛЛЕКТУАЛЬНЫЕ ============
	"medicine": {
		"name": "Медицина",
		"description": "Лечение ран, болезней, хирургия. Эффективность лечения.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"healing_power": 0.05, "disease_cure": 0.04}
	},
	"computer": {
		"name": "Компьютеры",
		"description": "Программирование, взлом, кибербезопасность.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"hack_speed": 0.06, "data_recovery": 0.04}
	},
	"first_aid": {
		"name": "Первая помощь",
		"description": "Оказание экстренной помощи. Стабилизация состояния.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"first_aid_power": 0.06, "stabilize": 0.04}
	},
	"psychology": {
		"name": "Психология",
		"description": "Понимание поведения. Профилирование, допрос.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"profile_npc": 0.05, "interrogate": 0.04}
	},
	"engineering": {
		"name": "Инженерия",
		"description": "Проектирование сложных систем. Механизмы, ловушки.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"design_complex": 0.05, "trap_power": 0.04}
	},
	"mathematics": {
		"name": "Математика",
		"description": "Расчёты, баллистика, оптимизация. Бонус к точности.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"accuracy_bonus": 0.03, "optimize": 0.04}
	},
	"physics": {
		"name": "Физика",
		"description": "Понимание законов физики. Взрывчатка, механизмы.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"explosive_yield": 0.04, "mechanism_power": 0.04}
	},
	"biology": {
		"name": "Биология",
		"description": "Изучение живых организмов. Мутации, болезни.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"understand_mutants": 0.05, "cure_disease": 0.03}
	},
	"geography": {
		"name": "География",
		"description": "Знание местности. Лучшая навигация, ресурсы.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"map_knowledge": 0.05, "resource_locations": 0.04}
	},
	"history": {
		"name": "История",
		"description": "Знание прошлого. Нахождение скрытых мест.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"find_secrets": 0.04, "lore_knowledge": 0.05}
	},
	"literature": {
		"name": "Литература",
		"description": "Чтение, письмо, расшифровка. Книги дают больше.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"book_xp": 0.05, "decrypt": 0.04}
	},
	"law": {
		"name": "Право",
		"description": "Знание законов. Обход ограничений, юридические лазейки.",
		"category": Category.INTELLECTUAL,
		"icon": "",
		"effects": {"loophole_find": 0.04, "legal_immunity": 0.03}
	},
	
	# ============ СКРЫТНОСТЬ ============
	"stealth": {
		"name": "Скрытность",
		"description": "Тихое передвижение. Шанс остаться незамеченным.",
		"category": Category.STEALTH,
		"icon": "",
		"effects": {"noise_reduction": 0.06, "detection_chance": -0.05}
	},
	"lockpicking": {
		"name": "Взлом замков",
		"description": "Открытие замков без ключа. Сложные замки.",
		"category": Category.STEALTH,
		"icon": "",
		"effects": {"lockpick_speed": 0.06, "lockpick_chance": 0.05}
	},
	"pickpocket": {
		"name": "Карманник",
		"description": "Кража у NPC. Шанс успеха и незаметность.",
		"category": Category.STEALTH,
		"icon": "",
		"effects": {"pickpocket_chance": 0.05, "stealth_bonus": 0.04}
	},
	"disguise": {
		"name": "Маскировка",
		"description": "Смена внешности. Обман стражников.",
		"category": Category.STEALTH,
		"icon": "",
		"effects": {"disguise_quality": 0.06, "blend_in": 0.04}
	},
	"sneak_attack": {
		"name": "Удар в спину",
		"description": "Атака из тени. Критический урон.",
		"category": Category.STEALTH,
		"icon": "",
		"effects": {"backstab_damage": 0.08, "backstab_chance": 0.04}
	},
	"camouflage": {
		"name": "Камуфляж",
		"description": "Маскировка на местности. Невидимость в определённых биомах.",
		"category": Category.STEALTH,
		"icon": "",
		"effects": {"camo_effectiveness": 0.06, "ambush_bonus": 0.04}
	},
	"trap_spotting": {
		"name": "Обнаружение ловушек",
		"description": "Замечание скрытых опасностей. Шанс обнаружить.",
		"category": Category.STEALTH,
		"icon": "",
		"effects": {"trap_detect": 0.07, "trap_disarm": 0.04}
	},
	
	# ============ МАГИЯ/СПЕЦИАЛЬНОЕ ============
	"occult": {
		"name": "Оккультизм",
		"description": "Знание тёмных искусств. Ритуалы, призыв.",
		"category": Category.MAGIC,
		"icon": "",
		"effects": {"ritual_power": 0.05, "dark_knowledge": 0.04}
	},
	"psychic": {
		"name": "Псионика",
		"description": "Телепатия, телекинез. Чтение мыслей.",
		"category": Category.MAGIC,
		"icon": "",
		"effects": {"mind_read": 0.04, "telekinesis": 0.03}
	},
	"mutation_resistance": {
		"name": "Сопротивление мутациям",
		"description": "Защита от радиации и мутаций. Стабильность ДНК.",
		"category": Category.MAGIC,
		"icon": "",
		"effects": {"radiation_resist": 0.06, "mutation_block": 0.05}
	},
	"zombie_attraction": {
		"name": "Контроль зомби",
		"description": "Управление вниманием зомби. Привлечение или отпугивание.",
		"category": Category.MAGIC,
		"icon": "",
		"effects": {"zombie_attract": -0.05, "zombie_repel": 0.04}
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

# Получить эффекты навыка
func get_skill_effects(skill_id: String) -> Dictionary:
	if SKILL_DEFINITIONS.has(skill_id):
		return SKILL_DEFINITIONS[skill_id].get("effects", {})
	return {}

# Сериализация
func serialize() -> Dictionary:
	return {"skills": skills}

# Десериализация
func deserialize(data: Dictionary):
	if data.has("skills"):
		for skill_id in data["skills"]:
			if skills.has(skill_id):
				skills[skill_id] = data["skills"][skill_id]
