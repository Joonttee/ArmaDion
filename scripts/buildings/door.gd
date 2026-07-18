extends BuildingPiece
class_name Door

# Door - дверь базы
# Можно открывать/закрывать, запирать

@export var is_locked: bool = false
@export var is_open: bool = false
@export var key_id: String = ""

var closed_position: Vector2
var open_position: Vector2

func _ready():
	piece_id = "door"
	piece_name = "Дверь"
	is_door = true
	blocks_movement = true
	_setup_door()

func _setup_door():
	max_health = 80.0
	material_cost = {"wood": 2, "nails": 1, "metal": 1}
	build_time = 2.0
	health = max_health
	closed_position = position

func interact(player: Node2D):
	if not is_built:
		continue_building(0.5)
	else:
		toggle()

func toggle():
	is_open = not is_open
	blocks_movement = not is_open
	
	if is_open:
		# Открыть дверь
		collision.disabled = true
		sprite.modulate = Color(0.5, 0.5, 0.5, 0.5)
	else:
		# Закрыть дверь
		collision.disabled = false
		sprite.modulate = Color.WHITE

func lock():
	is_locked = true

func unlock():
	is_locked = false

func toggle_lock(player: Node2D) -> bool:
	if key_id != "" and player.has_method("has_item"):
		if not player.has_item(key_id):
			return false
	
	is_locked = not is_locked
	return true
