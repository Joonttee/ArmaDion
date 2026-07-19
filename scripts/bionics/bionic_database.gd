extends Resource
class_name BionicDatabase

# BionicDatabase - база данных бионики (30+ имплантов)

const BIONICS = {
	# === РУКИ (6 имплантов) */
	"power_arm": {
		"name": "Силавая рука",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.ARM,
		"power": 5.0,
		"effects": {"strength": 5, "melee_damage": 0.2},
		"description": "+5 к силе, +20% урона в ближнем бою"
	},
	"precision_hand": {
		"name": "Точная кисть",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.HAND,
		"power": 2.0,
		"effects": {"dexterity": 3, "craft_quality": 0.3},
		"description": "+3 к ловкости, +30% качество крафта"
	},
	"tool_hand": {
		"name": "Инструментальная рука",
		"type": Bionic.BionicType.ACTIVE,
		"slot": Bionic.BionicSlot.HAND,
		"power": 10.0,
		"effects": {"tool_speed": 0.5},
		"description": "Встроенные инструменты, +50% скорость"
	},
	"shield_arm": {
		"name": "Щит-имплант",
		"type": Bionic.BionicType.ACTIVE,
		"slot": Bionic.BionicSlot.ARM,
		"power": 15.0,
		"effects": {"block_chance": 0.3, "block_damage": 0.5},
		"description": "30% шанс блока, 50% снижение урона"
	},
	"grapple_arm": {
		"name": "Крюк-имплант",
		"type": Bionic.BionicType.ACTIVE,
		"slot": Bionic.BionicSlot.ARM,
		"power": 8.0,
		"effects": {"grapple_range": 5},
		"description": "Крюк для лазания, дальность 5 тайлов"
	},
	"strength_hand": {
		"name": "Силовая перчатка",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.HAND,
		"power": 3.0,
		"effects": {"carry_weight": 20, "throw_distance": 0.5},
		"description": "+20 к переносу, +50% дальность броска"
	},
	
	# === НОГИ (5 имплантов) */
	"speed_leg": {
		"name": "Скоростные ноги",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.LEG,
		"power": 5.0,
		"effects": {"move_speed": 0.3, "dodge_chance": 0.15},
		"description": "+30% скорость, +15% уклонение"
	",
	"jump_leg": {
		"name": "Прыжковые ноги",
		"type": Bionic.BionicType.ACTIVE,
		"slot": Bionic.BionicSlot.LEG,
		"power": 12.0,
		"effects": {"jump_height": 3, "fall_damage": -0.5},
		"description": "Высокий прыжок, -50% урон от падения"
	},
	"stealth_leg": {
		"name": "Бесшумные ноги",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.LEG,
		"power": 4.0,
		"effects": {"noise_reduction": 0.5, "stealth": 0.3},
		"description": "-50% шума, +30% скрытность"
	},
	"stamina_leg": {
		"name": "Выносливые ноги",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.LEG,
		"power": 3.0,
		"effects": {"stamina_regen": 0.5, "sprint_duration": 0.4},
		"description": "+50% регенерация стамины, +40% спринт"
	},
	"climb_leg": {
		"name": "Лазающие ноги",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.LEG,
		"power": 4.0,
		"effects": {"climb_speed": 0.5, "climb_chance": 0.3},
		"description": "+50% скорость лазания, +30% шанс"
	},
	
	# === ГОЛОВА (6 имплантов) */
	"night_vision": {
		"name": "Ночное зрение",
		"type": Bionic.BionicType.TOGGLE,
		"slot": Bionic.BionicSlot.EYE,
		"power": 3.0,
		"effects": {"night_vision": 1, "dark_visibility": 0.8},
		"description": "Видите в темноте"
	},
	"targeting_eye": {
		"name": "Прицельный глаз",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.EYE,
		"power": 2.0,
		"effects": {"accuracy": 0.2, "crit_chance": 0.1},
		"description": "+20% точность, +10% крит"
	},
	"scanner_eye": {
		"name": "Сканер",
		"type": Bionic.BionicType.ACTIVE,
		"slot": Bionic.BionicSlot.EYE,
		"power": 5.0,
		"effects": {"scan_range": 10, "detect_hidden": 1},
		"description": "Сканирование на 10 тайлов, обнаружение скрытого"
	},
	"memory_chip": {
		"name": "Чип памяти",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.HEAD,
		"power": 1.0,
		"effects": {"xp_multiplier": 0.2, "skill_learning": 0.3},
		"description": "+20% опыта, +30% обучение"
	},
	"pain_suppressor": {
		"name": "Подавитель боли",
		"type": Bionic.BionicType.TOGGLE,
		"slot": Bionic.BionicSlot.HEAD,
		"power": 4.0,
		"effects": {"pain_reduction": 0.5, "stress_reduction": 0.3},
		"description": "-50% боли, -30% стресса"
	},
	"combat_chip": {
		"name": "Боевой чип",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.HEAD,
		"power": 3.0,
		"effects": {"attack_speed": 0.15, "reaction_time": 0.2},
		"description": "+15% скорость атаки, +20% реакция"
	},
	
	# === ТОРС (6 имплантов) */
	"power_storage": {
		"name": "Батарея",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.TORSO,
		"power": 0.0,
		"effects": {"max_power": 100},
		"description": "+100 максимальной энергии"
	},
	"regenerator": {
		"name": "Регенератор",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.TORSO,
		"power": 8.0,
		"effects": {"health_regen": 2.0, "wound_healing": 0.5},
		"description": "Регенерация здоровья, +50% заживление"
	},
	"armor_plating": {
		"name": "Бронепластины",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.TORSO,
		"power": 2.0,
		"effects": {"damage_reduction": 0.2, "bullet_resist": 0.3},
		"description": "-20% урона, -30% от пуль"
	},
	"climate_control": {
		"name": "Климат-контроль",
		"type": Bionic.BionicType.TOGGLE,
		"slot": Bionic.BionicSlot.TORSO,
		"power": 5.0,
		"effects": {"temp_tolerance": 20, "weather_resist": 0.5},
		"description": "Терпимость к температуре ±20°C"
	},
	"oxygen_tank": {
		"name": "Кислородный баллон",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicSlot.TORSO,
		"power": 1.0,
		"effects": {"breath_hold": 300, "water_breathing": 1},
		"description": "Дыхание под водой, +5 минут без воздуха"
	},
	"nutrition_extractor": {
		"name": "Экстрактор питательных веществ",
		"type": Bionic.BionicType.PASSIVE,
		"slot": Bionic.BionicType.TORSO,
		"power": 2.0,
		"effects": {"food_efficiency": 0.3, "hunger_rate": -0.2},
		"description": "+30% эффективность еды, -20% голод"
	}
}

static func get_bionic(bionic_id: String) -> Dictionary:
	return BIONICS.get(bionic_id, {})

static func get_all_bionics() -> Array:
	return BIONICS.keys()

static func get_bionics_by_slot(slot: Bionic.BionicSlot) -> Array:
	var result = []
	for id in BIONICS:
		if BIONICS[id]["slot"] == slot:
			result.append(id)
	return result
