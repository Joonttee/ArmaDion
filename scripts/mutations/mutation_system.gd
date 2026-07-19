extends Node
class_name MutationSystem

# MutationSystem - система мутаций (как в CDDA)
# Пороги мутаций, трансформации, ветки

signal mutation_gained(mutation_id)
signal mutation_lost(mutation_id)
signal threshold_reached(threshold_id)

enum MutationCategory { PHYSICAL, MENTAL, BEAST, PLANT, FISH, INSECT, BIRD, REPTILE, MEDICAL, CHIMERIC }

# Активные мутации
var mutations: Array[String] = []
var thresholds_reached: Array[String] = []

# Очки мутации
var mutation_points: float = 0.0
var mutation_threshold: float = 100.0

# Каталог мутаций
const MUTATION_CATALOG = {
	# === ФИЗИЧЕСКИЕ ===
	"thick_skin": {
		"name": "Грубая кожа",
		"category": MutationCategory.PHYSICAL,
		"points": 10,
		"effects": {"armor": 5, "beauty": -10},
		"description": "+5 броня, -10 привлекательность"
	},
	"tough": {
		"name": "Крепкий",
		"category": MutationCategory.PHYSICAL,
		"points": 15,
		"effects": {"max_health": 20, "pain_resist": 0.2},
		"description": "+20 здоровья, +20% сопротивление боли"
	},
	"strong": {
		"name": "Сильный",
		"category": MutationCategory.PHYSICAL,
		"points": 20,
		"effects": {"strength": 4, "melee_damage": 0.15},
		"description": "+4 сила, +15% урон"
	},
	"dexterous": {
		"name": "Ловкий",
		"category": MutationCategory.PHYSICAL,
		"points": 15,
		"effects": {"dexterity": 4, "attack_speed": 0.1},
		"description": "+4 ловкость, +10% скорость атаки"
	},
	"fast_metabolism": {
		"name": "Быстрый метаболизм",
		"category": MutationCategory.PHYSICAL,
		"points": 10,
		"effects": {"stamina_regen": 0.3, "hunger_rate": 0.3},
		"description": "+30% регенерация, +30% голод"
	},
	"high_pain_threshold": {
		"name": "Высокий болевой порог",
		"category": MutationCategory.PHYSICAL,
		"points": 25,
		"effects": {"pain_tolerance": 0.4, "stress_resist": 0.2},
		"description": "+40% терпимость к боли"
	},
	
	# === ЗВЕРИНЫЕ ===
	"claws": {
		"name": "Когти",
		"category": MutationCategory.BEAST,
		"points": 20,
		"effects": {"unarmed_damage": 10, "climb_bonus": 0.3},
		"description": "+10 урон без оружия, +30% лазание"
	},
	"fangs": {
		"name": "Клыки",
		"category": MutationCategory.BEAST,
		"points": 15,
		"effects": {"bite_damage": 15, "bleed_chance": 0.2},
		"description": "+15 урон укусом, 20% кровотечение"
	},
	"night_vision_beast": {
		"name": "Ночное зрение",
		"category": MutationCategory.BEAST,
		"points": 25,
		"effects": {"night_vision": 1, "dark_visibility": 0.9},
		"description": "Видите в темноте"
	},
	"predator_senses": {
		"name": "Чухи хищника",
		"category": MutationCategory.BEAST,
		"points": 30,
		"effects": {"hearing_range": 0.5, "smell_tracking": 1},
		"description": "+50% слух, отслеживание по запаху"
	},
	"thick_fur": {
		"name": "Густой мех",
		"category": MutationCategory.BEAST,
		"points": 20,
		"effects": {"cold_resist": 0.4, "armor": 3, "heat_vulnerability": 0.2},
		"description": "+40% холод, +3 броня, -20% жара"
	},
	"padded_feet": {
		"name": "Мягкие лапы",
		"category": MutationCategory.BEAST,
		"points": 15,
		"effects": {"noise_reduction": 0.4, "move_speed": 0.1},
		"description": "-40% шума, +10% скорость"
	},
	
	# === РАСТИТЕЛЬНЫЕ ===
	"photosynthesis": {
		"name": "Фотосинтез",
		"category": MutationCategory.PLANT,
		"points": 30,
		"effects": {"sun_nutrition": 0.2, "hunger_rate": -0.3},
		"description": "Питание от солнца, -30% голод"
	},
	"thorns": {
		"name": "Шипы",
		"category": MutationCategory.PLANT,
		"points": 20,
		"effects": {"thorn_damage": 5, "armor": 2},
		"description": "5 урона при касании, +2 броня"
	},
	"bark_skin": {
		"name": "Коровая кожа",
		"category": MutationCategory.PLANT,
		"points": 25,
		"effects": {"armor": 8, "fire_vulnerability": 0.3},
		"description": "+8 броня, -30% огнестойкость"
	},
	"vine_limbs": {
		"name": "Лозовые конечности",
		"category": MutationCategory.PLANT,
		"points": 35,
		"effects": {"reach": 2, "grapple_range": 3},
		"description": "+2 досягаемость, +3 захват"
	},
	"spore_cloud": {
		"name": "Споровое облако",
		"category": MutationCategory.PLANT,
		"points": 40,
		"effects": {"spore_damage": 3, "spore_range": 2},
		"description": "Споры наносят 3 урона в радиусе 2"
	},
	"root_feet": {
		"name": "Корневые ноги",
		"category": MutationCategory.PLANT,
		"points": 30,
		"effects": {"stability": 0.5, "move_speed": -0.2, "health_regen_ground": 1},
		"description": "+50% устойчивость, -20% скорость, реген на земле"
	},
	
	# === ПТИЧЬИ ===
	"wings": {
		"name": "Крылья",
		"category": MutationCategory.BIRD,
		"points": 50,
		"effects": {"flight": 1, "fall_damage": -1.0, "move_speed": 0.2},
		"description": "Полёт, нет урона от падения"
	},
	"hollow_bones": {
		"name": "Полые кости",
		"category": MutationCategory.BIRD,
		"points": 25,
		"effects": {"weight": -10, "move_speed": 0.15, "fracture_risk": 0.2},
		"description": "-10 вес, +15% скорость, +20% переломы"
	},
	"sharp_vision": {
		"name": "Острое зрение",
		"category": MutationCategory.BIRD,
		"points": 20,
		"effects": {"view_range": 0.4, "accuracy": 0.15},
		"description": "+40% обзор, +15% точность"
	},
	"talons": {
		"name": "Когти",
		"category": MutationCategory.BIRD,
		"points": 30,
		"effects": {"unarmed_damage": 12, "bleed_chance": 0.25},
		"description": "+12 урон, 25% кровотечение"
	},
	
	# === РЕПТИЛЬИ ===
	"cold_blooded": {
		"name": "Холоднокровный",
		"category": MutationCategory.REPTILE,
		"points": 20,
		"effects": {"heat_vulnerability": 0.3, "cold_resist": 0.5, "food_efficiency": 0.2},
		"description": "+50% холод, -30% жара, +20% еда"
	},
	"scales": {
		"name": "Чешуя",
		"category": MutationCategory.REPTILE,
		"points": 25,
		"effects": {"armor": 6, "cut_resist": 0.3},
		"description": "+6 броня, +30% сопротивление порезам"
	},
	"regeneration_reptile": {
		"name": "Регенерация",
		"category": MutationCategory.REPTILE,
		"points": 40,
		"effects": {"health_regen": 3, "wound_healing": 0.8},
		"description": "+3 реген здоровья, +80% заживление"
	},
	"poison_bite": {
		"name": "Ядовитый укус",
		"category": MutationCategory.REPTILE,
		"points": 35,
		"effects": {"poison_damage": 5, "poison_chance": 0.3},
		"description": "5 урона ядом, 30% шанс"
	},
	"heat_sensors": {
		"name": "Тепловые сенсоры",
		"category": MutationCategory.REPTILE,
		"points": 30,
		"effects": {"heat_detection": 1, "night_vision": 0.5},
		"description": "Обнаружение тепла, +50% ночное зрение"
	},
	
	# === НАСЕКОМЫЕ ===
	"chitin_armor": {
		"name": "Хитиновая броня",
		"category": MutationCategory.INSECT,
		"points": 30,
		"effects": {"armor": 10, "weight": 5, "noise": 0.1},
		"description": "+10 броня, +5 вес, +10% шум"
	},
	"compound_eyes": {
		"name": "Фасеточные глаза",
		"category": MutationCategory.INSECT,
		"points": 25,
		"effects": {"view_range": 0.3, "peripheral_vision": 1, "beauty": -20},
		"description": "+30% обзор, периферическое зрение, -20 красота"
	},
	"antennae": {
		"name": "Усики",
		"category": MutationCategory.INSECT,
		"points": 20,
		"effects": {"vibration_detection": 1, "smell_bonus": 0.5},
		"description": "Обнаружение вибраций, +50% обоняние"
	},
	"mandibles": {
		"name": "Жвалы",
		"category": MutationCategory.INSECT,
		"points": 25,
		"effects": {"bite_damage": 18, "armor_penetration": 0.2},
		"description": "+18 урон укусом, +20% пробив брони"
	},
	"web_spinneret": {
		"name": "Прядильный орган",
		"category": MutationCategory.INSECT,
		"points": 45,
		"effects": {"web_shooting": 1, "web_range": 3, "web_damage": 8},
		"description": "Стреляет паутиной на 3 тайла, 8 урона"
	},
	
	# === МЕДИЦИНСКИЕ ===
	"rapid_healing": {
		"name": "Быстрое заживление",
		"category": MutationCategory.MEDICAL,
		"points": 30,
		"effects": {"wound_healing": 1.0, "infection_resist": 0.5},
		"description": "+100% заживление, +50% сопротивление инфекции"
	},
	"poison_immunity": {
		"name": "Иммунитет к ядам",
		"category": MutationCategory.MEDICAL,
		"points": 25,
		"effects": {"poison_resist": 1.0, "food_poison_resist": 0.8},
		"description": "Полный иммунитет к ядам"
	},
	"disease_immunity": {
		"name": "Иммунитет к болезням",
		"category": MutationCategory.MEDICAL,
		"points": 35,
		"effects": {"disease_resist": 0.8, "infection_resist": 0.7},
		"description": "+80% сопротивление болезням"
	},
	"pain_immunity": {
		"name": "Иммунитет к боли",
		"category": MutationCategory.MEDICAL,
		"points": 40,
		"effects": {"pain_tolerance": 1.0, "stress_from_pain": 0},
		"description": "Полная нечувствительность к боли"
	},
	"acid_blood": {
		"name": "Кислая кровь",
		"category": MutationCategory.MEDICAL,
		"points": 30,
		"effects": {"acid_damage": 10, "acid_chance": 0.3, "bleed_resist": 0.5},
		"description": "10 урона кислотой при кровотечении, 30% шанс"
	}
}

