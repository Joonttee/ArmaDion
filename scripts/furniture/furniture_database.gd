extends Resource
class_name FurnitureDatabase

# FurnitureDatabase - база данных мебели (50+ типов)

const FURNITURE_ITEMS = {
	# === ХРАНИЛИЩА (10 типов) ===
	"wooden_chest": {
		"name": "Деревянный сундук",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 50,
		"storage": 15,
		"cost": {"wood": 4, "nails": 2},
		"sprite": "res://assets/sprites/furniture/wooden_chest.png"
	},
	"metal_locker": {
		"name": "Металлический шкафчик",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 100,
		"storage": 20,
		"cost": {"metal": 4, "nails": 2},
		"sprite": "res://assets/sprites/furniture/metal_locker.png"
	},
	"filing_cabinet": {
		"name": "Картотечный шкаф",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 60,
		"storage": 12,
		"cost": {"metal": 3, "nails": 2},
		"sprite": "res://assets/sprites/furniture/filing_cabinet.png"
	},
	"weapon_rack": {
		"name": "Стенд для оружия",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 80,
		"storage": 10,
		"cost": {"wood": 3, "metal": 2},
		"sprite": "res://assets/sprites/furniture/weapon_rack.png"
	},
	"fridge": {
		"name": "Холодильник",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 70,
		"storage": 15,
		"cost": {"metal": 3, "electronics": 1},
		"sprite": "res://assets/sprites/furniture/fridge.png"
	},
	"freezer": {
		"name": "Морозильник",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 80,
		"storage": 20,
		"cost": {"metal": 4, "electronics": 2},
		"sprite": "res://assets/sprites/furniture/freezer.png"
	},
	"pantry": {
		""name": "Кладовка",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 60,
		"storage": 25,
		"cost": {"wood": 5, "nails": 3},
		"sprite": "res://assets/sprites/furniture/pantry.png"
	},
	"safe": {
		"name": "Сейф",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 200,
		"storage": 10,
		"cost": {"metal": 6, "electronics": 1},
		"locked": true,
		"sprite": "res://assets/sprites/furniture/safe.png"
	},
	"toolbox": {
		"name": "Ящик для инструментов",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 40,
		"storage": 8,
		"cost": {"metal": 2, "nails": 1},
		"sprite": "res://assets/sprites/furniture/toolbox.png"
	},
	"bookshelf": {
		"name": "Книжная полка",
		"type": Furniture.FurnitureType.STORAGE,
		"health": 50,
		"storage": 12,
		"cost": {"wood": 4, "nails": 2},
		"sprite": "res://assets/sprites/furniture/bookshelf.png"
	},
	
	# === СПАЛЬНЫЕ МЕСТА (8 типов) ===
	"bed": {
		"name": "Кровать",
		"type": Furniture.FurnitureType.SLEEP,
		"health": 60,
		"comfort": 30,
		"cost": {"wood": 4, "cloth": 3},
		"sprite": "res://assets/sprites/furniture/bed.png"
	},
	"double_bed": {
		"name": "Двуспальная кровать",
		"type": Furniture.FurnitureType.SLEEP,
		"health": 80,
		"comfort": 50,
		"cost": {"wood": 6, "cloth": 4},
		"sprite": "res://assets/sprites/furniture/double_bed.png"
	},
	"mattress": {
		"name": "Матрас",
		"type": Furniture.FurnitureType.SLEEP,
		"health": 30,
		"comfort": 20,
		"cost": {"cloth": 4},
		"sprite": "res://assets/sprites/furniture/mattress.png"
	},
	"cot": {
		"name": "Раскладушка",
		"type": Furniture.FurnitureType.SLEEP,
		"health": 25,
		"comfort": 15,
		"cost": {"cloth": 2, "metal": 1},
		"sprite": "res://assets/sprites/furniture/cot.png"
	},
	"hammock": {
		"name": "Гамак",
		"type": Furniture.FurnitureType.SLEEP,
		"health": 20,
		"comfort": 25,
		"cost": {"cloth": 3, "rope": 1},
		"sprite": "res://assets/sprites/furniture/hammock.png"
	},
	"couch": {
		"name": "Диван",
		"type": Furniture.FurnitureType.SLEEP,
		"health": 70,
		"comfort": 35,
		"cost": {"wood": 4, "cloth": 4},
		"sprite": "res://assets/sprites/furniture/couch.png"
	},
	"armchair": {
		"name": "Кресло",
		"type": Furniture.FurnitureType.SLEEP,
		"health": 50,
		"comfort": 30,
		"cost": {"wood": 3, "cloth": 3},
		"sprite": "res://assets/sprites/furniture/armchair.png"
	},
	"sleeping_bag": {
		"name": "Спальный мешок",
		"type": Furniture.FurnitureType.SLEEP,
		"health": 15,
		"comfort": 10,
		"cost": {"cloth": 3},
		"sprite": "res://assets/sprites/furniture/sleeping_bag.png"
	},
	
	# === ВЕРСТАКИ (8 типов) ===
	"workbench": {
		"name": "Верстак",
		"type": Furniture.FurnitureType.CRAFT,
		"health": 80,
		"cost": {"wood": 6, "nails": 4, "metal": 2},
		"sprite": "res://assets/sprites/furniture/workbench.png"
	},
	"tool_bench": {
		"name": "Верстак для инструментов",
		"type": Furniture.FurnitureType.CRAFT,
		"health": 100,
		"cost": {"wood": 4, "metal": 4},
		"sprite": "res://assets/sprites/furniture/tool_bench.png"
	},
	"sewing_table": {
		"name": "Швейный стол",
		"type": Furniture.FurnitureType.CRAFT,
		"health": 60,
		"cost": {"wood": 4, "metal": 1, "cloth": 1},
		"sprite": "res://assets/sprites/furniture/sewing_table.png"
	},
	"forge": {
		"name": "Кузница",
		"type": Furniture.FurnitureType.CRAFT,
		"health": 150,
		"cost": {"stone": 6, "metal": 4},
		"sprite": "res://assets/sprites/furniture/forge.png"
	},
	"anvil": {
		"name": "Наковальня",
		"type": Furniture.FurnitureType.CRAFT,
		"health": 200,
		"cost": {"metal": 8},
		"sprite": "res://assets/sprites/furniture/anvil.png"
	},
	"cooking_station": {
		"name": "Кухонная плита",
		"type": Furniture.FurnitureType.CRAFT,
		"health": 70,
		"cost": {"metal": 4, "stone": 2},
		"sprite": "res://assets/sprites/furniture/cooking_station.png"
	},
	"campfire": {
		"name": "Костёр",
		"type": Furniture.FurnitureType.CRAFT,
		"health": 30,
		"warmth": 20,
		"cost": {"wood": 3, "stone": 2},
		"sprite": "res://assets/sprites/furniture/campfire.png"
	},
	"grill": {
		"name": "Гриль",
		"type": Furniture.FurnitureType.CRAFT,
		"health": 50,
		"cost": {"metal": 3, "stone": 1},
		"sprite": "res://assets/sprites/furniture/grill.png"
	},
	
	# === КОНТЕЙНЕРЫ (6 типов) ===
	"barrel": {
		"name": "Бочка",
		"type": Furniture.FurnitureType.CONTAINER,
		"health": 60,
		"storage": 20,
		"cost": {"wood": 3, "metal": 1},
		"sprite": "res://assets/sprites/furniture/barrel.png"
	},
	"crate": {
		"name": "Ящик",
		"type": Furniture.FurnitureType.CONTAINER,
		"health": 40,
		"storage": 15,
		"cost": {"wood": 3, "nails": 2},
		"sprite": "res://assets/sprites/furniture/crate.png"
	},
	"metal_box": {
		"name": "Металлический контейнер",
		"type": Furniture.FurnitureType.CONTAINER,
		"health": 120,
		"storage": 25,
		"cost": {"metal": 5, "nails": 2},
		"sprite": "res://assets/sprites/furniture/metal_box.png"
	},
	"dumpster": {
		"name": "Мусорный контейнер",
		"type": Furniture.FurnitureType.CONTAINER,
		"health": 150,
		"storage": 30,
		"cost": {"metal": 6, "nails": 3},
		"sprite": "res://assets/sprites/furniture/dumpster.png"
	},
	"recycling_bin": {
		"name": "Контейнер для переработки",
		"type": Furniture.FurnitureType.CONTAINER,
		"health": 80,
		"storage": 15,
		"cost": {"metal": 3, "plastic": 2},
		"sprite": "res://assets/sprites/furniture/recycling_bin.png"
	},
	"water_tank": {
		"name": "Резервуар для воды",
		"type": Furniture.FurnitureType.CONTAINER,
		"health": 100,
		"storage": 50,
		"cost": {"metal": 5, "plastic": 2},
		"sprite": "res://assets/sprites/furniture/water_tank.png"
	},
	
	# === ОСВЕЩЕНИЕ (6 типов) ===
	"lamp": {
		"name": "Лампа",
		"type": Furniture.FurnitureType.LIGHT,
		"health": 20,
		"light": 100,
		"cost": {"metal": 1, "glass": 1, "wire": 1},
		"sprite": "res://assets/sprites/furniture/lamp.png"
	},
	"table_lamp": {
		"name": "Настольная лампа",
		"type": Furniture.FurnitureType.LIGHT,
		"health": 15,
		"light": 50,
		"cost": {"metal": 1, "glass": 1, "wire": 1},
		"sprite": "res://assets/sprites/furniture/table_lamp.png"
	},
	"street_light": {
		"name": "Уличный фонарь",
		"type": Furniture.FurnitureType.LIGHT,
		"health": 80,
		"light": 200,
		"cost": {"metal": 4, "glass": 2, "wire": 2},
		"sprite": "res://assets/sprites/furniture/street_light.png"
	},
	"torch": {
		"name": "Факел",
		"type": Furniture.FurnitureType.LIGHT,
		"health": 10,
		"light": 80,
		"cost": {"wood": 1, "cloth": 1},
		"sprite": "res://assets/sprites/furniture/torch.png"
	},
	"candle": {
		"name": "Свеча",
		"type": Furniture.FurnitureType.LIGHT,
		"health": 5,
		"light": 30,
		"cost": {"cloth": 1},
		"sprite": "res://assets/sprites/furniture/candle.png"
	},
	"neon_light": {
		"name": "Неоновая лампа",
		"type": Furniture.FurnitureType.LIGHT,
		"health": 25,
		"light": 150,
		"cost": {"glass": 2, "wire": 1, "electronics": 1},
		"sprite": "res://assets/sprites/furniture/neon_light.png"
	},
	
	# === ОБОГРЕВ (5 типов) ===
	"heater": {
		"name": "Обогреватель",
		"type": Furniture.FurnitureType.HEATING,
		"health": 50,
		"warmth": 30,
		"cost": {"metal": 3, "wire": 2},
		"sprite": "res://assets/sprites/furniture/heater.png"
	},
	"radiator": {
		"name": "Батарея",
		"type": Furniture.FurnitureType.HEATING,
		"health": 80,
		"warmth": 40,
		"cost": {"metal": 4, "pipe": 2},
		"sprite": "res://assets/sprites/furniture/radiator.png"
	},
	"fireplace": {
		"name": "Камин",
		"type": Furniture.FurnitureType.HEATING,
		"health": 120,
		"warmth": 50,
		"cost": {"stone": 6, "brick": 4},
		"sprite": "res://assets/sprites/furniture/fireplace.png"
	},
	"wood_stove": {
		"name": "Дровяная печь",
		"type": Furniture.FurnitureType.HEATING,
		"health": 100,
		"warmth": 45,
		"cost": {"metal": 5, "stone": 2},
		"sprite": "res://assets/sprites/furniture/wood_stove.png"
	},
	"electric_heater": {
		"name": "Электрический обогреватель",
		"type": Furniture.FurnitureType.HEATING,
		"health": 60,
		"warmth": 35,
		"cost": {"metal": 3, "wire": 2, "electronics": 1},
		"sprite": "res://assets/sprites/furniture/electric_heater.png"
	},
	
	# === ЗАЩИТА (5 типов) ===
	"barricade": {
		"name": "Баррикада",
		"type": Furniture.FurnitureType.DEFENSE,
		"health": 150,
		"defense": 10,
		"cost": {"wood": 4, "nails": 3, "metal": 1},
		"sprite": "res://assets/sprites/furniture/barricade.png"
	},
	"sandbags": {
		"name": "Мешки с песком",
		"type": Furniture.FurnitureType.DEFENSE,
		"health": 200,
		"defense": 15,
		"cost": {"cloth": 4, "sand": 4},
		"sprite": "res://assets/sprites/furniture/sandbags.png"
	},
	"spike_barrier": {
		"name": "Шипы",
		"type": Furniture.FurnitureType.DEFENSE,
		"health": 80,
		"defense": 5,
		"cost": {"metal": 4, "wood": 2},
		"sprite": "res://assets/sprites/furniture/spike_barrier.png"
	},
	"wire_barrier": {
		"name": "Проволочное заграждение",
		"type": Furniture.FurnitureType.DEFENSE,
		"health": 100,
		"defense": 8,
		"cost": {"wire": 4, "metal": 2},
		"sprite": "res://assets/sprites/furniture/wire_barrier.png"
	},
	"watchtower": {
		"name": "Наблюдательная вышка",
		"type": Furniture.FurnitureType.DEFENSE,
		"health": 300,
		"defense": 20,
		"cost": {"wood": 8, "metal": 4, "nails": 4},
		"sprite": "res://assets/sprites/furniture/watchtower.png"
	},
	
	# === ДЕКОРАЦИИ (10 типов) ===
	"table": {
		"name": "Стол",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 40,
		"cost": {"wood": 3, "nails": 2},
		"sprite": "res://assets/sprites/furniture/table.png"
	},
	"chair": {
		"name": "Стул",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 30,
		"cost": {"wood": 2, "nails": 1},
		"sprite": "res://assets/sprites/furniture/chair.png"
	},
	"desk": {
		"name": "Письменный стол",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 50,
		"cost": {"wood": 4, "nails": 2},
		"sprite": "res://assets/sprites/furniture/desk.png"
	},
	"rug": {
		"name": "Ковёр",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 10,
		"cost": {"cloth": 3},
		"sprite": "res://assets/sprites/furniture/rug.png"
	},
	"painting": {
		"name": "Картина",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 10,
		"cost": {"wood": 1, "cloth": 1},
		"sprite": "res://assets/sprites/furniture/painting.png"
	},
	"plant": {
		"name": "Растение",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 10,
		"cost": {"wood": 1},
		"sprite": "res://assets/sprites/furniture/plant.png"
	},
	"statue": {
		"name": "Статуя",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 100,
		"cost": {"stone": 4},
		"sprite": "res://assets/sprites/furniture/statue.png"
	},
	"aquarium": {
		"name": "Аквариум",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 30,
		"cost": {"glass": 4, "metal": 1},
		"sprite": "res://assets/sprites/furniture/aquarium.png"
	},
	"tv": {
		"name": "Телевизор",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 30,
		"cost": {"electronics": 2, "glass": 1, "plastic": 1},
		"sprite": "res://assets/sprites/furniture/tv.png"
	},
	"radio": {
		"name": "Радио",
		"type": Furniture.FurnitureType.DECORATION,
		"health": 20,
		"cost": {"electronics": 1, "wire": 1},
		"sprite": "res://assets/sprites/furniture/radio.png"
	}
}

static func get_furniture_data(furniture_id: String) -> Dictionary:
	return FURNITURE_ITEMS.get(furniture_id, {})

static func get_all_furniture_ids() -> Array:
	return FURNITURE_ITEMS.keys()

static func get_furniture_by_type(type: Furniture.FurnitureType) -> Array:
	var result = []
	for id in FURNITURE_ITEMS:
		if FURNITURE_ITEMS[id]["type"] == type:
			result.append(id)
	return result
