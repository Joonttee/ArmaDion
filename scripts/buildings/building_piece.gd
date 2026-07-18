extends StaticBody2D
class_name BuildingPiece

# BuildingPiece - строительный элемент
# Базовый класс для всех строительных блоков

signal piece_destroyed(piece)
signal piece_damaged(piece, amount)

@export var piece_id: String = ""
@export var piece_name: String = "Building Piece"
@export var max_health: float = 100.0
@export var material_cost: Dictionary = {}  # item_id: count
@export var is_foundation: bool = false
@export var is_wall: bool = false
@export var is_door: bool = false
@export var is_window: bool = false
@export var blocks_movement: bool = true

var health: float
var is_built: bool = false
var build_progress: float = 0.0
var build_time: float = 2.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	health = max_health
	_update_health_bar()

func build(player: Node2D = null):
	# Начало строительства
	if is_built:
		return
	
	build_progress = 0.0
	print("[BuildingPiece] Started building: %s" % piece_name)

func continue_building(amount: float):
	if is_built:
		return
	
	build_progress += amount
	if build_progress >= build_time:
		_complete_build()

func _complete_build():
	is_built = true
	build_progress = build_time
	collision.disabled = false
	sprite.modulate = Color.WHITE
	_hide_health_bar()
	print("[BuildingPiece] Built: %s" % piece_name)

func take_damage(amount: float):
	if not is_built:
		return
	
	health -= amount
	emit_signal("piece_damaged", self, amount)
	_update_health_bar()
	
	if health <= 0:
		_destroy()

func repair(amount: float):
	health = min(max_health, health + amount)
	_update_health_bar()

func _destroy():
	emit_signal("piece_destroyed", self)
	print("[BuildingPiece] Destroyed: %s" % piece_name)
	queue_free()

func _update_health_bar():
	if health_bar:
		health_bar.value = (health / max_health) * 100
		health_bar.visible = health < max_health

func _hide_health_bar():
	if health_bar:
		health_bar.visible = false

func interact(player: Node2D):
	if not is_built:
		continue_building(0.5)
	else:
		# Взаимодействие с построенным объектом
		pass

func serialize() -> Dictionary:
	return {
		"piece_id": piece_id,
		"position": {"x": position.x, "y": position.y},
		"health": health,
		"is_built": is_built
	}

func deserialize(data: Dictionary):
	health = data.get("health", max_health)
	is_built = data.get("is_built", false)
	if is_built:
		_complete_build()
	_update_health_bar()
