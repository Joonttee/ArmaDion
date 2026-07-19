extends Node2D
class_name Furniture

# Furniture - мебель и предметы интерьера
# Поддержка хранения, использования и взаимодействия

signal furniture_used(furniture)
signal storage_opened(furniture)
signal furniture_destroyed(furniture)

enum FurnitureType { STORAGE, SLEEP, CRAFT, DECORATION, CONTAINER, LIGHT, HEATING, DEFENSE }
enum FurnitureState { NORMAL, ACTIVE, BROKEN, LOCKED }

@export var furniture_id: String = ""
@export var furniture_name: String = "Мебель"
@export var furniture_type: FurnitureType = FurnitureType.DECORATION
@export var description: String = ""

# Характеристики
var max_health: float = 50.0
var health: float = 50.0
var state: FurnitureState = FurnitureState.NORMAL
var is_locked: bool = false

# Хранилище (для контейнеров)
var storage_items: Array[Item] = []
var storage_size: int = 10

# Эффекты
var comfort_bonus: float = 0.0
var warmth_bonus: float = 0.0
var light_radius: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea

func _ready():
	add_to_group("furniture")
	health = max_health
	print("[Furniture] %s created" % furniture_name)

func interact(player: Node2D):
	match furniture_type:
		FurnitureType.STORAGE:
			_open_storage(player)
		FurnitureType.SLEEP:
			_sleep(player)
		FurnitureType.CRAFT:
			_use_craft_station(player)
		FurnitureType.CONTAINER:
			_open_container(player)
		FurnitureType.LIGHT:
			_toggle_light()
		FurnitureType.HEATING:
			_toggle_heating()
		FurnitureType.DEFENSE:
			_use_defense(player)
		_:
			_default_interaction(player)
	
	emit_signal("furniture_used", self)

func _open_storage(player: Node2D):
	if is_locked:
		print("[Furniture] Storage is locked!")
		return
	
	emit_signal("storage_opened", self)
	EventManager.emit_signal("open_furniture_storage", self)
	print("[Furniture] Storage opened: %s" % furniture_name)

func _sleep(player: Node2D):
	if player.has_method("rest"):
		player.rest(50.0)
	print("[Player] Slept on %s" % furniture_name)

func _use_craft_station(player: Node2D):
	EventManager.emit_signal("open_crafting_menu", self)
	print("[Furniture] Craft station used: %s" % furniture_name)

func _open_container(player: Node2D):
	if is_locked:
		print("[Furniture] Container is locked!")
		return
	
	emit_signal("storage_opened", self)
	EventManager.emit_signal("open_furniture_storage", self)

func _toggle_light():
	# Включить/выключить свет
	print("[Furniture] Light toggled: %s" % furniture_name)

func _toggle_heating():
	# Включить/выключить обогрев
	print("[Furniture] Heating toggled: %s" % furniture_name)

func _use_defense(player: Node2D):
	# Использовать оборонительную мебель
	print("[Furniture] Defense used: %s" % furniture_name)

func _default_interaction(player: Node2D):
	print("[Furniture] Interacted with: %s" % furniture_name)

func add_item(item: Item) -> bool:
	if storage_items.size() < storage_size:
		storage_items.append(item)
		return true
	return false

func remove_item(item: Item) -> bool:
	storage_items.erase(item)
	return true

func get_free_space() -> int:
	return storage_size - storage_items.size()

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		_destroy()

func repair(amount: float):
	health = min(max_health, health + amount)

func _destroy():
	emit_signal("furniture_destroyed(self))
	queue.free()

func lock():
	is_locked = true

func unlock():
	is_locked = false

func serialize() -> Dictionary:
	return {
		"furniture_id": furniture_id,
		"position": {"x": position.x, "y": position.y},
		"health": health,
		"state": state,
		"is_locked": is_locked,
		"storage_items": storage_items.map(func(item): return item.item_id)
	}
