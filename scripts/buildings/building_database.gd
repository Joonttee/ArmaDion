extends Resource
class_name BuildingDatabase

# BuildingDatabase - база данных строительных элементов (50+ типов)

const BUILDING_PIECES = {
	# === СТЕНЫ (8 типов) ===
	"wall_wood": {"name": "Деревянная стена", "type": 0, "material": 0, "health": 100, "defense": 5, "cost": {"wood": 4, "nails": 2}, "time": 3.0},
	"wall_metal": {"name": "Металлическая стена", "type": 0, "material": 1, "health": 200, "defense": 15, "cost": {"metal": 4, "nails": 2}, "time": 5.0},
	"wall_brick": {"name": "Кирпичная стена", "type": 0, "material": 2, "health": 300, "defense": 20, "cost": {"brick": 6, "cement": 1}, "time": 6.0},
	"wall_stone": {"name": "Каменная стена", "type": 0, "material": 3, "health": 400, "defense": 25, "cost": {"stone": 8, "cement": 2}, "time": 8.0},
	"wall_reinforced": {"name": "Укреплённая стена", "type": 0, "material": 4, "health": 600, "defense": 40, "cost": {"metal": 4, "brick": 4, "cement": 2}, "time": 10.0},
	"wall_glass": {"name": "Стеклянная стена", "type": 0, "material": 0, "health": 50, "defense": 2, "cost": {"wood": 2, "glass": 4}, "time": 4.0},
	"wall_curtain": {"name": "Занавеска", "type": 0, "material": 0, "health": 20, "defense": 1, "cost": {"cloth": 3, "wood": 1}, "time": 2.0},
	"wall_secret": {"name": "Секретная стена", "type": 0, "material": 0, "health": 80, "defense": 5, "cost": {"wood": 4, "metal": 1}, "time": 4.0},
	
	# === ДВЕРИ (6 типов) ===
	"door_wood": {"name": "Деревянная дверь", "type": 1, "material": 0, "health": 80, "defense": 3, "cost": {"wood": 3, "nails": 2, "metal": 1}, "time": 2.0},
	"door_metal": {"name": "Металлическая дверь", "type": 1, "material": 1, "health": 150, "defense": 10, "cost": {"metal": 3, "nails": 2, "spring": 1}, "time": 4.0},
	"door_reinforced": {"name": "Укреплённая дверь", "type": 1, "material": 4, "health": 300, "defense": 25, "cost": {"metal": 4, "wood": 2, "spring": 2}, "time": 6.0},
	"door_garage": {"name": "Гаражная дверь", "type": 1, "material": 1, "health": 200, "defense": 15, "cost": {"metal": 6, "spring": 2, "motor": 1}, "time": 8.0},
	"door_sliding": {"name": "Раздвижная дверь", "type": 1, "material": 1, "health": 120, "defense": 8, "cost": {"metal": 3, "glass": 2, "spring": 1}, "time": 5.0},
	"door_hidden": {"name": "Скрытая дверь", "type": 1, "material": 0, "health": 60, "defense": 3, "cost": {"wood": 3, "metal": 1, "spring": 1}, "time": 3.0},
	
	# === ОКНА (4 типа) ===
	"window_simple": {"name": "Простое окно", "type": 2, "material": 0, "health": 40, "defense": 2, "cost": {"wood": 2, "glass": 1}, "time": 2.0},
	"window_reinforced": {"name": "Укреплённое окно", "type": 2, "material": 1, "health": 100, "defense": 8, "cost": {"metal": 2, "glass": 2}, "time": 3.0},
	"window_bulletproof": {"name": "Бронестекло", "type": 2, "material": 4, "health": 250, "defense": 20, "cost": {"metal": 3, "glass": 4, "plastic": 2}, "time": 5.0},
	"window_shutter": {"name": "Окно с ставнями", "type": 2, "material": 0, "health": 80, "defense": 5, "cost": {"wood": 3, "glass": 1, "metal": 1}, "time": 3.0},
	
	# === ЗАБОРЫ (5 типов) ===
	"fence_wood": {"name": "Деревянный забор", "type": 3, "material": 0, "health": 60, "defense": 3, "cost": {"wood": 2, "nails": 1}, "time": 1.0},
	"fence_metal": {"name": "Металлический забор", "type": 3, "material": 1, "health": 120, "defense": 8, "cost": {"metal": 3, "wire": 2}, "time": 3.0},
	"fence_chain": {"name": "Сетчатый забор", "type": 3, "material": 1, "health": 80, "defense": 5, "cost": {"wire": 4, "metal": 1}, "time": 2.0},
	"fence_barbed": {"name": "Забор с колючей проволокой", "type": 3, "material": 1, "health": 100, "defense": 10, "cost": {"wire": 4, "metal": 2}, "time": 3.0},
	"fence_electric": {"name": "Электрический забор", "type": 3, "material": 1, "health": 150, "defense": 15, "cost": {"wire": 4, "metal": 2, "battery": 1, "electronics": 1}, "time": 5.0},
	
	# === ПОЛЫ (4 типа) ===
	"floor_wood": {"name": "Деревянный пол", "type": 4, "material": 0, "health": 80, "defense": 2, "cost": {"wood": 3, "nails": 2}, "time": 2.0},
	"floor_metal": {"name": "Металлический пол", "type": 4, "material": 1, "health": 150, "defense": 8, "cost": {"metal": 3, "nails": 2}, "time": 4.0},
	"floor_tile": {"name": "Плиточный пол", "type": 4, "material": 3, "health": 200, "defense": 10, "cost": {"stone": 4, "cement": 1}, "time": 5.0},
	"floor_concrete": {"name": "Бетонный пол", "type": 4, "material": 2, "health": 300, "defense": 15, "cost": {"cement": 3, "stone": 2, "sand": 2}, "time": 6.0},
	
	# === КРЫШИ (4 типа) ===
	"roof_wood": {"name": "Деревянная крыша", "type": 5, "material": 0, "health": 100, "defense": 5, "cost": {"wood": 4, "nails": 2, "cloth": 1}, "time": 3.0},
	"roof_metal": {"name": "Металлическая крыша", "type": 5, "material": 1, "health": 180, "defense": 12, "cost": {"metal": 4, "nails": 2}, "time": 5.0},
	"roof_tile": {"name": "Черепичная крыша", "type": 5, "material": 3, "health": 250, "defense": 15, "cost": {"stone": 6, "cement": 1, "wood": 2}, "time": 7.0},
	"roof_glass": {"name": "Стеклянная крыша", "type": 5, "material": 1, "health": 80, "defense": 3, "cost": {"glass": 4, "metal": 2}, "time": 4.0},
	
	# === ЛЕСТНИЦЫ (3 типа) ===
	"stairs_wood": {"name": "Деревянная лестница", "type": 6, "material": 0, "health": 80, "defense": 3, "cost": {"wood": 4, "nails": 2}, "time": 3.0},
	"stairs_metal": {"name": "Металлическая лестница", "type": 6, "material": 1, "health": 150, "defense": 8, "cost": {"metal": 4, "nails": 2}, "time": 5.0},
	"stairs_spiral": {"name": "Винтовая лестница", "type": 6, "material": 1, "health": 200, "defense": 12, "cost": {"metal": 6, "nails": 3}, "time": 7.0},
	
	# === БАШНИ (3 типа) ===
	"tower_wood": {"name": "Деревянная башня", "type": 7, "material": 0, "health": 150, "defense": 8, "cost": {"wood": 8, "nails": 4}, "time": 6.0},
	"tower_metal": {"name": "Металлическая башня", "type": 7, "material": 1, "health": 250, "defense": 15, "cost": {"metal": 6, "nails": 4}, "time": 8.0},
	"tower_reinforced": {"name": "Укреплённая башня", "type": 7, "material": 4, "health": 500, "defense": 35, "cost": {"metal": 8, "brick": 4, "cement": 2}, "time": 12.0},
	
	# === ЛОВУШКИ (5 типов) ===
	"trap_spikes": {"name": "Шипы", "type": 8, "material": 1, "health": 50, "defense": 0, "cost": {"metal": 3, "wood": 1}, "time": 2.0},
	"trap_pit": {"name": "Яма", "type": 8, "material": 0, "health": 100, "defense": 0, "cost": {"wood": 2}, "time": 3.0},
	"trap_wire": {"name": "Проволока", "type": 8, "material": 1, "health": 30, "defense": 0, "cost": {"wire": 2, "metal": 1}, "time": 1.0},
	"trap_alarm": {"name": "Сигнализация", "type": 8, "material": 1, "health": 40, "defense": 0, "cost": {"wire": 2, "battery": 1, "electronics": 1}, "time": 3.0},
	"trap_explosive": {"name": "Взрывная ловушка", "type": 8, "material": 1, "health": 60, "defense": 0, "cost": {"metal": 2, "gunpowder": 2, "wire": 1}, "time": 4.0},
	
	# === ДЕКОРАЦИИ (8 типов) ===
	"decor_table": {"name": "Стол", "type": 9, "material": 0, "health": 40, "defense": 0, "cost": {"wood": 3, "nails": 2}, "time": 2.0},
	"decor_chair": {"name": "Стул", "type": 9, "material": 0, "health": 30, "defense": 0, "cost": {"wood": 2, "nails": 1}, "time": 1.0},
	"decor_bed": {"name": "Кровать", "type": 9, "material": 0, "health": 50, "defense": 0, "cost": {"wood": 4, "cloth": 2}, "time": 3.0},
	"decor_shelf": {"name": "Полка", "type": 9, "material": 0, "health": 30, "defense": 0, "cost": {"wood": 2, "nails": 1}, "time": 1.0},
	"decor_lamp": {"name": "Лампа", "type": 9, "material": 1, "health": 20, "defense": 0, "cost": {"metal": 1, "glass": 1, "wire": 1}, "time": 2.0},
	"decor_rug": {"name": "Ковёр", "type": 9, "material": 0, "health": 10, "defense": 0, "cost": {"cloth": 3}, "time": 1.0},
	"decor_painting": {"name": "Картина", "type": 9, "material": 0, "health": 10, "defense": 0, "cost": {"wood": 1, "cloth": 1}, "time": 1.0},
	"decor_plant": {"name": "Растение", "type": 9, "material": 0, "health": 10, "defense": 0, "cost": {"wood": 1}, "time": 1.0}
}

static func get_building_data(building_id: String) -> Dictionary:
	return BUILDING_PIECES.get(building_id, {})

static func get_all_building_ids() -> Array:
	return BUILDING_PIECES.keys()

static func get_buildings_by_type(type: int) -> Array:
	var result = []
	for id in BUILDING_PIECES:
		if BUILDING_PIECES[id]["type"] == type:
			result.append(id)
	return result
