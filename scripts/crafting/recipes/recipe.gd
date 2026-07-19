extends Resource
class_name CraftRecipe

# CraftRecipe - расширенный рецепт крафта (как в CDDA)
# Поддержка качества, инструментов и навыков

enum Quality { POOR, NORMAL, GOOD, FINE, MASTERCRAFT }

@export var recipe_id: String = ""
@export var result_item_id: String = ""
@export var result_name: String = ""
@export var description: String = ""

# Требуемые материалы
@export var required_items: Dictionary = {}  # item_id: count

# Требуемые инструменты
@export var required_tools: Array[String] = []

# Требования навыков
@export var required_skills: Dictionary = {}  # skill_id: level

# Время крафта
@export var craft_time: float = 1.0

# Категория
@export var category: String = "misc"

# Качество результата
var quality: Quality = Quality.NORMAL

# Бонусы от навыков
func get_quality_bonus(skill_level: int) -> float:
	return skill_level * 0.05

func can_craft(inventory: Inventory) -> bool:
	# Проверяем материалы
	for item_id in required_items:
		if inventory.get_item_count(item_id) < required_items[item_id]:
			return false
	
	# Проверяем инструменты
	for tool_id in required_tools:
		if not inventory.has_item(tool_id):
			return false
	
	return true

func calculate_quality(crafter_skills: Dictionary) -> Quality:
	var total_bonus = 0.0
	
	for skill_id in required_skills:
		if crafter_skills.has(skill_id):
			var skill_level = crafter_skills[skill_id]
			var required_level = required_skills[skill_id]
			if skill_level >= required_level:
				total_bonus += (skill_level - required_level) * 0.1
	
	if total_bonus >= 0.5:
		quality = Quality.MASTERCRAFT
	elif total_bonus >= 0.3:
		quality = Quality.FINE
	elif total_bonus >= 0.1:
		quality = Quality.GOOD
	else:
		quality = Quality.NORMAL
	
	return quality

func get_quality_multiplier() -> float:
	match quality:
		Quality.POOR: return 0.5
		Quality.NORMAL: return 1.0
		Quality.GOOD: return 1.2
		Quality.FINE: return 1.5
		Quality.MASTERCRAFT: return 2.0
	return 1.0
