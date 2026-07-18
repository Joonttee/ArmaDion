extends Resource
class_name CraftRecipe

# CraftRecipe - рецепт крафта
# Описывает требуемые материалы и результат

@export var recipe_id: String = ""
@export var result_item_id: String = ""
@export var required_items: Dictionary = {}  # item_id: count
@export var craft_time: float = 1.0
@export var category: String = "misc"
@export var description: String = ""

func get_result_name() -> String:
	return result_item_id  # В реальном проекте получать из базы данных

func get_required_items_text() -> String:
	var text = ""
	for item_id in required_items:
		text += "%s: %d\n" % [item_id, required_items[item_id]]
	return text
