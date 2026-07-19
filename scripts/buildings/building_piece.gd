extends StaticBody2D
class_name BuildingPiece

# BuildingPiece - улучшенный строительный элемент
# Поддерживает здоровье, апгрейды и разрушение

signal piece_destroyed(piece)
signal piece_damaged(piece, amount)
signal piece_upgraded(piece, new_level)

enum PieceType { WALL, DOOR, WINDOW, FENCE, FLOOR, ROOF, STAIRS, TOWER, TRAP, DECORATION }
enum MaterialType { WOOD, METAL, BRICK, STONE, REINFORCED }

@export var piece_id: String = ""
@export var piece_name: String = "Building Piece"
@export var piece_type: PieceType = PieceType.WALL
@export var material_type: MaterialType = MaterialType.WOOD

# Характеристики
var max_health: float = 100.0
var health: float = 100.0
var defense: float = 0.0
var level: int = 1
var max_level: int = 3

# Стоимость строительства
var build_cost: Dictionary = {}
var upgrade_cost: Dictionary = {}

# Состояние
var is_built: bool = false
var build_progress: float = 0.0
var build_time: float = 2.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	_setup_piece()
	print("[BuildingPiece] %s created" % piece_name)

func _setup_piece():
	health = max_health
	_update_health_bar()

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

func upgrade() -> bool:
	if level >= max_level:
		return false
	
	level += 1
	max_health *= 1.5
	health = max_health
	defense *= 1.3
	emit_signal("piece_upgraded", self, level)
	return true

func _destroy():
	emit_signal("piece_destroyed(self))
	queue_free()

func _update_health_bar():
	if health_bar:
		health_bar.value = (health / max_health) * 100
		health_bar.visible = health < max_health

func interact(player: Node2D):
	if not is_built:
		continue_building(0.5)
	else:
		# Взаимодействие с построенным объектом
		pass

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
	print("[BuildingPiece] %s built" % piece_name)

func serialize() -> Dictionary:
	return {
		"piece_id": piece_id,
		"position": {"x": position.x, "y": position.y},
		"health": health,
		"max_health": max_health,
		"level": level,
		"is_built": is_built
	}
