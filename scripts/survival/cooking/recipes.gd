extends Node
class_name CookingRecipes

# CookingRecipes - рецепты готовки (как в CDDA)

const RECIPES = {
	# === МЯСНЫЕ БЛЮДА ===
	"steak": {"name": "Стейк", "ingredients": ["raw_meat"], "tools": ["pan", "knife"], "skill": {"cooking": 1}, "time": 300, "result": "steak", "nutrition": 400, "comfort": 20},
	"burger": {"name": "Бургер", "ingredients": ["raw_meat", "bread", "vegetable"], "tools": ["pan", "knife"], "skill": {"cooking": 2}, "time": 400, "result": "burger", "nutrition": 500, "comfort": 30},
	"hot_dog": {"name": "Хот-дог", "ingredients": ["sausage", "bread"], "tools": ["pan"], "skill": {"cooking": 1}, "time": 200, "result": "hot_dog", "nutrition": 350, "comfort": 15},
	"meatballs": {"name": "Фрикадельки", "ingredients": ["raw_meat", "bread", "egg"], "tools": ["pan", "knife"], "skill": {"cooking": 2}, "time": 500, "result": "meatballs", "nutrition": 450, "comfort": 25},
	"jerky": {"name": "Вяленое мясо", "ingredients": ["raw_meat", "salt"], "tools": ["knife"], "skill": {"cooking": 1}, "time": 3600, "result": "jerky", "nutrition": 300, "comfort": 10},
	
	# === СУПЫ И РАГУ ===
	"stew": {"name": "Рагу", "ingredients": ["raw_meat", "potato", "carrot", "water"], "tools": ["pot", "knife"], "skill": {"cooking": 2}, "time": 600, "result": "stew", "nutrition": 400, "comfort": 35},
	"soup": {"name": "Суп", "ingredients": ["vegetable", "water", "salt"], "tools": ["pot"], "skill": {"cooking": 1}, "time": 400, "result": "soup", "nutrition": 200, "comfort": 30},
	"broth": {"name": "Бульон", "ingredients": ["bones", "water", "salt"], "tools": ["pot"], "skill": {"cooking": 1}, "time": 800, "result": "broth", "nutrition": 150, "comfort": 25},
	"chili": {"name": "Чили", "ingredients": ["raw_meat", "beans", "tomato", "spices"], "tools": ["pot", "knife"], "skill": {"cooking": 3}, "time": 700, "result": "chili", "nutrition": 450, "comfort": 40},
	
	# === ВЕГЕТАРИАНСКИЕ ===
	"salad": {"name": "Салат", "ingredients": ["vegetable", "vegetable", "oil"], "tools": ["knife", "bowl"], "skill": {"cooking": 1}, "time": 150, "result": "salad", "nutrition": 150, "comfort": 15},
	"stir_fry": {"name": "Стир-фрай", "ingredients": ["vegetable", "vegetable", "oil", "soy_sauce"], "tools": ["pan", "knife"], "skill": {"cooking": 2}, "time": 300, "result": "stir_fry", "nutrition": 250, "comfort": 20},
	"roasted_veggies": {"name": "Жареные овощи", "ingredients": ["vegetable", "oil", "salt"], "tools": ["pan"], "skill": {"cooking": 1}, "time": 400, "result": "roasted_veggies", "nutrition": 200, "comfort": 20},
	
	# === ВЫПЕЧКА ===
	"bread": {"name": "Хлеб", "ingredients": ["flour", "water", "yeast", "salt"], "tools": ["bowl", "oven"], "skill": {"cooking": 2}, "time": 1200, "result": "bread", "nutrition": 300, "comfort": 25},
	"pancakes": {"name": "Блины", "ingredients": ["flour", "egg", "milk", "oil"], "tools": ["pan", "bowl"], "skill": {"cooking": 2}, "time": 300, "result": "pancakes", "nutrition": 350, "comfort": 30},
	"pizza": {"name": "Пицца", "ingredients": ["dough", "tomato", "cheese", "meat"], "tools": ["oven", "knife"], "skill": {"cooking": 3}, "time": 900, "result": "pizza", "nutrition": 600, "comfort": 45},
	"cookies": {"name": "Печенье", "ingredients": ["flour", "sugar", "egg", "oil"], "tools": ["bowl", "oven"], "skill": {"cooking": 2}, "time": 600, "result": "cookies", "nutrition": 250, "comfort": 35},
	
	# === НАПИТКИ ===
	"coffee": {"name": "Кофе", "ingredients": ["coffee_beans", "water"], "tools": ["pot"], "skill": {"cooking": 1}, "time": 200, "result": "coffee", "nutrition": 50, "comfort": 20},
	"tea": {"name": "Чай", "ingredients": ["tea_leaves", "water"], "tools": ["pot"], "skill": {"cooking": 1}, "time": 150, "result": "tea", "nutrition": 30, "comfort": 15},
	"smoothie": {"name": "Смузи", "ingredients": ["fruit", "fruit", "water"], "tools": ["blender"], "skill": {"cooking": 1}, "time": 100, "result": "smoothie", "nutrition": 200, "comfort": 20},
	"juice": {"name": "Сок", "ingredients": ["fruit", "water"], "tools": ["bowl"], "skill": {"cooking": 1}, "time": 150, "result": "juice", "nutrition": 150, "comfort": 15},
	
	# === КОНСЕРВЫ ===
	"canned_meat": {"name": "Мясные консервы", "ingredients": ["raw_meat", "salt", "can"], "tools": ["pot", "can_opener"], "skill": {"cooking": 2}, "time": 1800, "result": "canned_meat", "nutrition": 400, "comfort": 10},
	"pickles": {"name": "Маринованные овощи", "ingredients": ["vegetable", "vinegar", "salt", "jar"], "tools": ["pot"], "skill": {"cooking": 2}, "time": 3600, "result": "pickles", "nutrition": 100, "comfort": 15},
	"jam": {"name": "Джем", "ingredients": ["fruit", "sugar"], "tools": ["pot"], "skill": {"cooking": 2}, "time": 1200, "result": "jam", "nutrition": 200, "comfort": 25}
}

static func get_recipe(recipe_id: String) -> Dictionary:
	return RECIPES.get(recipe_id, {})

static func get_all_recipes() -> Array:
	return RECIPES.keys()

static func get_recipes_by_skill_level(skill_level: int) -> Array:
	var result = []
	for id in RECIPES:
		var recipe = RECIPES[id]
		var max_skill = 0
		for skill in recipe["skill"]:
			max_skill = max(max_skill, recipe["skill"][skill])
		if max_skill <= skill_level:
			result.append(id)
	return result

static func can_cook(recipe_id: String, inventory: Inventory) -> bool:
	var recipe = get_recipe(recipe_id)
	if recipe.is_empty():
		return false
	for ingredient in recipe["ingredients"]:
		if not inventory.has_item(ingredient):
			return false
	for tool in recipe["tools"]:
		if not inventory.has_item(tool):
			return false
	return true
