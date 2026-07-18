extends Resource
class_name TraitSet

# TraitSet - система черт/особенностей персонажа
# Черты дают постоянные бонусы и штрафы (как в CDDA)

signal trait_gained(trait_id)
signal trait_lost(trait_id)

# Определения черт
const TRAIT_DEFINITIONS = {
	# === ПОЗИТИВНЫЕ ЧЕРТЫ ===
	
	"fast_learner": {
		"name": "Быстрое обучение",
		"description": "Получаете на 50% больше опыта ко всем навыкам",
		"points": 4,
		"category": "positive",
		"effects": {"xp_multiplier": 1.5}
	},
	
	"tough": {
		"name": "Крепкий",
		"description": "+25 к максимальному здоровью",
		"points": 3,
		"category": "positive",
		"effects": {"max_health_bonus": 25}
	},
	
	"dexterous": {
		"name": "Ловкий",
		"description": "+10% к скорости атаки",
		"points": 2,
		"category": "positive",
		"effects": {"attack_speed_bonus": 0.1}
	},
	
	"pack_mule": {
		"name": "Вьючный мул",
		"description": "+5 слотов в инвентаре",
		"points": 2,
		"category": "positive",
		"effects": {"inventory_slots_bonus": 5}
	},
	
	"night_vision": {
		"name": "Ночное зрение",
		"description": "Лучше видите в темноте",
		"points": 2,
		"category": "positive",
		"effects": {"night_vision": true}
	},
	
	"resilient": {
		"name": "Живучий",
		"description": "Медленнее голодаете и испытываете жажду",
		"points": 3,
		"category": "positive",
		"effects": {"hunger_rate": 0.7, "thirst_rate": 0.7}
	},
	
	"strong": {
		"name": "Сильный",
		"description": "+20% к урону в ближнем бою",
		"points": 3,
		"category": "positive",
		"effects": {"melee_damage_bonus": 0.2}
	},
	
	"quick": {
		"name": "Быстрый",
		"description": "+15% к скорости передвижения",
		"points": 3,
		"category": "positive",
		"effects": {"move_speed_bonus": 0.15}
	},
	
	"healer": {
		"name": "Целитель",
		"description": "Медикаменты действуют на 50% эффективнее",
		"points": 2,
		"category": "positive",
		"effects": {"healing_multiplier": 1.5}
	},
	
	"green_thumb": {
		"name": "Зелёный палец",
		"description": "Растения растут на 30% быстрее",
		"points": 2,
		"category": "positive",
		"effects": {"farming_speed_bonus": 0.3}
	},
	
	"lucky": {
		"name": "Везунчик",
		"description": "Больше шанс найти редкие предметы",
		"points": 2,
		"category": "positive",
		"effects": {"loot_bonus": 0.2}
	},
	
	"hardy": {
		"name": "Здоровяк",
		"description": "Стамина восстанавливается на 50% быстрее",
		"points": 2,
		"category": "positive",
		"effects": {"stamina_regen_bonus": 0.5}
	},
	
	# === НЕГАТИВНЫЕ ЧЕРТЫ ===
	
	"weak": {
		"name": "Слабый",
		"description": "-20% к урону в ближнем бою",
		"points": -3,
		"category": "negative",
		"effects": {"melee_damage_bonus": -0.2}
	},
	
	"slow": {
		"name": "Медленный",
		"description": "-15% к скорости передвижения",
		"points": -2,
		"category": "negative",
		"effects": {"move_speed_bonus": -0.15}
	},
	
	"fragile": {
		"name": "Хрупкий",
		"description": "-25 к максимальному здоровью",
		"points": -3,
		"category": "negative",
		"effects": {"max_health_bonus": -25}
	},
	
	"smoker": {
		"name": "Курильщик",
		"description": "Быстрее устаёте, но сигареты поднимают настроение",
		"points": -2,
		"category": "negative",
		"effects": {"stamina_drain_bonus": 0.2}
	},
	
	"asthematic": {
		"name": "Астматик",
		"description": "Быстрее расходуется стамина при беге",
		"points": -2,
		"category": "negative",
		"effects": {"sprint_stamina_drain_bonus": 0.3}
	},
	
	"heavy_sleeper": {
		"name": "Тяжело просыпающийся",
		"description": "Медленнее восстанавливаетесь после сна",
		"points": -1,
		"category": "negative",
		"effects": {"sleep_efficiency": 0.7}
	},
	
	"picky_eater": {
		"name": "Привереда",
		"description": "Некоторая еда не приносит насыщения",
		"points": -1,
		"category": "negative",
		"effects": {"food_efficiency": 0.8}
	},
	
	"allergic": {
		"name": "Аллергик",
		"description": "Иногда негативная реакция на растения",
		"points": -2,
		"category": "negative",
		"effects": {"plant_allergy_chance": 0.1}
	},
	
	"clumsy": {
		"name": "Неуклюжий",
		"description": "Медленнее крафтите и строите",
		"points": -2,
		"category": "negative",
		"effects": {"craft_speed_penalty": 0.2}
	},
	
	"addict": {
		"name": "Зависимый",
		"description": "Легко привыкаете к наркотикам/алкоголю",
		"points": -3,
		"category": "negative",
		"effects": {"addiction_chance": 0.3}
	},
	
	"pacifist": {
		"name": "Пацифист",
		"description": "-30% к урону по живым целям",
		"points": -2,
		"category": "negative",
		"effects": {"living_damage_penalty": -0.3}
	},
	
	"short_temper": {
		"name": "Вспыльчивый",
		"description": "Сложнее контролировать себя в стрессовых ситуациях",
		"points": -1,
		"category": "negative",
		"effects": {"stress_resistance": -0.2}
	}
}

