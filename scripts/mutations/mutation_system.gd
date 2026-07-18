extends Resource
class_name Mutation

# Mutation - мутация персонажа
# Может быть положительной или отрицательной
# Вызывается радиацией, укусами, предметами

signal mutation_gained(mutation_id)
signal mutation_lost(mutation_id)
signal mutation_stage_changed(mutation_id, new_stage)

# Типы мутаций
enum Type { POSITIVE, NEGATIVE, MIXED }
# Категории мутаций
enum Category { PHYSICAL, MENTAL, PSYCHIC, INSTABILITY }
# Источники мутаций
enum Source { RADIATION, BITE, ITEM, ENVIRONMENT, RITUAL }

# Определения мутаций
const MUTATION_DEFINITIONS = {
	# ============ ФИЗИЧЕСКИЕ МУТАЦИИ (ПОЗИТИВНЫЕ) ============
	
	"thick_skin": {
		"name": "Грубая кожа",
		"description": "Кожа становится толще и прочнее. +20% к защите от физического урона.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"armor_bonus": 0.1, "bite_resist": 0.15},
		"requirements": {"mutation_resistance": 2},
		"sources": [Source.RADIATION, Source.ENVIRONMENT],
		"icon": ""
	},
	
	"night_vision_mut": {
		"name": "Ночное зрение",
		"description": "Глаза адаптируются к темноте. Видите в темноте всё лучше.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"night_vision_bonus": 0.3, "dark_accuracy": 0.1},
		"requirements": {"mutation_resistance": 1},
		"sources": [Source.RADIATION, Source.ITEM],
		"icon": ""
	},
	
	"regeneration": {
		"name": "Регенерация",
		"description": "Раны заживают быстрее. Восстановление здоровья со временем.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 4,
		"effects_per_stage": {"regen_rate": 0.5, "heal_bonus": 0.1},
		"requirements": {"mutation_resistance": 3},
		"sources": [Source.BITE, Source.ITEM],
		"icon": ""
	},
	
	"extra_fast": {
		"name": "Скорость",
		"description": "Мышцы становятся быстрее. +15% к скорости движения за стадию.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"move_speed_bonus": 0.15, "attack_speed": 0.1},
		"requirements": {"mutation_resistance": 2},
		"sources": [Source.RADIATION, Source.ENVIRONMENT],
		"icon": ""
	},
	
	"strong_mut": {
		"name": "Сила",
		"description": "Мускулатура растёт. +20% к урону в ближнем бою за стадию.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"melee_damage_bonus": 0.2, "carry_weight": 0.15},
		"requirements": {"mutation_resistance": 2},
		"sources": [Source.RADIATION, Source.ITEM],
		"icon": ""
	},
	
	"tough_mut": {
		"name": "Живучесть",
		"description": "Организм становится выносливее. +20 макс. здоровья за стадию.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 4,
		"effects_per_stage": {"max_health_bonus": 20, "stamina_bonus": 10},
		"requirements": {"mutation_resistance": 2},
		"sources": [Source.RADIATION, Source.BITE],
		"icon": ""
	},
	
	"acute_hearing": {
		"name": "Острый слух",
		"description": "Слух обостряется. Слышите врагов заранее.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 2,
		"effects_per_stage": {"hearing_range": 0.3, "detect_bonus": 0.2},
		"requirements": {"mutation_resistance": 1},
		"sources": [Source.RADIATION, Source.ENVIRONMENT],
		"icon": ""
	},
	
	"eagle_eye_mut": {
		"name": "Орлиный глаз",
		"description": "Зрение улучшается. +15% к точности стрельбы за стадию.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"accuracy_bonus": 0.15, "crit_chance": 0.05},
		"requirements": {"mutation_resistance": 2},
		"sources": [Source.RADIATION, Source.ITEM],
		"icon": ""
	},
	
	"poison_immunity": {
		"name": "Иммунитет к ядам",
		"description": "Организм адаптируется к токсинам. Сопротивление ядам и отравлениям.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 2,
		"effects_per_stage": {"poison_resist": 0.5, "food_poison_resist": 0.3},
		"requirements": {"mutation_resistance": 2},
		"sources": [Source.ENVIRONMENT, Source.ITEM],
		"icon": ""
	},
	
	"radiation_resistance_mut": {
		"name": "Радиоустойчивость",
		"description": "Организм адаптируется к радиации. Медленнее накапливаете облучение.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"radiation_resist": 0.3, "radiation_heal": 0.1},
		"requirements": {"mutation_resistance": 1},
		"sources": [Source.RADIATION],
		"icon": ""
	},
	
	"cold_resistance": {
		"name": "Морозоустойчивость",
		"description": "Тело адаптируется к холоду. Мёрзнете медленнее.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 2,
		"effects_per_stage": {"cold_resist": 0.4, "frost_resist": 0.3},
		"requirements": {"mutation_resistance": 1},
		"sources": [Source.ENVIRONMENT],
		"icon": ""
	},
	
	"heat_resistance": {
		"name": "Жароустойчивость",
		"description": "Тело адаптируется к жаре. Медленнее перегреваетесь.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 2,
		"effects_per_stage": {"heat_resist": 0.4, "fire_resist": 0.2},
		"requirements": {"mutation_resistance": 1},
		"sources": [Source.ENVIRONMENT],
		"icon": ""
	},
	
	"water_breathing": {
		"name": "Жабры",
		"description": "Появляются жабры. Можно дышать под водой.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 1,
		"effects_per_stage": {"water_breathing": true, "swim_speed": 0.3},
		"requirements": {"mutation_resistance": 4},
		"sources": [Source.ENVIRONMENT, Source.RITUAL],
		"icon": ""
	},
	
	"extra_arm": {
		"name": "Дополнительная рука",
		"description": "Вырастает дополнительная рука. Можно носить больше предметов.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 1,
		"effects_per_stage": {"extra_slot": 2, "dual_wield": true},
		"requirements": {"mutation_resistance": 5},
		"sources": [Source.RITUAL],
		"icon": ""
	},
	
	"carapace": {
		"name": "Панцирь",
		"description": "На спине вырастает прочный панцирь. +30% к защите со спины.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 2,
		"effects_per_stage": {"back_armor": 0.3, "melee_block": 0.15},
		"requirements": {"mutation_resistance": 3},
		"sources": [Source.RADIATION, Source.BITE],
		"icon": ""
	},
	
	"venom_glands": {
		"name": "Ядовитые железы",
		"description": "Появляются ядовитые железы. Атаки отравляют врагов.",
		"type": Type.POSITIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"venom_damage": 10, "venom_chance": 0.2},
		"requirements": {"mutation_resistance": 3},
		"sources": [Source.BITE, Source.RITUAL],
		"icon": ""
	},
	
	# ============ ФИЗИЧЕСКИЕ МУТАЦИИ (ОТРИЦАТЕЛЬНЫЕ) ============
	
	"brittle_bones": {
		"name": "Хрупкие кости",
		"description": "Кости становятся хрупче. Легче получаете переломы.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"fracture_chance": 0.2, "max_health_bonus": -10},
		"requirements": {},
		"sources": [Source.RADIATION],
		"icon": ""
	},
	
	"muscle_degeneration": {
		"name": "Дегенерация мышц",
		"description": "Мышцы слабеют. -10% к урону и скорости за стадию.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"melee_damage_bonus": -0.1, "move_speed_bonus": -0.1},
		"requirements": {},
		"sources": [Source.RADIATION, Source.BITE],
		"icon": ""
	},
	
	"skin_lesions": {
		"name": "Поражения кожи",
		"description": "На коже появляются язвы. -10% к защите, риск инфекции.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"armor_bonus": -0.1, "infection_chance": 0.15},
		"requirements": {},
		"sources": [Source.RADIATION, Source.ENVIRONMENT],
		"icon": ""
	},
	
	"tremor": {
		"name": "Тремор",
		"description": "Руки дрожат. -15% к точности стрельбы за стадию.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 2,
		"effects_per_stage": {"accuracy_bonus": -0.15, "craft_quality": -0.1},
		"requirements": {},
		"sources": [Source.RADIATION, Source.BITE],
		"icon": ""
	},
	
	"blindness": {
		"name": "Слепота",
		"description": "Зрение ухудшается. Сокращается радиус обзора.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"view_range": -0.25, "accuracy_bonus": -0.2},
		"requirements": {},
		"sources": [Source.RADIATION, Source.ENVIRONMENT],
		"icon": ""
	},
	
	"deafness": {
		"name": "Глухота",
		"description": "Слух ухудшается. Не слышите приближающихся врагов.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 2,
		"effects_per_stage": {"hearing_range": -0.5, "detect_bonus": -0.3},
		"requirements": {},
		"sources": [Source.RADIATION, Source.ENVIRONMENT],
		"icon": ""
	},
	
	"nausea": {
		"name": "Тошнота",
		"description": "Постоянная тошнота. Еда хуже усваивается.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 2,
		"effects_per_stage": {"food_efficiency": 0.7, "stamina_regen": -0.2},
		"requirements": {},
		"sources": [Source.RADIATION, Source.BITE],
		"icon": ""
	},
	
	"radiation_sickness": {
		"name": "Лучевая болезнь",
		"description": "Хроническая лучевая болезнь. Постоянная потеря здоровья.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 3,
		"effects_per_stage": {"health_drain": 1.0, "max_health_bonus": -15},
		"requirements": {},
		"sources": [Source.RADIATION],
		"icon": ""
	},
	
	"zombie_virus": {
		"name": "Вирус зомби",
		"description": "Медленное превращение в зомби. Требует лекарства.",
		"type": Type.NEGATIVE,
		"category": Category.PHYSICAL,
		"max_stage": 5,
		"effects_per_stage": {"zombie_progress": 0.2, "humanity_loss": 0.1},
		"requirements": {},
		"sources": [Source.BITE],
		"icon": ""
	},
	
	"extra_eye": {
		"name": "Лишний глаз",
		"description": "Вырастает лишний глаз. Странно, но полезно.",
		"type": Type.MIXED,
		"category": Category.PHYSICAL,
		"max_stage": 1,
		"effects_per_stage": {"view_range": 0.2, "npc_fear": 0.3},
		"requirements": {"mutation_resistance": 2},
		"sources": [Source.RADIATION, Source.RITUAL],
		"icon": ""
	},
	
	"unstable_dna": {
		"name": "Нестабильная ДНК",
		"description": "ДНК становится нестабильной. Случайные мутации.",
		"type": Type.MIXED,
		"category": Category.INSTABILITY,
		"max_stage": 3,
		"effects_per_stage": {"random_mutation_chance": 0.1, "mutation_power": 0.2},
		"requirements": {},
		"sources": [Source.RADIATION],
		"icon": ""
	},
	
	# ============ МЕНТАЛЬНЫЕ МУТАЦИИ ============
	
	"telepathy": {
		"name": "Телепатия",
		"description": "Можно читать мысли существ. Знаете намерения врагов.",
		"type": Type.POSITIVE,
		"category": Category.PSYCHIC,
		"max_stage": 3,
		"effects_per_stage": {"mind_read": 0.2, "detect_intent": 0.25},
		"requirements": {"mutation_resistance": 3},
		"sources": [Source.RITUAL, Source.ITEM],
		"icon": ""
	},
	
	"pyrokinesis": {
		"name": "Пирокинез",
		"description": "Можно поджигать предметы силой мысли.",
		"type": Type.POSITIVE,
		"category": Category.PSYCHIC,
		"max_stage": 3,
		"effects_per_stage": {"fire_power": 15, "fire_range": 5},
		"requirements": {"mutation_resistance": 4},
		"sources": [Source.RITUAL],
		"icon": ""
	},
	
	"telekinesis": {
		"name": "Телекинез",
		"description": "Можно двигать предметы силой мысли.",
		"type": Type.POSITIVE,
		"category": Category.PSYCHIC,
		"max_stage": 3,
		"effects_per_stage": {"telekinesis_power": 10, "telekinesis_range": 3},
		"requirements": {"mutation_resistance": 4},
		"sources": [Source.RITUAL],
		"icon": ""
	},
	
	"insanity": {
		"name": "Безумие",
		"description": "Рассудок ухудшается. Галлюцинации, страх.",
		"type": Type.NEGATIVE,
		"category": Category.MENTAL,
		"max_stage": 4,
		"effects_per_stage": {"hallucination_chance": 0.15, "stress_rate": 0.2},
		"requirements": {},
		"sources": [Source.RADIATION, Source.RITUAL],
		"icon": ""
	},
	
	"paranoia_mut": {
		"name": "Паранойя",
		"description": "Видите угрозы где их нет. Ложные тревоги.",
		"type": Type.NEGATIVE,
		"category": Category.MENTAL,
		"max_stage": 2,
		"effects_per_stage": {"false_threats": 0.2, "stress_rate": 0.15},
		"requirements": {},
		"sources": [Source.RADIATION, Source.BITE],
		"icon": ""
	},
	
	"amnesia": {
		"name": "Амнезия",
		"description": "Теряете часть навыков. Забываете рецепты.",
		"type": Type.NEGATIVE,
		"category": Category.MENTAL,
		"max_stage": 2,
		"effects_per_stage": {"skill_decay": 0.1, "recipe_forget": 0.15},
		"requirements": {},
		"sources": [Source.RADIATION, Source.BITE],
		"icon": ""
	}
}

