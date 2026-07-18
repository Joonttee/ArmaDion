extends Resource
class_name Item

# Item - ресурс предмета
# Содержит данные о предмете в игре

@export var item_id: String = ""
@export var item_name: String = "Unknown Item"
@export var description: String = ""
@export var icon: Texture2D
@export var weight: float = 1.0
@export var stackable: bool = false
@export var max_stack: int = 1
@export var consumable: bool = false
@export var item_type: ItemType = ItemType.MISC
@export var damage: float = 0.0
@export var healing: float = 0.0
@export var hunger_recovery: float = 0.0
@export var thirst_recovery: float = 0.0
@export var item_scene: PackedScene

var picked_up: bool = false
var visual_node: Node = null
var current_stack: int = 1

enum ItemType {
	WEAPON,
	FOOD,
	MEDICINE,
	MATERIAL,
	TOOL,
	AMMO,
	MISC
}

func _init():
	pass

func use():
	match item_type:
		ItemType.FOOD:
			var player = GameManager.player
			if player:
				player.feed(hunger_recovery)
				print("[Item] Ate %s, hunger +%.0f" % [item_name, hunger_recovery])
		ItemType.MEDICINE:
			var player = GameManager.player
			if player:
				player.heal(healing)
				print("[Item] Used %s, health +%.0f" % [item_name, healing])

func serialize() -> Dictionary:
	return {
		"item_id": item_id,
		"item_name": item_name,
		"current_stack": current_stack
	}

func deserialize(data: Dictionary):
	item_id = data.get("item_id", "")
	item_name = data.get("item_name", "Unknown")
	current_stack = data.get("current_stack", 1)
