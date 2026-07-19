extends Node
class_name ConstructionSystem

# ConstructionSystem - система строительства (как в CDDA)
- Копание, строительство, разборка

enum ConstructionType { DIG, BUILD, DISMANTLE, REPAIR, REINFORCE }
enum MaterialType { WOOD, METAL, BRICK, STONE, CONCRETE }

const CONSTRUCTION_RECIPES = {
	"dig_trench": {
		"name": "Окоп",
		"type": ConstructionType.DIG,
		"tool": "shovel",
		"time": 60.0,
		"result": "trench"
	},
	"dig_pit": {
		"name": "Яма",
		"type": ConstructionType.DIG,
		"tool": "shovel",
		"time": 120.0,
		"result": "pit"
	},
	"build_foundation": {
		"name": "Фундамент",
		"type": ConstructionType.BUILD,
		"materials": {"concrete": 5, "rebar": 2},
		"tool": "hammer",
		"time": 180.0,
		"result": "foundation"
	},
	"build_wall_wood": {
		"name": "Деревянная стена",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 6, "nails": 4},
		"tool": "hammer",
		"time": 120.0,
		"result": "wood_wall"
	},
	"build_wall_metal": {
		"name": "Металлическая стена",
		"type": ConstructionType.BUILD,
		"materials": {"metal_sheet": 4, "bolts": 4},
		"tool": "wrench",
		"time": 240.0,
		"result": "metal_wall"
	},
	"build_door": {
		"name": "Дверь",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 4, "nails": 2, "hinge": 2},
		"tool": "hammer",
		"time": 90.0,
		"result": "door"
	},
	"build_window": {
		"name": "Окно",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 2, "glass": 1},
		"tool": "hammer",
		"time": 60.0,
		"result": "window"
	},
	"build_floor": {
		"name": "Пол",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 4, "nails": 2},
		"tool": "hammer",
		"time": 90.0,
		"result": "floor"
	},
	"build_roof": {
		"name": "Крыша",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 6, "nails": 4, "tar_paper": 1},
		"tool": "hammer",
		"time": 150.0,
		"result": "roof"
	},
	"build_stairs": {
		"name": "Лестница",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 8, "nails": 4},
		"tool": "hammer",
		"time": 120.0,
		"result": "stairs"
	},
	"build_fence": {
		"name": "Забор",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 3, "nails": 2},
		"tool": "hammer",
		"time": 60.0,
		"result": "fence"
	},
	"build_barricade": {
		"name": "Баррикада",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 4, "nails": 3, "metal": 1},
		"tool": "hammer",
		"time": 90.0,
		"result": "barricade"
	},
	"reinforce_wall": {
		"name": "Укрепление стены",
		"type": ConstructionType.REINFORCE,
		"materials": {"metal_sheet": 2, "bolts": 4},
		"tool": "wrench",
		"time": 120.0,
		"result": "reinforced_wall"
	},
	"dismantle_furniture": {
		"name": "Разобрать мебель",
		"type": ConstructionType.DISMANTLE,
		"tool": "hammer",
		"time": 30.0,
		"result": "materials"
	},
	"dismantle_wall": {
		"name": "Разобрать стену",
		"type": ConstructionType.DISMANTLE,
		"tool": "crowbar",
		"time": 60.0,
		"result": "materials"
	},
	"dig_well": {
		"name": "Колодец",
		"type": ConstructionType.DIG,
		"tool": "shovel",
		"time": 600.0,
		"result": "well"
	},
	"dig_mine": {
		"name": "Шахта",
		"type": ConstructionType.DIG,
		"tool": "pickaxe",
		"time": 1200.0,
		"result": "mine_shaft"
	},
	"build_workbench": {
		"name": "Верстак",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 8, "nails": 4, "metal": 2},
		"tool": "hammer",
		"time": 120.0,
		"result": "workbench"
	},
	"build_forge": {
		"name": "Кузница",
		"type": ConstructionType.BUILD,
		"materials": {"stone": 10, "metal": 4},
		"tool": "hammer",
		"time": 300.0,
		"result": "forge"
	},
	"build_campfire": {
		"name": "Костёр",
		"type": ConstructionType.BUILD,
		"materials": {"wood_plank": 3, "stone": 3},
		"tool": "",
		"time": 30.0,
		"result": "campfire"
	},
	"build_rain_catcher": {
		"name": "Сборщик дождя",
		"type": ConstructionType.BUILD,
		"materials": {"plastic": 2, "cloth": 1},
		"tool": "",
		"time": 60.0,
		"result": "rain_catcher"
	},
	"build_solar_panel": {
		"name": "Солнечная панель",
		"type": ConstructionType.BUILD,
		"materials": {"glass": 4, "metal": 2, "electronics": 2},
		"tool": "wrench",
		"time": 180.0,
		"result": "solar_panel"
	},
	"build_generator": {
		"name": "Генератор",
		"type": ConstructionType.BUILD,
		"materials": {"metal": 6, "motor": 1, "wire": 4},
		"tool": "wrench",
		"time": 240.0,
		"result": "generator"
	},
	"build_battery": {
		"name": "Аккумулятор",
		"type": ConstructionType.BUILD,
		"materials": {"metal": 4, "chemicals": 2, "wire": 2},
		"tool": "wrench",
		"time": 120.0,
		"result": "battery"
	},
	"build_water_purifier": {
		"name": "Очиститель воды",
		"type": ConstructionType.BUILD,
		"materials": {"plastic": 3, "cloth": 2, "charcoal": 2},
		"tool": "",
		"time": 90.0,
		"result": "water_purifier"
	},
	"build_still": {
		"name": "Дистиллятор",
		"type": ConstructionType.BUILD,
		"materials": {"metal": 4, "pipe": 2},
		"tool": "wrench",
		"time": 150.0,
		"result": "still"
	},
	"build_smoker": {
		"name": "Коптильня",
		"type": ConstructionType.BUILD,
		"materials": {"metal": 3, "wood_plank": 2},
		"tool": "hammer",
		"time": 120.0,
		"result": "smoker"
	}
}

static func get_recipe(recipe_id: String) -> Dictionary:
	return CONSTRUCTION_RECIPES.get(recipe_id, {})

static func get_all_recipes() -> Array:
	return CONSTRUCTION_RECIPES.keys()

static func get_recipes_by_type(type: ConstructionType) -> Array:
	var result = []
	for id in CONSTRUCTION_RECIPES:
		if CONSTRUCTION_RECIPES[id]["type"] == type:
			result.append(id)
	return result

static func can_build(recipe_id: String, inventory: Inventory) -> bool:
	var recipe = get_recipe(recipe_id)
	if recipe.is_empty():
		return false
	
	if recipe.has("materials"):
		for material in recipe["materials"]:
			if inventory.get_item_count(material) < recipe["materials"][material]:
				return false
	
	if recipe.has("tool") and recipe["tool"] != "":
		if not inventory.has_item(recipe["tool"]):
			return false
	
	return true
