extends Resource
class_name FarmingDatabase

# FarmingDatabase - расширенная база фермерства (20+ культур)

const CROPS = {
	# === ОВОЩИ (8 культур) ===
	"carrot": {
		"name": "Морковь",
		"growth_time": 7200,
		"yield": {"carrot": 3},
		"seasons": [0, 1, 2],  # Весна, лето, осень
		"water_needs": 30,
		"sun_needs": 50,
		"skill": {"farming": 1}
	},
	"potato": {
		"name": "Картофель",
		"growth_time": 10800,
		"yield": {"potato": 4},
		"seasons": [0, 1],
		"water_needs": 40,
		"sun_needs": 40,
		"skill": {"farming": 1}
	},
	"tomato": {
		"name": "Помидор",
		"growth_time": 9000,
		"yield": {"tomato": 3},
		"seasons": [1],
		"water_needs": 50,
		"sun_needs": 70,
		"skill": {"farming": 2}
	},
	"corn": {
		"name": "Кукуруза",
		"growth_time": 14400,
		"yield": {"corn": 3},
		"seasons": [1, 2],
		"water_needs": 45,
		"sun_needs": 60,
		"skill": {"farming": 2}
	},
	"pumpkin": {
		"name": "Тыква",
		"growth_time": 18000,
		"yield": {"pumpkin": 2},
		"seasons": [1, 2],
		"water_needs": 55,
		"sun_needs": 65,
		"skill": {"farming": 3}
	},
	"cucumber": {
		"name": "Огурец",
		"growth_time": 6000,
		"yield": {"cucumber": 4},
		"seasons": [1],
		"water_needs": 60,
		"sun_needs": 60,
		"skill": {"farming": 2}
	},
	"pepper": {
		"name": "Перец",
		"growth_time": 12000,
		"yield": {"pepper": 3},
		"seasons": [1],
		"water_needs": 50,
		"sun_needs": 70,
		"skill": {"farming": 3}
	},
	"onion": {
		"name": "Лук",
		"growth_time": 8000,
		"yield": {"onion": 4},
		"seasons": [0, 1, 2],
		"water_needs": 35,
		"sun_needs": 50,
		"skill": {"farming": 1}
	},
	
	# === ФРУКТЫ (5 культур) ===
	"strawberry": {
		"name": "Клубника",
		"growth_time": 5400,
		"yield": {"strawberry": 5},
		"seasons": [0, 1],
		"water_needs": 40,
		"sun_needs": 55,
		"skill": {"farming": 2}
	},
	"blueberry": {
		"name": "Черника",
		"growth_time": 7200,
		"yield": {"blueberry": 4},
		"seasons": [1],
		"water_needs": 45,
		"sun_needs": 50,
		"skill": {"farming": 2}
	},
	"watermelon": {
		"name": "Арбуз",
		"growth_time": 16000,
		"yield": {"watermelon": 2},
		"seasons": [1],
		"water_needs": 70,
		"sun_needs": 80,
		"skill": {"farming": 4}
	},
	"grape": {
		"name": "Виноград",
		"growth_time": 20000,
		"yield": {"grape": 6},
		"seasons": [1, 2],
		"water_needs": 50,
		"sun_needs": 70,
		"skill": {"farming": 4}
	},
	"apple_tree": {
		"name": "Яблоня",
		"growth_time": 28800,
		"yield": {"apple": 6},
		"seasons": [2],
		"water_needs": 30,
		"sun_needs": 45,
		"skill": {"farming": 3},
		"is_tree": true
	},
	
	# === ЗЕРНОВЫЕ (4 культуры) ===
	"wheat": {
		"name": "Пшеница",
		"growth_time": 12600,
		"yield": {"wheat": 4},
		"seasons": [0, 1],
		"water_needs": 35,
		"sun_needs": 50,
		"skill": {"farming": 2}
	},
	"rice": {
		"name": "Рис",
		"growth_time": 14400,
		"yield": {"rice": 5},
		"seasons": [1],
		"water_needs": 80,
		"sun_needs": 60,
		"skill": {"farming": 3}
	},
	"barley": {
		"name": "Ячмень",
		"growth_time": 10800,
		"yield": {"barley": 4},
		"seasons": [0, 1],
		"water_needs": 30,
		"sun_needs": 45,
		"skill": {"farming": 2}
	},
	"oat": {
		"name": "Овёс",
		"growth_time": 9000,
		"yield": {"oat": 4},
		"seasons": [0, 1],
		"water_needs": 35,
		"sun_needs": 40,
		"skill": {"farming": 2}
	},
	
	# === ТРАВЫ И ЛЕКАРСТВА (4 культуры) ===
	"herbs": {
		"name": "Травы",
		"growth_time": 3600,
		"yield": {"herbs": 3},
		"seasons": [0, 1, 2],
		"water_needs": 25,
		"sun_needs": 40,
		"skill": {"farming": 1}
	},
	"aloe_vera": {
		"name": "Алоэ",
		"growth_time": 7200,
		"yield": {"aloe": 2},
		"seasons": [1],
		"water_needs": 20,
		"sun_needs": 60,
		"skill": {"farming": 2}
	},
	"chamomile": {
		"name": "Ромашка",
		"growth_time": 5400,
		"yield": {"chamomile": 4},
		"seasons": [0, 1],
		"water_needs": 30,
		"sun_needs": 50,
		"skill": {"farming": 1}
	},
	"mint": {
		"name": "Мята",
		"growth_time": 4800,
		"yield": {"mint": 5},
		"seasons": [0, 1, 2],
		"water_needs": 40,
		"sun_needs": 45,
		"skill": {"farming": 1}
	}
}

const FERTILIZERS = {
	"compost": {"name": "Компост", "bonus": 0.2, "cost": {"organic_matter": 3}},
	"manure": {"name": "Навоз", "bonus": 0.3, "cost": {"manure": 2}},
	"chemical": {"name": "Химическое удобрение", "bonus": 0.5, "cost": {"chemicals": 2}},
	"bone_meal": {"name": "Костная мука", "bonus": 0.25, "cost": {"bone": 3}}
}

const PESTICIDES = {
	"natural": {"name": "Натуральный пестицид", "effectiveness": 0.6, "cost": {"herbs": 2}},
	"chemical": {"name": "Химический пестицид", "effectiveness": 0.9, "cost": {"chemicals": 3}}
}

static func get_crop(crop_id: String) -> Dictionary:
	return CROPS.get(crop_id, {})

static func get_all_crops() -> Array:
	return CROPS.keys()

static func get_crops_by_season(season: int) -> Array:
	var result = []
	for id in CROPS:
		if CROPS[id]["seasons"].has(season):
			result.append(id)
	return result

static func get_crops_by_skill(skill_level: int) -> Array:
	var result = []
	for id in CROPS:
		if CROPS[id]["skill"]["farming"] <= skill_level:
			result.append(id)
	return result

static func get_fertilizer(fertilizer_id: String) -> Dictionary:
	return FERTILIZERS.get(fertilizer_id, {})

static func get_pesticide(pesticide_id: String) -> Dictionary:
	return PESTICIDES.get(pesticide_id, {})