# Активные мутации персонажа
var active_mutations: Dictionary = {}  # mutation_id: stage
var radiation_level: float = 0.0
var mutation_resistance: int = 0

func _init():
	pass

# Получить стадию мутации
func get_mutation_stage(mutation_id: String) -> int:
	if active_mutations.has(mutation_id):
		return active_mutations[mutation_id]
	return 0

# Проверить наличие мутации
func has_mutation(mutation_id: String) -> bool:
	return active_mutations.has(mutation_id) and active_mutations[mutation_id] > 0

# Получить максимальную стадию мутации
func get_max_stage(mutation_id: String) -> int:
	if MUTATION_DEFINITIONS.has(mutation_id):
		return MUTATION_DEFINITIONS[mutation_id]["max_stage"]
	return 0

# Можно ли получить мутацию
func can_gain_mutation(mutation_id: String) -> bool:
	if not MUTATION_DEFINITIONS.has(mutation_id):
		return false
	
	var mut_def = MUTATION_DEFINITIONS[mutation_id]
	
	# Проверяем требования
	if mut_def.has("requirements"):
		if mut_def["requirements"].has("mutation_resistance"):
			if mutation_resistance < mut_def["requirements"]["mutation_resistance"]:
				return false
	
	return true

# Получить мутацию
func gain_mutation(mutation_id: String, source: int = 0) -> bool:
	if not can_gain_mutation(mutation_id):
		return false
	
	if not active_mutations.has(mutation_id) or active_mutations[mutation_id] == 0:
		active_mutations[mutation_id] = 1
		emit_signal("mutation_gained", mutation_id)
		print("[Mutation] Gained: %s" % MUTATION_DEFINITIONS[mutation_id]["name"])
	elif active_mutations[mutation_id] < get_max_stage(mutation_id):
		active_mutations[mutation_id] += 1
		emit_signal("mutation_stage_changed", mutation_id, active_mutations[mutation_id])
		print("[Mutation] %s advanced to stage %d" % [MUTATION_DEFINITIONS[mutation_id]["name"], active_mutations[mutation_id]])
	
	return true