# Пороги мутаций (ветки)
const MUTATION_THRESHOLDS = {
	"beast_threshold": {
		"name": "Звериный порог",
		"required_category": MutationCategory.BEAST,
		"required_points": 80,
		"effects": {"beast_bonus": 0.3, "humanity": -20},
		"description": "Вы становитесь ближе к зверям"
	},
	"plant_threshold": {
		"name": "Растительный порог",
		"required_category": MutationCategory.PLANT,
		"required_points": 80,
		"effects": {"plant_bonus": 0.3, "humanity": -20},
		"description": "Вы становитесь ближе к растениям"
	},
	"bird_threshold": {
		"name": "Птичий порог",
		"required_category": MutationCategory.BIRD,
		"required_points": 60,
		"effects": {"bird_bonus": 0.3, "humanity": -15},
		"description": "Вы становитесь ближе к птицам"
	},
	"reptile_threshold": {
		"name": "Рептильий порог",
		"required_category": MutationCategory.REPTILE,
		"required_points": 80,
		"effects": {"reptile_bonus": 0.3, "humanity": -20},
		"description": "Вы становитесь ближе к рептилиям"
	},
	"insect_threshold": {
		"name": "Насекомый порог",
		"required_category": MutationCategory.INSECT,
		"required_points": 80,
		"effects": {"insect_bonus": 0.3, "humanity": -25},
		"description": "Вы становитесь ближе к насекомым"
	},
	"chimera_threshold": {
		"name": "Химерный порог",
		"required_categories": 3,
		"required_points": 150,
		"effects": {"chimera_bonus": 0.5, "humanity": -40},
		"description": "Вы химера - смесь всех видов"
	}
}

