extends Node2D
class_name Workstation

# Workstation - верстак для крафта
# Типы: верстак, печь, верстак для оружия, лаборатория

enum Type { WORKBENCH, FURNACE, WEAPON_BENCH, LABORATORY, SEWING_TABLE, ELECTRONICS_BENCH }

@export var workstation_type: Type = Type.WORKBENCH
@export var workstation_name: String = "Верстак"
@export var description: String = ""

# Рецепты доступные на этом верстаке
var available_recipes: Array[String] = []
var is_active: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea

signal workstation_used(workstation)

func _ready():
	add_to_group("workstations")
	_setup_workstation()
	print("[Workstation] %s initialized" % workstation_name)

func _setup_workstation():
	match workstation_type:
		Type.WORKBENCH:
			workstation_name = "Верстак"
			description = "Базовый верстак для простых предметов."
			available_recipes = ["craft_wall_wood", "craft_fence", "craft_door", "craft_storage", "makeshift_bat", "knife", "hammer", "torch"]
		Type.FURNACE:
			workstation_name = "Печь"
			description = "Печь для выплавки металла и обжига."
			available_recipes = ["craft_metal", "craft_glass", "craft_bricks", "cook_metal", "smelt_ore"]
		Type.WEAPON_BENCH:
			workstation_name = "Оружейный верстак"
			description = "Верстак для создания и улучшения оружия."
			available_recipes = ["axe", "machete", "crossbow", "arrow", "knife_metal", "sword", "spear"]
		Type.LABORATORY:
			workstation_name = "Лаборатория"
			description = "Лаборатория для создания лекарств и химикатов."
			available_recipes = ["first_aid_kit", "pills", "antidote", "chemicals", "medicine_advanced", "vaccine"]
		Type.SEWING_TABLE:
			workstation_name = "Швейный стол"
			description = "Стол для создания одежды и брони."
			available_recipes = ["cloth_armor", "leather_armor", "backpack", "bandage", "rope"]
		Type.ELECTRONICS_BENCH:
			workstation_name = "Электронный верстак"
			description = "Верстак для создания электроники."
			available_recipes = ["electronics", "battery", "radio", "detector", "night_vision"]

func interact(player: Node2D):
	if is_active:
		emit_signal("workstation_used", self)
		EventManager.emit_signal("open_workstation", self)
		print("[Workstation] %s used by player" % workstation_name)

func can_craft(recipe_id: String) -> bool:
	return available_recipes.has(recipe_id)

func get_recipes() -> Array[String]:
	return available_recipes

func serialize() -> Dictionary:
	return {
		"type": workstation_type,
		"position": {"x": position.x, "y": position.y},
		"active": is_active
	}