# Развить мутацию (увеличить стадию)
func advance_mutation(mutation_id: String) -> bool:
	if not has_mutation(mutation_id):
		return false
	
	var max_stage = get_max_stage(mutation_id)
	if active_mutations[mutation_id] < max_stage:
		active_mutations[mutation_id] += 1
		emit_signal("mutation_stage_changed", mutation_id, active_mutations[mutation_id])
		return true
	return false

# Удалить мутацию
func remove_mutation(mutation_id: String):
	if active_mutations.has(mutation_id):
		active_mutations.erase(mutation_id)
		emit_signal("mutation_lost", mutation_id)
		print("[Mutation] Lost: %s" % MUTATION_DEFINITIONS[mutation_id]["name"])

# Получить эффекты мутации с учётом стадии
func get_mutation_effects(mutation_id: String) -> Dictionary:
	if not has_mutation(mutation_id):
		return {}
	
	var mut_def = MUTATION_DEFINITIONS[mutation_id]
	var stage = active_mutations[mutation_id]
	var effects = {}
	
	if mut_def.has("effects_per_stage"):
		for effect in mut_def["effects_per_stage"]:
			effects[effect] = mut_def["effects_per_stage"][effect] * stage
	
	return effects

# Получить суммарные эффекты всех мутаций
func get_combined_effects() -> Dictionary:
	var combined = {}
	
	for mutation_id in active_mutations:
		var effects = get_mutation_effects(mutation_id)
		for effect in effects:
			if combined.has(effect):
				combined[effect] += effects[effect]
			else:
				combined[effect] = effects[effect]
	
	return combined

