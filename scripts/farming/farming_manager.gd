extends Node

# FarmingManager - менеджер фермерства
# Управляет всеми грядками и ростом растений

signal crop_grown(spot)
signal crop_harvested(spot, drops)
signal crop_died(spot)

var plantable_spots: Array[PlantableSpot] = []
var item_database: ItemDatabase

func _ready():
	item_database = ItemDatabase.new()
	print("[FarmingManager] Initialized")

func register_spot(spot: PlantableSpot):
	plantable_spots.append(spot)
	spot.connect("plant_grown", _on_crop_grown)
	spot.connect("plant_harvested", _on_crop_harvested)
	print("[FarmingManager] Registered plantable spot")

func unregister_spot(spot: PlantableSpot):
	plantable_spots.erase(spot)

func plant_seed(spot: PlantableSpot, crop_type: int) -> bool:
	return spot.plant_seed(crop_type)

func harvest_crop(spot: PlantableSpot) -> Array:
	var drops = spot.harvest()
	emit_signal("crop_harvested", spot, drops)
	return drops

func water_crop(spot: PlantableSpot, amount: float = 50.0):
	spot.water(amount)

func get_grown_crops() -> Array[PlantableSpot]:
	var grown: Array[PlantableSpot] = []
	for spot in plantable_spots:
		if spot.is_grown:
			grown.append(spot)
	return grown

func get_needing_water() -> Array[PlantableSpot]:
	var need_water: Array[PlantableSpot] = []
	for spot in plantable_spots:
		if spot.current_crop != spot.CropType.EMPTY and not spot.is_grown:
			if spot.water_level < spot.max_water_level * 0.3:
				need_water.append(spot)
	return need_water

func _on_crop_grown(spot: PlantableSpot):
	emit_signal("crop_grown", spot)
	print("[FarmingManager] A crop has grown!")

func _on_crop_harvested(spot: PlantableSpot):
	print("[FarmingManager] Crop harvested")

func create_farm_plot(position: Vector2, size: int = 4) -> Node2D:
	# Создаёт участок фермы с несколькими грядками
	var plot = Node2D.new()
	plot.position = position
	plot.name = "FarmPlot"
	
	for i in range(size):
		var spot = preload("res://scenes/farming/plantable_spot.tscn").instantiate()
		spot.position = Vector2(i * 48, 0)
		plot.add_child(spot)
		register_spot(spot)
	
	return plot

func serialize_data() -> Array:
	var data = []
	for spot in plantable_spots:
		data.append(spot.get_state())
	return data

func deserialize_data(data: Array):
	for i in range(data.size()):
		if i < plantable_spots.size():
			plantable_spots[i].set_state(data[i])
