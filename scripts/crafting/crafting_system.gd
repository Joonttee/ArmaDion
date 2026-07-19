extends Node
class_name CraftingSystem

# CraftingSystem - расширенная система крафта (150+ рецептов)

signal recipe_crafted(result_item)
signal crafting_failed(reason)

var recipes: Array[CraftRecipe] = []
var item_database: ItemDatabase

func _ready():
	item_database = ItemDatabase.new()
	_load_all_recipes()
	print("[CraftingSystem] Initialized with %d recipes" % recipes.size())

func _load_all_recipes():
	# === МАТЕРИАЛЫ (15 рецептов) ===
	_add("wood_plank", "Доска", {"log": 1}, 2.0, "materials")
	_add("wood_stick", "Палка", {"wood_plank": 1}, 1.0, "materials")
	_add("rope", "Верёвка", {"cloth": 3}, 2.0, "materials")
	_add("nails", "Гвозди", {"metal_scrap": 1}, 1.5, "materials")
	_add("metal_sheet", "Металлист", {"metal": 2}, 3.0, "materials")
	_add("brick", "Кирпич", {"stone": 2, "sand": 1}, 2.0, "materials")
	_add("glass", "Стекло", {"sand": 3}, 3.0, "materials")
	_add("plastic", "Пластик", {"chemicals": 1}, 2.0, "materials")
	_add("leather", "Кожа", {"hide": 2}, 2.0, "materials")
	_add("wire", "Проволока", {"metal": 1}, 1.5, "materials")
	_add("pipe", "Труба", {"metal": 2}, 2.5, "materials")
	_add("screw", "Винт", {"metal": 1}, 1.0, "materials")
	_add("spring", "Пружина", {"metal": 2}, 2.0, "materials")
	_add("bolt", "Болт", {"metal": 1}, 1.0, "materials")
	_add("canister", "Канистра", {"metal": 3}, 3.0, "materials")
	
	# === ОРУЖИЕ (20 рецептов) ===
	_add("knife", "Нож", {"metal": 1, "wood_stick": 1}, 2.0, "weapons")
	_add("makeshift_bat", "Бита", {"wood_plank": 2, "nails": 2}, 2.0, "weapons")
	_add("axe", "Топор", {"wood_stick": 1, "metal": 2}, 3.0, "weapons")
	_add("machete", "Мачете", {"metal": 3, "cloth": 1}, 4.0, "weapons")
	_add("crossbow", "Арбалет", {"wood_plank": 3, "metal": 1, "rope": 2}, 5.0, "weapons")
	_add("arrow", "Стрела", {"wood_stick": 1, "metal": 1}, 1.0, "weapons")
	_add("bolt", "Болт для арбалета", {"metal": 1, "wood_stick": 1}, 1.0, "weapons")
	_add("sword", "Меч", {"metal": 5, "leather": 1}, 6.0, "weapons")
	_add("spear", "Копьё", {"wood_stick": 2, "metal": 1}, 3.0, "weapons")
	_add("sledgehammer", "Кувалда", {"metal": 4, "wood_stick": 1}, 5.0, "weapons")
	_add("pipe_wrench", "Труба-дубина", {"pipe": 2, "nails": 2}, 2.0, "weapons")
	_add("brass_knuckles", "Кастет", {"metal": 2}, 2.0, "weapons")
	_add("hatchet", "Топорик", {"metal": 1, "wood_stick": 1}, 2.0, "weapons")
	_add("crowbar", "Лом", {"metal": 3}, 3.0, "weapons")
	_add("pickaxe", "Кирка", {"metal": 2, "wood_stick": 1}, 3.0, "weapons")
	_add("shovel", "Лопата", {"metal": 1, "wood_stick": 1}, 2.0, "weapons")
	_add("sickle", "Серп", {"metal": 1, "wood_stick": 1}, 2.0, "weapons")
	_add("whip", "Кнут", {"leather": 3, "metal": 1}, 3.0, "weapons")
	_add("slingshot", "Рогатка", {"wood_stick": 1, "rope": 1}, 2.0, "weapons")
	_add("molotov", "Коктейль Молотова", {"bottle": 1, "cloth": 1, "fuel": 1}, 2.0, "weapons")
	
	# === ИНСТРУМЕНТЫ (15 рецептов) ===
	_add("hammer", "Молоток", {"wood_stick": 1, "metal": 2}, 2.0, "tools")
	_add("screwdriver", "Отвёртка", {"metal": 1, "plastic": 1}, 1.5, "tools")
	_add("wrench", "Гаечный ключ", {"metal": 2}, 2.0, "tools")
	_add("saw", "Пила", {"metal": 1, "wood_stick": 1}, 2.0, "tools")
	_add("drill", "Дрель", {"metal": 2, "motor": 1, "battery": 1}, 4.0, "tools")
	_add("lockpick", "Отмычка", {"metal": 1}, 1.0, "tools")
	_add("multitool", "Мультитул", {"metal": 3, "plastic": 1}, 3.0, "tools")
	_add("tape", "Изолента", {"plastic": 1}, 1.0, "tools")
	_add("glue", "Клей", {"chemicals": 1}, 1.5, "tools")
	_add("pliers", "Кусачки", {"metal": 2}, 2.0, "tools")
	_add("file", "Напильник", {"metal": 1}, 1.5, "tools")
	_add("chisel", "Долото", {"metal": 1}, 1.5, "tools")
	_add("tweezers", "Пинцет", {"metal": 1}, 1.0, "tools")
	_add("magnifying", "Лупа", {"glass": 1, "metal": 1}, 2.0, "tools")
	_add("measuring", "Рулетка", {"metal": 1, "plastic": 1}, 1.5, "tools")
	
	# === МЕДИЦИНА (15 рецептов) ===
	_add("bandage", "Бинт", {"cloth": 2}, 1.0, "medicine")
	_add("first_aid_kit", "Аптечка", {"bandage": 2, "pills": 1, "cloth": 1}, 3.0, "medicine")
	_add("pills", "Таблетки", {"herbs": 2, "water": 1}, 2.0, "medicine")
	_add("antiseptic", "Антисептик", {"alcohol": 1, "herbs": 1}, 2.0, "medicine")
	_add("painkillers", "Обезболивающее", {"chemicals": 1, "pills": 1}, 2.0, "medicine")
	_add("antibiotics", "Антибиотик", {"mold": 1, "chemicals": 1}, 3.0, "medicine")
	_add("vaccine", "Вакцина", {"virus_sample": 1, "chemicals": 2}, 5.0, "medicine")
	_add("adrenaline", "Адреналин", {"chemicals": 2}, 3.0, "medicine")
	_add("splint", "Шина", {"wood_stick": 2, "cloth": 1}, 2.0, "medicine")
	_add("suture", "Шовный материал", {"needle": 1, "thread": 1}, 2.0, "medicine")
	_add("bandaid", "Пластырь", {"cloth": 1, "glue": 1}, 1.0, "medicine")
	_add("thermometer", "Термометр", {"glass": 1, "metal": 1}, 2.0, "medicine")
	_add("syringe", "Шприц", {"plastic": 1, "metal": 1}, 2.0, "medicine")
	_add("oxygen", "Кислородный баллон", {"canister": 1, "chemicals": 1}, 3.0, "medicine")
	_add("defibrillator", "Дефибриллятор", {"battery": 2, "metal": 2, "capacitor": 1}, 5.0, "medicine")
	
	# === ЕДА (15 рецептов) ===
	_add("cooked_meat", "Жареное мясо", {"raw_meat": 1, "wood_stick": 1}, 3.0, "food")
	_add("stew", "Рагу", {"potato": 2, "carrot": 1, "water_bottle": 1}, 4.0, "food")
	_add("soup", "Суп", {"water_bottle": 1, "meat": 1, "herbs": 1}, 3.0, "food")
	_add("bread", "Хлеб", {"wheat": 3, "water": 1}, 4.0, "food")
	_add("jerky", "Вяленое мясо", {"raw_meat": 2, "salt": 1}, 5.0, "food")
	_add("canned_food", "Консервы", {"meat": 1, "canister": 1}, 3.0, "food")
	_add("energy_bar", "Энергетический батончик", {"nuts": 2, "honey": 1}, 2.0, "food")
	_add("coffee", "Кофе", {"coffee_beans": 1, "water": 1}, 2.0, "food")
	_add("tea", "Чай", {"herbs": 1, "water": 1}, 2.0, "food")
	_add("alcohol", "Спирт", {"fruit": 3, "water": 1}, 5.0, "food")
	_add("beer", "Пиво", {"wheat": 2, "water": 1, "yeast": 1}, 4.0, "food")
	_add("wine", "Вино", {"grapes": 3, "water": 1}, 5.0, "food")
	_add("smoothie", "Смуз", {"fruit": 2, "water": 1}, 2.0, "food")
	_add("sandwich", "Бутерброд", {"bread": 1, "meat": 1, "vegetable": 1}, 2.0, "food")
	_add("pizza", "Пицца", {"dough": 1, "cheese": 1, "meat": 1}, 4.0, "food")
	
	# === БРОНЯ (12 рецептов) ===
	_add("cloth_armor", "Тканевая броня", {"cloth": 5}, 3.0, "armor")
	_add("leather_armor", "Кожаная броня", {"leather": 5, "metal": 2}, 4.0, "armor")
	_add("metal_armor", "Металлическая броня", {"metal": 8, "leather": 2}, 6.0, "armor")
	_add("kevlar_vest", "Кевларовый жилет", {"cloth": 3, "metal": 4, "plastic": 2}, 5.0, "armor")
	_add("helmet", "Шлем", {"metal": 3, "leather": 1}, 3.0, "armor")
	_add("shield", "Щит", {"wood_plank": 3, "metal": 2}, 4.0, "armor")
	_add("gauntlets", "Перчатки-наручи", {"metal": 3, "leather": 1}, 3.0, "armor")
	_add("greaves", "Поножи", {"metal": 3, "leather": 1}, 3.0, "armor")
	_add("boots_armor", "Бронированные ботинки", {"metal": 2, "leather": 2}, 3.0, "armor")
	_add("mask", "Защитная маска", {"metal": 2, "plastic": 1}, 2.0, "armor")
	_add("goggles", "Защитные очки", {"glass": 2, "plastic": 1}, 2.0, "armor")
	_add("suit", "Защитный костюм", {"cloth": 5, "plastic": 3, "metal": 2}, 6.0, "armor")
	
	# === ЭЛЕКТРОНИКА (10 рецептов) ===
	_add("battery", "Батарейка", {"metal": 1, "chemicals": 1}, 2.0, "electronics")
	_add("wire_coil", "Катушка проводов", {"wire": 3, "plastic": 1}, 2.0, "electronics")
	_add("circuit_board", "Печатная плата", {"copper": 1, "plastic": 1, "solder": 1}, 3.0, "electronics")
	_add("radio", "Радио", {"circuit_board": 1, "wire": 2, "battery": 1}, 4.0, "electronics")
	_add("flashlight", "Фонарик", {"battery": 1, "wire": 1, "glass": 1}, 2.0, "electronics")
	_add("detector", "Детектор", {"circuit_board": 2, "battery": 1, "wire": 2}, 5.0, "electronics")
	_add("night_vision", "Прибор ночного видения", {"circuit_board": 2, "glass": 2, "battery": 2}, 6.0, "electronics")
	_add("laser", "Лазерный целеуказатель", {"circuit_board": 1, "glass": 1, "battery": 1}, 4.0, "electronics")
	_add("remote", "Пульт", {"circuit_board": 1, "battery": 1, "plastic": 1}, 2.0, "electronics")
	_add("timer", "Таймер", {"circuit_board": 1, "battery": 1, "wire": 1}, 3.0, "electronics")
	
	# === ВЗРЫВЧАТКА (8 рецептов) ===
	_add("molotov", "Коктейль Молотова", {"bottle": 1, "cloth": 1, "alcohol": 1}, 2.0, "explosives")
	_add("pipe_bomb", "Трубная бомба", {"pipe": 1, "gunpowder": 1, "wire": 1}, 3.0, "explosives")
	_add("grenade", "Граната", {"metal": 2, "gunpowder": 2, "wire": 1}, 4.0, "explosives")
	_add("mine", "Мина", {"metal": 3, "gunpowder": 3, "spring": 1}, 5.0, "explosives")
	_add("dynamite", "Динамит", {"chemicals": 3, "cloth": 1, "wire": 1}, 4.0, "explosives")
	_add("c4", "C4", {"chemicals": 4, "plastic": 2, "wire": 1}, 5.0, "explosives")
	_add("detonator", "Детонатор", {"wire": 1, "battery": 1, "metal": 1}, 2.0, "explosives")
	_add("smoke", "Дымовая шашка", {"chemicals": 2, "metal": 1}, 3.0, "explosives")
	
	# === СТРОИТЕЛЬСТВО (15 рецептов) ===
	_add("wall_wood", "Деревянная стена", {"wood_plank": 4, "nails": 2}, 2.0, "building")
	_add("wall_metal", "Металлическая стена", {"metal_sheet": 4, "nails": 2}, 4.0, "building")
	_add("wall_brick", "Кирпичная стена", {"brick": 6, "cement": 1}, 5.0, "building")
	_add("door_wood", "Деревянная дверь", {"wood_plank": 3, "nails": 2, "metal": 1}, 2.0, "building")
	_add("door_metal", "Металлическая дверь", {"metal_sheet": 3, "nails": 2, "spring": 1}, 4.0, "building")
	_add("window", "Окошко", {"wood_plank": 2, "glass": 1}, 2.0, "building")
	_add("fence", "Забор", {"wood_plank": 2, "nails": 1}, 1.0, "building")
	_add("gate", "Ворота", {"metal_sheet": 2, "wood_plank": 2, "nails": 2}, 3.0, "building")
	_add("foundation", "Фундамент", {"wood_plank": 5, "nails": 3, "metal": 1}, 3.0, "building")
	_add("floor", "Пол", {"wood_plank": 3, "nails": 2}, 2.0, "building")
	_add("roof", "Крыша", {"wood_plank": 4, "nails": 2, "cloth": 1}, 3.0, "building")
	_add("stairs", "Лестница", {"wood_plank": 4, "nails": 2}, 3.0, "building")
	_add("barrel", "Бочка", {"wood_plank": 3, "metal": 1}, 2.0, "building")
	_add("storage_box", "Сундук", {"wood_plank": 4, "nails": 2}, 2.0, "building")
	_add("workshop", "Верстак", {"wood_plank": 6, "nails": 4, "metal": 2}, 4.0, "building")
	
	# === УЛУЧШЕНИЯ (10 рецептов) ===
	_add("reinforced_wall", "Укреплённая стена", {"wall_wood": 1, "metal": 2}, 3.0, "upgrades")
	_add("reinforced_door", "Укреплённая дверь", {"door_wood": 1, "metal": 2}, 3.0, "upgrades")
	_add("spikes", "Шипы", {"metal": 3, "wood_plank": 1}, 2.0, "upgrades")
	_add("barbed_wire", "Колючая проволока", {"wire": 4, "metal": 1}, 3.0, "upgrades")
	_add("trap", "Ловушка", {"metal": 2, "wood_plank": 1, "spring": 1}, 3.0, "upgrades")
	_add("alarm", "Сигнализация", {"wire": 2, "battery": 1, "metal": 1}, 3.0, "upgrades")
	_add("camera", "Камера", {"circuit_board": 1, "glass": 1, "wire": 2}, 4.0, "upgrades")
	_add("turret", "Турель", {"metal": 4, "motor": 1, "circuit_board": 1}, 6.0, "upgrades")
	_add("generator", "Генератор", {"metal": 4, "motor": 1, "wire": 3}, 5.0, "upgrades")
	_add("solar", "Солнечная панель", {"glass": 3, "wire": 2, "metal": 2}, 4.0, "upgrades")