func add_mutation(mutation_id: String) -> bool:
	if mutations.has(mutation_id):
		return false
	
	var data = MUTATION_CATALOG.get(mutation_id, {})
	if data.is_empty():
		return false
	
	mutations.append(mutation_id)
	mutation_points += data.get("points", 0)
	
	emit_signal("mutation_gained", mutation_id)
	_check_thresholds()
	
	return true

func remove_mutation(mutation_id: String):
	if mutations.has(mutation_id):
		var data = MUTATION_CATALOG.get(mutation_id, {})
		mutation_points -= data.get("points", 0)
		mutations.erase(mutation_id)
		emit_signal("mutation_lost", mutation_id)

func has_mutation(mutation_id: String) -> bool:
	return mutations.has(mutation_id)

func get_mutations_by_category(category: MutationCategory) -> Array:
	var result = []
	for mutation_id in mutations:
		var data = MUTATION_CATALOG.get(mutation_id, {})
		if data.get("category", -1) == category:
			result.append(mutation_id)
	return result

func get_category_points(category: MutationCategory) -> float:
	var points = 0.0
	for mutation_id in get_mutations_by_category(category):
		points += MUTATION_CATALOG[mutation_id].get("points", 0)
	return points

func _check_thresholds():
	for threshold_id in MUTATION_THRESHOLDS:
		if thresholds_reached.has(threshold_id):
			continue
		
		var threshold = MUTATION_THRESHOLDS[threshold_id]
		var category = threshold.get("required_category", -1)
		var required_points = threshold.get("required_points", 999)
		
		if category >= 0 and get_category_points(category) >= required_points:
			thresholds_reached.append(threshold_id)
			emit_signal("threshold_reached", threshold_id)

func get_all_effects() -> Dictionary:
	var effects = {}
	for mutation_id in mutations:
		var data = MUTATION_CATALOG.get(mutation_id, {})
		for effect in data.get("effects", {}):
			effects[effect] = effects.get(effect, 0) + data["effects"][effect]
	return effects
