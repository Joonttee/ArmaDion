extends Node
class_name CraftingSystem

# CraftingSystem - система крафта
# Позволяет создавать предметы из материалов

signal recipe_crafted(result_item)
signal crafting_failed(reason)

@export var recipes: Array[CraftRecipe] = []
var item_database: ItemDatabase

func _ready():
	item_database = ItemDatabase.new()
	_load_default_recipes()
	print("[CraftingSystem] Initialized with %d recipes" % recipes.size())

func _load_default_recipes():
	# Примитивный топор
	var primitive_axe = CraftRecipe.new()
	primitive_axe.recipe_id = "primitive_axe"
	primitive_axe.result_item_id = "axe"
	primitive_axe.required_items = {"wood": 2, "metal": 1}
	primitive_axe.craft_time = 3.0
	primitive_axe.category = "weapons"
	recipes.append(primitive_axe)
	
	# Бинт из ткани
	var cloth_bandage = CraftRecipe.new()
	cloth_bandage.recipe_id = "cloth_bandage"
	cloth_bandage.result_item_id = "bandage"
	cloth_bandage.required_items = {"cloth": 2}
	cloth_bandage.craft_time = 1.0
	cloth_bandage.category = "medicine"
	recipes.append(cloth_bandage)
	
	# Укреплённая дверь
	var reinforced_door = CraftRecipe.new()
	reinforced_door.recipe_id = "reinforced_door"
	reinforced_door.result_item_id = "wood"
	reinforced_door.required_items = {"wood": 5, "nails": 3, "metal": 2}
	reinforced_door.craft_time = 5.0
	reinforced_door.category = "building"
	recipes.append(reinforced_door)
	
	# Самодельное оружие
	var makeshift_bat = CraftRecipe.new()
	makeshift_bat.recipe_id = "makeshift_bat"
	makeshift_bat.result_item_id = "bat"
	makeshift_bat.required_items = {"wood": 2, "nails": 2}
	makeshift_bat.craft_time = 2.0
	makeshift_bat.category = "weapons"
	recipes.append(makeshift_bat)
	
	# Фактор (для освещения)
	var torch = CraftRecipe.new()
	torch.recipe_id = "torch"
	torch.result_item_id = "cloth"
	torch.required_items = {"wood": 1, "cloth": 1}
	torch.craft_time = 1.5
	torch.category = "tools"
	recipes.append(torch)

func can_craft(recipe: CraftRecipe, inventory: Inventory) -> bool:
	for item_id in recipe.required_items:
		var required_count = recipe.required_items[item_id]
		if inventory.get_item_count(item_id) < required_count:
			return false
	return true

func craft(recipe: CraftRecipe, inventory: Inventory) -> Item:
	if not can_craft(recipe, inventory):
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
		print("[CraftingSystem] Crafted: %s" % result.item_name)
	
	return result

func get_available_recipes(inventory: Inventory) -> Array[CraftRecipe]:
	var available: Array[CraftRecipe] = []
	for recipe in recipes:
		if can_craft(recipe, inventory):
			available.append(recipe)
	return available

func get_recipes_by_category(category: String) -> Array[CraftRecipe]:
	var filtered: Array[CraftRecipe] = []
	for recipe in recipes:
		if recipe.category == category:
			filtered.append(recipe)
	return filtered