func _add(id: String, name: String, materials: Dictionary, time: float, category: String):
	var recipe = CraftRecipe.new()
	recipe.recipe_id = id
	recipe.result_item_id = id
	recipe.result_name = name
	recipe.required_items = materials
	recipe.craft_time = time
	recipe.category = category
	recipes.append(recipe)

func can_craft(recipe_id: String, inventory: Inventory) -> bool:
	var recipe = get_recipe(recipe_id)
	if not recipe:
		return false
	return recipe.can_craft(inventory)

func craft(recipe_id: String, inventory: Inventory) -> Item:
	var recipe = get_recipe(recipe_id)
	if not recipe:
		emit_signal("crafting_failed", "Рецепт не найден")
		return null
	
	if not recipe.can_craft(inventory):
		emit_signal("crafting_failed", "Недостаточно материалов")
		return null
	
	# Забираем материалы
	for item_id in recipe.required_items:
		var count = recipe.required_items[item_id]
		for i in range(count):
			var item = inventory.get_item_by_id(item_id)
			if item:
				inventory.remove_item(item)
	
	# Создаём результат
	var result = item_database.get_item_copy(recipe.result_item_id)
	if result:
		inventory.add_item(result)
		emit_signal("recipe_crafted", result)
		EventManager.emit_signal("item_crafted", recipe.result_item_id)
	
	return result

func get_recipe(recipe_id: String) -> CraftRecipe:
	for recipe in recipes:
		if recipe.recipe_id == recipe_id:
			return recipe
	return null

func get_recipes_by_category(category: String) -> Array[CraftRecipe]:
	return recipes.filter(func(r): return r.category == category)

func get_available_recipes(inventory: Inventory) -> Array[CraftRecipe]:
	return recipes.filter(func(r): return r.can_craft(inventory))

func get_all_categories() -> Array[String]:
	var categories: Array[String] = []
	for recipe in recipes:
		if not categories.has(recipe.category):
			categories.append(recipe.category)
	return categories
