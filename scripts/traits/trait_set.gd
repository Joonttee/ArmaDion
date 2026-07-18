extends Resource
class_name TraitSet

# TraitSet - система черт/особенностей персонажа
# Черты дают постоянные бонусы и штрафы (как в CDDA)

signal trait_gained(trait_id)
signal trait_lost(trait_id)

# Определения черт
const TRAIT_DEFINITIONS = {
	# ============ ПОЗИТИВНЫЕ ЧЕРТЫ ============
	
	# --- Физические ---
	"fast_learner": {
		"name": "Быстрое обучение",
		"description": "Получаете на 50% больше опыта ко всем навыкам",
		"points": 4,
		"category": "positive",
		"effects": {"xp_multiplier": 1.5}
	},
	
	"tough": {
		"name": "Крепкий",
		"description": "+25 к максимальному здоровью, медленнее получаете раны",
		"points": 3,
		"category": "positive",
		"effects": {"max_health_bonus": 25, "wound_resist": 0.2}
	},
	
	"dexterous": {
		"name": "Ловкий",
		"description": "+15% к скорости атаки и взаимодействия",
		"points": 2,
		"category": "positive",
		"effects": {"attack_speed_bonus": 0.15, "interact_speed": 0.15}
	},
	
	"pack_mule": {
		"name": "Вьючный мул",
		"description": "+8 слотов в инвентаре",
		"points": 2,
		"category": "positive",
		"effects": {"inventory_slots_bonus": 8}
	},
	
	"night_vision": {
		"name": "Ночное зрение",
		"description": "Видите в темноте на 50% лучше",
		"points": 2,
		"category": "positive",
		"effects": {"night_vision": true, "dark_vision_bonus": 0.5}
	},
	
	"resilient": {
		"name": "Живучий",
		"description": "Медленнее голодаете (-30%) и испытываете жажду (-30%)",
		"points": 3,
		"category": "positive",
		"effects": {"hunger_rate": 0.7, "thirst_rate": 0.7}
	},
	
	"strong": {
		"name": "Сильный",
		"description": "+20% к урону в ближнем бою, +50% к переносимому весу",
		"points": 3,
		"category": "positive",
		"effects": {"melee_damage_bonus": 0.2, "carry_weight_bonus": 0.5}
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
		"description": "Медикаменты действуют на 50% эффективнее, быстрое заживление",
		"points": 2,
		"category": "positive",
		"effects": {"healing_multiplier": 1.5, "regeneration": 0.5}
	},
	
	"green_thumb": {
		"name": "Зелёный палец",
		"description": "Растения растут на 40% быстрее, +1 к урожаю",
		"points": 2,
		"category": "positive",
		"effects": {"farming_speed_bonus": 0.4, "harvest_bonus": 1}
	},
	
	"lucky": {
		"name": "Везунчик",
		"description": "+25% шанс найти редкие предметы, лучшее качество лута",
		"points": 2,
		"category": "positive",
		"effects": {"loot_bonus": 0.25, "rare_find": 0.15}
	},
	
	"hardy": {
		"name": "Здоровяк",
		"description": "Стамина восстанавливается на 50% быстрее, меньше усталость",
		"points": 2,
		"category": "positive",
		"effects": {"stamina_regen_bonus": 0.5, "fatigue_resist": 0.3}
	},
	
	"eagle_eye": {
		"name": "Орлиный глаз",
		"description": "+20% к дальности обзора, замечаете детали",
		"points": 2,
		"category": "positive",
		"effects": {"view_range": 0.2, "detail_spot": 0.15}
	},
	
	"fearless": {
		"name": "Бесстрашный",
		"description": "Иммунитет к страху, +10% урона когда мало здоровья",
		"points": 2,
		"category": "positive",
		"effects": {"fear_immune": true, "low_health_damage": 0.1}
	},
	
	"light_step": {
		"name": "Лёгкая походка",
		"description": "-40% шума при движении, сложнее обнаружить",
		"points": 3,
		"category": "positive",
		"effects": {"noise_reduction": 0.4, "detection_reduction": 0.3}
	},
	
	"scavenger": {
		"name": "Мусорщик",
		"description": "Находите больше ресурсов при обыске, скрытые предметы",
		"points": 2,
		"category": "positive",
		"effects": {"search_bonus": 0.3, "hidden_find": 0.2}
	},
	
	"survivalist": {
		"name": "Выживальщик",
		"description": "+15% к сопротивлению холоду и жаре, быстрый отдых",
		"points": 2,
		"category": "positive",
		"effects": {"cold_resist": 0.15, "heat_resist": 0.15, "rest_speed": 0.2}
	},
	
	"tinkerer": {
		"name": "Самоделкин",
		"description": "Крафт на 20% быстрее, доступны продвинутые рецепты",
		"points": 3,
		"category": "positive",
		"effects": {"craft_speed": 0.2, "advanced_recipes": true}
	},
	
	"bookworm": {
		"name": "Книжный червь",
		"description": "Книги дают на 100% больше опыта, быстрое чтение",
		"points": 2,
		"category": "positive",
		"effects": {"book_xp_multiplier": 2.0, "read_speed": 0.5}
	},
	
	"iron_lungs": {
		"name": "Железные лёгкие",
		"description": "Можно задержать дыхание на 100% дольше, быстрый бег",
		"points": 1,
		"category": "positive",
		"effects": {"breath_hold": 1.0, "sprint_speed": 0.1}
	},
	
	"pain_resistant": {
		"name": "Устойчивость к боли",
		"description": "-30% штрафов от ран, игнорируете лёгкие раны",
		"points": 3,
		"category": "positive",
		"effects": {"pain_reduction": 0.3, "wound_ignore": 0.2}
	},
	
	"night_owl": {
		"name": "Сова",
		"description": "Не устаёте ночью, +10% скорости в темноте",
		"points": 1,
		"category": "positive",
		"effects": {"no_night_fatigue": true, "night_speed": 0.1}
	},
	
	"pack_rat": {
		"name": "Запасливый",
		"description": "Еда и напитки портятся на 50% медленнее",
		"points": 1,
		"category": "positive",
		"effects": {"food_spoil": 0.5}
	},
	
	"cat_eyes": {
		"name": "Кошачий глаз",
		"description": "Видите в темноте, +10% точности ночью",
		"points": 2,
		"category": "positive",
		"effects": {"night_accuracy": 0.1, "night_vision": true}
	},
	
	"early_bird": {
		"name": "Ранняя пташка",
		"description": "+15% скорости утром, быстрое пробуждение",
		"points": 1,
		"category": "positive",
		"effects": {"morning_speed": 0.15, "wake_speed": 0.5}
	},
	
	"fleet_footed": {
		"name": "Быстроногий",
		"description": "+10% уклонения, быстрый отход от опасности",
		"points": 2,
		"category": "positive",
		"effects": {"dodge_bonus": 0.1, "retreat_speed": 0.15}
	},
	
	"iron_skin": {
		"name": "Железная кожа",
		"description": "+10% сопротивления к укусам и царапинам",
		"points": 2,
		"category": "positive",
		"effects": {"bite_resist": 0.1, "scratch_resist": 0.1}
	},
	
	"adrenaline_junkie": {
		"name": "Адреналиновый наркоман",
		"description": "+25% скорости когда здоровье ниже 25%",
		"points": 2,
		"category": "positive",
		"effects": {"adrenaline_speed": 0.25, "adrenaline_threshold": 0.25}
	},
	
	"photographic_memory": {
		"name": "Фотографическая память",
		"description": "Запоминаете карту местности, не блуждаете",
		"points": 1,
		"category": "positive",
		"effects": {"map_memory": true, "no_wander": true}
	},
	
	# ============ НЕГАТИВНЫЕ ЧЕРТЫ ============
	
	# --- Физические ---
	"weak": {
		"name": "Слабый",
		"description": "-20% к урону в ближнем бою, -30% к переносимому весу",
		"points": -3,
		"category": "negative",
		"effects": {"melee_damage_bonus": -0.2, "carry_weight_bonus": -0.3}
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
		"description": "-25 к максимальному здоровью, лёгко получаете раны",
		"points": -3,
		"category": "negative",
		"effects": {"max_health_bonus": -25, "wound_chance": 0.3}
	},
	
	"smoker": {
		"name": "Курильщик",
		"description": "Быстрее устаёте (+20% расхода стамины), но сигареты поднимают настроение",
		"points": -2,
		"category": "negative",
		"effects": {"stamina_drain_bonus": 0.2, "cigarette_mood": true}
	},
	
	"asthematic": {
		"name": "Астматик",
		"description": "Быстрее расходуется стамина при беге (+40%)",
		"points": -2,
		"category": "negative",
		"effects": {"sprint_stamina_drain_bonus": 0.4}
	},
	
	"heavy_sleeper": {
		"name": "Тяжело просыпающийся",
		"description": "Медленнее восстанавливаетесь после сна (-30%)",
		"points": -1,
		"category": "negative",
		"effects": {"sleep_efficiency": 0.7}
	},
	
	"picky_eater": {
		"name": "Привереда",
		"description": "Некоторая еда не приносит насыщения (-20%)",
		"points": -1,
		"category": "negative",
		"effects": {"food_efficiency": 0.8}
	},
	
	"allergic": {
		"name": "Аллергик",
		"description": "15% негативная реакция на растения и пыльцу",
		"points": -2,
		"category": "negative",
		"effects": {"plant_allergy_chance": 0.15, "pollen_allergy": true}
	},
	
	"clumsy": {
		"name": "Неуклюжий",
		"description": "Медленнее крафтите и строите (-20%), больше шума",
		"points": -2,
		"category": "negative",
		"effects": {"craft_speed_penalty": 0.2, "noise_increase": 0.15}
	},
	
	"addict": {
		"name": "Зависимый",
		"description": "Легко привыкаете к наркотикам/алкоголю (+50% шанс)",
		"points": -3,
		"category": "negative",
		"effects": {"addiction_chance": 0.5, "withdrawal_severity": 0.3}
	},
	
	"pacifist": {
		"name": "Пацифист",
		"description": "-30% к урону по живым целям, сложнее атаковать",
		"points": -2,
		"category": "negative",
		"effects": {"living_damage_penalty": -0.3, "attack_guilt": true}
	},
	
	"short_temper": {
		"name": "Вспыльчивый",
		"description": "Сложнее контролировать себя в стрессовых ситуациях",
		"points": -1,
		"category": "negative",
		"effects": {"stress_resistance": -0.2, "rage_chance": 0.15}
	},
	
	"night_blindness": {
		"name": "Куриная слепота",
		"description": "В темноте видите на 50% хуже",
		"points": -2,
		"category": "negative",
		"effects": {"night_vision_penalty": 0.5, "dark_penalty": true}
	},
	
	"loud": {
		"name": "Громкий",
		"description": "+30% шума при движении, зомби слышат дальше",
		"points": -2,
		"category": "negative",
		"effects": {"noise_increase": 0.3, "zombie_hearing": 0.2}
	},
	
	"insomniac": {
		"name": "Бессонница",
		"description": "Медленнее восстанавливаете стамины во сне (-40%)",
		"points": -2,
		"category": "negative",
		"effects": {"sleep_stamina_regen": 0.6}
	},
	
	"glutton": {
		"name": "Обжора",
		"description": "Голод наступает на 50% быстрее",
		"points": -2,
		"category": "negative",
		"effects": {"hunger_rate": 1.5}
	},
	
	"alcoholic": {
		"name": "Алкоголик",
		"description": "Алкоголь действует слабее, синдром отмены",
		"points": -2,
		"category": "negative",
		"effects": {"alcohol_efficiency": 0.5, "withdrawal": true}
	},
	
	"nervous": {
		"name": "Нервный",
		"description": "Стресс накапливается быстрее, сложнее в переговорах",
		"points": -1,
		"category": "negative",
		"effects": {"stress_rate": 0.3, "speech_penalty": 0.1}
	},
	
	"bad_back": {
		"name": "Слабая спина",
		"description": "-40% к переносимому весу, быстрее устаёте",
		"points": -2,
		"category": "negative",
		"effects": {"carry_weight_bonus": -0.4, "back_pain": true}
	},
	
	"short_breath": {
		"name": "Одышка",
		"description": "Стамина заканчивается на 30% быстрее при беге",
		"points": -2,
		"category": "negative",
		"effects": {"stamina_drain_bonus": 0.3}
	},
	
	"trigger_happy": {
		"name": "Неосторожный стрелок",
		"description": "10% шанс случайного выстрела",
		"points": -2,
		"category": "negative",
		"effects": {"accidental_fire": 0.1}
	},
	
	"technophobe": {
		"name": "Технофоб",
		"description": "Сложнее работать с электроникой и механизмами (-25%)",
		"points": -1,
		"category": "negative",
		"effects": {"electronics_penalty": 0.25, "mechanics_penalty": 0.15}
	},
	
	"illiterate": {
		"name": "Безграмотный",
		"description": "Книги не дают опыта, медленнее учитесь",
		"points": -2,
		"category": "negative",
		"effects": {"no_book_xp": true, "learn_penalty": 0.2}
	},
	
	"claustrophobia": {
		"name": "Клаустрофобия",
		"description": "В замкнутых пространствах стресс и паника",
		"points": -1,
		"category": "negative",
		"effects": {"closed_space_stress": true, "panic_chance": 0.1}
	},
	
	"agoraphobia": {
		"name": "Агорафобия",
		"description": "На открытой местности стресс и паника",
		"points": -1,
		"category": "negative",
		"effects": {"open_space_stress": true, "panic_chance": 0.1}
	},
	
	"hemophiliac": {
		"name": "Гемофилия",
		"description": "Кровотечения в 2 раза сильнее, медленное заживление",
		"points": -3,
		"category": "negative",
		"effects": {"bleeding_multiplier": 2.0, "healing_penalty": 0.3}
	},
	
	"lightweight": {
		"name": "Чувствительный",
		"description": "Алкоголь и наркотики действуют в 2 раза сильнее",
		"points": -1,
		"category": "negative",
		"effects": {"drug_sensitivity": 2.0}
	},
	
	"chain_smoker": {
		"name": "Злостный курильщик",
		"description": "Сигареты нужны каждые 2 часа, иначе стресс",
		"points": -1,
		"category": "negative",
		"effects": {"cigarette_need": true, "withdrawal_stress": true}
	},
	
	"weak_stomach": {
		"name": "Слабый желудок",
		"description": "Сложнее переваривать сырую пищу, отравления чаще",
		"points": -1,
		"category": "negative",
		"effects": {"raw_food_penalty": 0.3, "poison_chance": 0.15}
	},
	
	"paranoid": {
		"name": "Параноик",
		"description": "Видите угрозы где их нет, недоверчивы к NPC",
		"points": -1,
		"category": "negative",
		"effects": {"false_threats": true, "npc_trust_penalty": 0.2}
	},
	
	"coward": {
		"name": "Трус",
		"description": "В бою может наступить паника, -10% урона",
		"points": -2,
		"category": "negative",
		"effects": {"panic_in_combat": true, "damage_penalty": 0.1}
	},
	
	"bad_luck": {
		"name": "Невезучий",
		"description": "Редкие предметы находятся на 25% реже",
		"points": -1,
		"category": "negative",
		"effects": {"loot_penalty": 0.25, "rare_penalty": 0.15}
	},
	
	"zombie_magnet": {
		"name": "Магнит для зомби",
		"description": "Зомби обнаруживают вас на 30% быстрее",
		"points": -3,
		"category": "negative",
		"effects": {"zombie_detection": 0.3, "zombie_attraction": 0.2}
	}
}

# Активные черты персонажа
var positive_traits: Array[String] = []
var negative_traits: Array[String] = []

# Максимальное количество очков черт
const MAX_TRAIT_POINTS = 8

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
