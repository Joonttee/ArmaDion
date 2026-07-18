extends StaticBody2D
class_name PlantableSpot

# PlantableSpot - грядка/участок для посадки
# На нём можно выращивать растения

signal plant_grown(spot)
signal plant_harvested(spot)

@export var growth_time: float = 60.0  # Время роста в секундах
@export var needs_water: bool = true
@export var max_water_level: float = 100.0
@export var water_drain_rate: float = 2.0  # Скорость высыхания

enum CropType { EMPTY, CARROT, POTATO, TOMATO, CORN, WHEAT }

var current_crop: CropType = CropType.EMPTY
var growth_progress: float = 0.0
var water_level: float = 0.0
var is_grown: bool = false
var crop_health: float = 100.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var growth_timer: Timer = $GrowthTimer
@onready var water_bar: ProgressBar = $WaterBar

func _ready():
	add_to_group("interactables")
	_update_visual()

func _process(delta):
	if current_crop != CropType.EMPTY and not is_grown:
		# Уменьшаем уровень воды
		if needs_water:
			water_level = max(0, water_level - water_drain_rate * delta)
			water_bar.value = (water_level / max_water_level) * 100
		
		# Рост зависит от воды
		if water_level > 0:
			growth_progress += delta
			growth_progress = min(growth_progress, growth_time)
			
			if growth_progress >= growth_time:
				_on_grown()
		else:
			# Без воды растение сохнет
			crop_health -= 1.0 * delta
			if crop_health <= 0:
				_die()

func plant_seed(crop_type: CropType):
	if current_crop != CropType.EMPTY:
		print("[PlantableSpot] Already has a crop!")
		return false
	
	current_crop = crop_type
	growth_progress = 0.0
	is_grown = false
	water_level = max_water_level * 0.5  # Начальный полив
	_update_visual()
	print("[PlantableSpot] Planted: %d" % crop_type)
	return true

func water(amount: float = 50.0):
	water_level = min(max_water_level, water_level + amount)
	water_bar.value = (water_level / max_water_level) * 100
	print("[PlantableSpot] Watered, level: %.1f" % water_level)

func harvest() -> Array:
	if not is_grown:
		return []
	
	var drops = _get_harvest_drops()
	
	# Сброс грядки
	current_crop = CropType.EMPTY
	growth_progress = 0.0
	water_level = 0.0
	is_grown = false
	crop_health = 100.0
	
	_update_visual()
	emit_signal("plant_harvested", self)
	print("[PlantableSpot] Harvested!")
	return drops

func _on_grown():
	is_grown = true
	emit_signal("plant_grown", self)
	_update_visual()
	print("[PlantableSpot] Crop is fully grown!")

func _die():
	current_crop = CropType.EMPTY
	growth_progress = 0.0
	water_level = 0.0
	is_grown = false
	crop_health = 100.0
	_update_visual()
	print("[PlantableSpot] Plant died!")

func _get_harvest_drops() -> Array:
	var drops = []
	match current_crop:
		CropType.CARROT:
			drops.append({"item_id": "carrot", "count": 2})
		CropType.POTATO:
			drops.append({"item_id": "potato", "count": 3})
		CropType.TOMATO:
			drops.append({"item_id": "tomato", "count": 2})
		CropType.CORN:
			drops.append({"item_id": "corn", "count": 2})
		CropType.WHEAT:
			drops.append({"item_id": "wheat", "count": 3})
	return drops

func _update_visual():
	# В реальном проекте здесь меняются спрайты по стадиям роста
	if current_crop == CropType.EMPTY:
		sprite.modulate = Color(0.4, 0.25, 0.1)  # Земля
	elif is_grown:
		sprite.modulate = Color(0.2, 0.8, 0.2)  # Зелёный (созрело)
	else:
		# Прогресс роста
		var progress = growth_progress / growth_time
		sprite.modulate = Color(0.3 + progress * 0.4, 0.5 + progress * 0.3, 0.2)

func interact(player: Node2D):
	# Логика взаимодействия
	if current_crop == CropType.EMPTY:
		// Посадка (нужны семена в инвентаре)
		pass
	elif not is_grown and player.has_method("get_water"):
		water()
	elif is_grown:
		var drops = harvest()
		for drop in drops:
			// Добавляем в инвентарь игрока
			pass

func get_state() -> Dictionary:
	return {
		"crop_type": current_crop,
		"growth_progress": growth_progress,
		"water_level": water_level,
		"is_grown": is_grown,
		"crop_health": crop_health
	}

func set_state(data: Dictionary):
	current_crop = data.get("crop_type", CropType.EMPTY)
	growth_progress = data.get("growth_progress", 0.0)
	water_level = data.get("water_level", 0.0)
	is_grown = data.get("is_grown", false)
	crop_health = data.get("crop_health", 100.0)
	_update_visual()
