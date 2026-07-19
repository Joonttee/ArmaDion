extends Resource
class_name Equipment

# Equipment - экипировка персонажа
# Хранит данные об экипированных предметах

enum Slot { HEAD, BODY, LEGS, FEET, HANDS, ACCESSORY, WEAPON }

@export var equipment_id: String = ""
@export var equipment_name: String = ""
@export var description: String = ""
@export var slot: Slot = Slot.BODY
@export var defense: float = 0.0
@export var warmth: float = 0.0
@export var weight: float = 0.0
@export var sprite_path: String = ""
@export var icon: Texture2D

func _init():
	pass
