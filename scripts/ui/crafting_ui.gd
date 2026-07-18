extends Control
class_name CraftingUI

# CraftingUI - интерфейс крафта
# Показывает доступные рецепты и позволяет крафтить

signal closed

@onready var recipe_list: VBoxContainer = $Panel/RecipeList
@onready var recipe_description: Label = $Panel/RecipeDescription
@onready var craft_button: Button = $Panel/CraftButton
@onready var category_buttons: HBoxContainer = $Panel/CategoryButtons

var crafting_system: CraftingSystem
var inventory: Inventory
var selected_recipe: CraftRecipe = null
var current_category: String = "all"

var recipe_button_scene = preload("res://scenes/ui/recipe_button.tscn")

func _ready():
	visible = false
	print("[CraftingUI] Initialized")
	craft_button.connect("pressed", _on_craft_pressed)

func open(craft_system: CraftingSystem, inv: Inventory):
	crafting_system = craft_system
	inventory = inv
	visible = true
	_setup_categories()
	_refresh_recipes()
	get_tree().paused = true
	EventManager.emit_signal("toggle_crafting")

func close():
	visible = false
	get_tree().paused = false
	emit_signal("closed")
	EventManager.emit_signal("toggle_crafting")

func _setup_categories():
	var categories = ["all", "weapons", "medicine", "building", "tools"]
	for cat in categories:
		var btn = Button.new()
		btn.text = cat
		btn.connect("pressed", func(): _set_category(cat))
		category_buttons.add_child(btn)

func _set_category(category: String):
	current_category = category
	_refresh_recipes()

func _refresh_recipes():
	# Очищаем список
	for child in recipe_list.get_children():
		child.queue_free()
	
	# Получаем рецепты
	var recipes: Array[CraftRecipe] = []
	if current_category == "all":
		recipes = crafting_system.recipes
	else:
		recipes = crafting_system.get_recipes_by_category(current_category)
	
	# Добавляем кнопки рецептов
	for recipe in recipes:
		var btn = recipe_button_scene.instantiate()
		btn.setup(recipe, crafting_system.can_craft(recipe, inventory))
		btn.connect("selected", _on_recipe_selected)
		recipe_list.add_child(btn)

func _on_recipe_selected(recipe: CraftRecipe):
	selected_recipe = recipe
	var req_text = ""
	for item_id in recipe.required_items:
		req_text += "%s: %d\n" % [item_id, recipe.required_items[item_id]]
	
	recipe_description.text = "Рецепт: %s\n\nТребуется:\n%s\nВремя: %.1f сек" % [
		recipe.result_item_id, req_text, recipe.craft_time
	]
	
	craft_button.disabled = not crafting_system.can_craft(recipe, inventory)

func _on_craft_pressed():
	if selected_recipe and crafting_system:
		crafting_system.craft(selected_recipe, inventory)
		_refresh_recipes()
		craft_button.disabled = true

func _input(event):
	if event.is_action_pressed("craft") and visible:
		close()
	elif event.is_action_pressed("ui_cancel") and visible:
		close()
