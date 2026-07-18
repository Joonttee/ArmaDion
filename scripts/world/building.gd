extends StaticBody2D
class_name Building

# Building - здание в мире
# Можно войти внутрь для лута

@export var building_type: String = "house"
@export var has_loot: bool = true

var is_entered: bool = false

func _ready():
	print("[Building] Building ready: %s" % building_type)

func interact(player: Node2D):
	print("[Building] Entering building")
	# В реальном проекте загружаем интерьер здания
	is_entered = true

func exit():
	print("[Building] Exiting building")
	is_entered = false
