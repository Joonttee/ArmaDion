extends BuildingPiece
class_name Wall

# Wall - стена базы
# Блокирует движение зомби и игрока

@export var wall_type: String = "wood"  # wood, metal, brick

func _ready():
	piece_id = "wall_" + wall_type
	piece_name = "Стена (%s)" % _get_wall_name(wall_type)
	is_wall = true
	_setup_wall()

func _setup_wall():
	match wall_type:
		"wood":
			max_health = 100.0
			material_cost = {"wood": 3, "nails": 2}
			build_time = 3.0
		"metal":
			max_health = 200.0
			material_cost = {"metal": 3, "nails": 1}
			build_time = 5.0
		"brick":
			max_health = 300.0
			material_cost = {"wood": 1, "metal": 1}
			build_time = 8.0
	
	health = max_health

func _get_wall_name(type: String) -> String:
	match type:
		"wood": return "Деревянная"
		"metal": return "Металлическая"
		"brick": return "Кирпичная"
		_: return "Неизвестная"

func interact(player: Node2D):
	if not is_built:
		continue_building(0.5)
	else:
		# Стены можно чинить
		if health < max_health and player.has_method("has_item"):
			# Проверяем наличие материалов для ремонта
			repair(25.0)
