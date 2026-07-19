extends Node
class_name CookingSystem

# CookingSystem - система кулинарии (как в CDDA)
# Рецепты, питательность, порча еды

enum FoodCategory { MEAT, VEGETABLE, FRUIT, GRAIN, DAIRY, PROCESSED, COOKED, DRINK }
enum Freshness { FRESH, GOOD, STALE, SPOILED, ROTTEN }

const NUTRITION_VALUES = {
	"meat": {"calories": 200, "protein": 30, "fat": 15},
	"vegetable": {"calories": 50, "vitamins": 20, "fiber": 10},
	"fruit": {"calories": 80, "vitamins": 30, "sugar": 20},
	"grain": {"calories": 150, "carbs": 40, "fiber": 5},
	"dairy": {"calories": 120, "protein": 10, "calcium": 15},
	"processed": {"calories": 300, "carbs": 50, "fat": 20},
	"cooked": {"calories": 250, "protein": 25, "fat": 10}
}

const SPOILAGE_TIMES = {
	"meat": 86400.0,      # 24 часа
	"vegetable": 172800.0, # 48 часов
	"fruit": 129600.0,     # 36 часов
	"grain": 604800.0,     # 7 дней
	"dairy": 43200.0,      # 12 часов
	"processed": 259200.0, # 3 дня
	"cooked": 172800.0     # 48 часов
}

static func get_nutrition(item_id: String) -> Dictionary:
	var category = _get_food_category(item_id)
	return NUTRITION_VALUES.get(category, {})

static func get_spoilage_time(item_id: String) -> float:
	var category = _get_food_category(item_id)
	return SPOILAGE_TIMES.get(category, 86400.0)

static func get_freshness(item_id: String, time_since_craft: float) -> Freshness:
	var spoilage_time = get_spoilage_time(item_id)
	var percent = time_since_craft / spoilage_time
	
	if percent < 0.25:
		return Freshness.FRESH
	elif percent < 0.5:
		return Freshness.GOOD
	elif percent < 0.75:
		return Freshness.STALE
	elif percent < 1.0:
		return Freshness.SPOILED
	else:
		return Freshness.ROTTEN

static func _get_food_category(item_id: String) -> String:
	if item_id in ["meat", "jerky", "cooked_meat"]:
		return "meat"
	elif item_id in ["carrot", "potato", "tomato", "corn", "vegetable"]:
		return "vegetable"
	elif item_id in ["apple", "fruit", "berries"]:
		return "fruit"
	elif item_id in ["wheat", "bread", "grain"]:
		return "grain"
	elif item_id in ["milk", "cheese", "dairy"]:
		return "dairy"
	elif item_id in ["canned_food", "processed"]:
		return "processed"
	elif item_id in ["cooked_meat", "stew", "soup", "cooked"]:
		return "cooked"
	return "processed"

static func cook_ingredient(ingredients: Array[String], cooking_method: String) -> String:
	# Простые рецепты готовки
	if "raw_meat" in ingredients and cooking_method == "fry":
		return "cooked_meat"
	elif "potato" in ingredients and "carrot" in ingredients and cooking_method == "boil":
		return "stew"
	elif "wheat" in ingredients and cooking_method == "bake":
		return "bread"
	elif "fruit" in ingredients and cooking_method == "mix":
		return "smoothie"
	
	return "cooked_food"
