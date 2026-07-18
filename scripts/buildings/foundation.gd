extends BuildingPiece
class_name Foundation

# Foundation - фундамент базы
# Основа для строительства стен и других конструкций

@export var foundation_size: Vector2 = Vector2(64, 64)

func _ready():
	piece_id = "foundation"
	piece_name = "Фундамент"
	is_foundation = true
	_setup_foundation()

func _setup_foundation():
	max_health = 150.0
	material_cost = {"wood": 4, "nails": 2}
	build_time = 4.0
	health = max_health

func interact(player: Node2D):
	if not is_built:
		continue_building(0.5)
	else:
		# Фундамент нельзя чинить, только разрушить
		pass

func can_build_on() -> bool:
	return is_built