# Добавить радиацию
func add_radiation(amount: float):
	radiation_level += amount * (1.0 - mutation_resistance * 0.1)
	radiation_level = max(0, radiation_level)
	
	# Высокая радиация может вызвать мутации
	if radiation_level > 50:
		_chance_for_random_mutation(Source.RADIATION)
	
	print("[Mutation] Radiation level: %.1f" % radiation_level)

# Снизить радиацию
func reduce_radiation(amount: float):
	radiation_level = max(0, radiation_level - amount)

# Обработка укуса зомби
func process_bite():
	# Вирус зомби
	if not has_mutation("zombie_virus"):
		gain_mutation("zombie_virus", Source.BITE)
	else:
		advance_mutation("zombie_virus")
	
	# Шанс на другие мутации от укуса
	_chance_for_random_mutation(Source.BITE)

# Шанс на случайную мутацию
func _chance_for_random_mutation(source: int):
	var chance = 0.1 + (radiation_level * 0.002)
	if randf() < chance:
		_grant_random_mutation(source)

# Получить случайную мутацию
func _grant_random_mutation(source: int):
	var possible_mutations = []
	
	for mut_id in MUTATION_DEFINITIONS:
		var mut_def = MUTATION_DEFINITIONS[mut_id]
		
		# Проверяем источник
		if mut_def["sources"].has(source):
			# Проверяем доступность
			if can_gain_mutation(mut_id):
				possible_mutations.append(mut_id)
	
	if possible_mutations.size() > 0:
		var random_mut = possible_mutations[randi() % possible_mutations.size()]
		gain_mutation(random_mut, source)

# Получить все мутации категории
func get_mutations_by_category(category: int) -> Array:
	var result = []
	for mut_id in MUTATION_DEFINITIONS:
		if MUTATION_DEFINITIONS[mut_id]["category"] == category:
			result.append(mut_id)
	return result

# Получить активные мутации
func get_active_mutations() -> Array:
	var result = []
	for mut_id in active_mutations:
		if active_mutations[mut_id] > 0:
			result.append(mut_id)
	return result

# Сериализация
func serialize() -> Dictionary:
	return {
		"active_mutations": active_mutations,
		"radiation_level": radiation_level,
		"mutation_resistance": mutation_resistance
	}

# Десериализация
func deserialize(data: Dictionary):
	active_mutations = data.get("active_mutations", {})
	radiation_level = data.get("radiation_level", 0.0)
	mutation_resistance = data.get("mutation_resistance", 0)
