extends Resource
class_name SeedItem

# SeedItem - семена для посадки
# Ресурс, содержащий информацию о семенах

@export var seed_id: String = ""
@export var seed_name: String = "Семена"
@export var crop_type: int = 0  # PlantableSpot.CropType
@export var growth_time: float = 60.0
@export var water_needs: float = 2.0
@export var harvest_yield: int = 2
@export var icon: Texture2D
@export var description: String = ""

func get_crop_name() -> String:
	match crop_type:
		1: return "Морковь"
		2: return "Картофель"
		3: return "Помидор"
		4: return "Кукуруза"
		5: return "Пшеница"
		_: return "Неизвестно"