# Активные черты персонажа
var positive_traits: Array[String] = []
var negative_traits: Array[String] = []

# Максимальное количество очков черт
const MAX_TRAIT_POINTS = 6

func _init():
	pass

# Получить стоимость черты в очках
func get_trait_points(trait_id: String) -> int:
	if TRAIT_DEFINITIONS.has(trait_id):
		return TRAIT_DEFINITIONS[trait_id]["points"]
	return 0

# Проверить, можно ли взять черту
func can_take_trait(trait_id: String) -> bool:
	if not TRAIT_DEFINITIONS.has(trait_id):
		return false
	
	# Уже есть
	if has_trait(trait_id):
		return false
	
	var points = get_trait_points(trait_id)
	var current_points = _calculate_total_points()
	
	# Для позитивных проверяем лимит
	if points > 0:
		return current_points + points <= MAX_TRAIT_POINTS
	
	# Негативные всегда можно взять
	return true

# Взять черту
func add_trait(trait_id: String) -> bool:
	if not can_take_trait(trait_id):
		return false
	
	var points = get_trait_points(trait_id)
	
	if points > 0:
		positive_traits.append(trait_id)
	else:
		negative_traits.append(trait_id)
	
	emit_signal("trait_gained", trait_id)
	return true

# Убрать черту
func remove_trait(trait_id: String):
	positive_traits.erase(trait_id)
	negative_traits.erase(trait_id)
	emit_signal("trait_lost", trait_id)

# Проверить наличие черты
func has_trait(trait_id: String) -> bool:
	return trait_id in positive_traits or trait_id in negative_traits

# Получить суммарные эффекты всех черт
func get_combined_effects() -> Dictionary:
	var combined = {}
	
	for trait_id in positive_traits + negative_traits:
		if TRAIT_DEFINITIONS.has(trait_id):
			var effects = TRAIT_DEFINITIONS[trait_id]["effects"]
			for effect in effects:
				if combined.has(effect):
					# Складываем числовые эффекты
					if effects[effect] is float:
						combined[effect] += effects[effect]
					elif effects[effect] is int:
						combined[effect] += effects[effect]
				else:
					combined[effect] = effects[effect]
	
	return combined

# Получить эффект конкретной черты
func get_trait_effect(trait_id: String, effect_name: String):
	if TRAIT_DEFINITIONS.has(trait_id):
		var effects = TRAIT_DEFINITIONS[trait_id]["effects"]
		if effects.has(effect_name):
			return effects[effect_name]
	return null

# Рассчитать суммарные очки черт
func _calculate_total_points() -> int:
	var total = 0
	for trait_id in positive_traits:
		total += get_trait_points(trait_id)
	for trait_id in negative_traits:
		total += get_trait_points(trait_id)
	return total

# Получить доступные очки
func get_remaining_points() -> int:
	return MAX_TRAIT_POINTS - _calculate_total_points()

# Получить все позитивные черты
func get_all_positive_traits() -> Array:
	var result = []
	for trait_id in TRAIT_DEFINITIONS:
		if TRAIT_DEFINITIONS[trait_id]["category"] == "positive":
			result.append(trait_id)
	return result

# Получить все негативные черты
func get_all_negative_traits() -> Array:
	var result = []
	for trait_id in TRAIT_DEFINITIONS:
		if TRAIT_DEFINITIONS[trait_id]["category"] == "negative":
			result.append(trait_id)
	return result

# Сериализация
func serialize() -> Dictionary:
	return {
		"positive_traits": positive_traits,
		"negative_traits": negative_traits
	}

# Десериализация
func deserialize(data: Dictionary):
	positive_traits = data.get("positive_traits", [])
	negative_traits = data.get("negative_traits", [])
