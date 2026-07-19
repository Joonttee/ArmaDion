extends Node2D
class_name WorldGenerator

# WorldGenerator - генерация мира с городами, сёлами и биомами

signal world_generated
signal city_generated(city)
signal village_generated(village)

enum Biome { FOREST, PLAINS, DESERT, SNOW, SWAMP }
enum StructureType { HOUSE, APARTMENT, HOSPITAL, POLICE, FIRE_STATION, SCHOOL, SHOP, WAREHOUSE, FACTORY }

# Настройки мира
@export var world_size: Vector2 = Vector2(4000, 4000)
@export var city_count: int = 3
@export var village_count: int = 8
@export var road_density: float = 0.5

# Структуры
var cities: Array[Dictionary] = []
var villages: Array[Dictionary] = []
var roads: Array[Dictionary] = []
var points_of_interest: Array[Dictionary] = []

# Генератор шума
var noise: FastNoiseLite = null

func _ready():
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	print("[WorldGenerator] Initialized")

func generate_world():
	print("[WorldGenerator] Generating world...")
	
	_clear_world()
	_generate_terrain()
	_generate_cities()
	_generate_villages()
	_generate_roads()
	_generate_points_of_interest()
	
	emit_signal("world_generated")
	print("[WorldGenerator] World generated successfully")

func _clear_world():
	cities.clear()
	villages.clear()
	roads.clear()
	points_of_interest.clear()
	
	for child in get_children():
		if child.name != "Player":
			child.queue_free()

func _generate_terrain():
	print("[WorldGenerator] Generating terrain...")
	
	for x in range(0, int(world_size.x), 64):
		for y in range(0, int(world_size.y), 64):
			var biome = _get_biome_at(x, y)
			_spawn_terrain_tile(x, y, biome)

func _get_biome_at(x: float, y: float) -> Biome:
	var noise_val = noise.get_noise_2d(x * 0.001, y * 0.001)
	
	if noise_val < -0.3:
		return Biome.SNOW
	elif noise_val < -0.1:
		return Biome.FOREST
	elif noise_val < 0.1:
		return Biome.PLAINS
	elif noise_val < 0.3:
		return Biome.SWAMP
	else:
		return Biome.DESERT

func _spawn_terrain_tile(x: float, y: float, biome: Biome):
	var tile_scene = _get_terrain_tile(biome)
	if tile_scene:
		var tile = tile_scene.instantiate()
		tile.position = Vector2(x, y)
		add_child(tile)

func _get_terrain_tile(biome: Biome):
	match biome:
		Biome.FOREST: return preload("res://scenes/world/tiles/forest_tile.tscn")
		Biome.PLAINS: return preload("res://scenes/world/tiles/plains_tile.tscn")
		Biome.DESERT: return preload("res://scenes/world/tiles/desert_tile.tscn")
		Biome.SNOW: return preload("res://scenes/world/tiles/snow_tile.tscn")
		Biome.SWAMP: return preload("res://scenes/world/tiles/swamp_tile.tscn")
	return null

func _generate_cities():
	print("[WorldGenerator] Generating cities...")
	
	for i in range(city_count):
		var city = _generate_city(i)
		if city:
			cities.append(city)
			emit_signal("city_generated", city)

func _generate_city(index: int) -> Dictionary:
	var city_size = 400 + randf() * 300
	var city_pos = _find_valid_position(city_size)
	
	if city_pos == Vector2.ZERO:
		return {}
	
	var city = {
		"name": _generate_city_name(index),
		"position": city_pos,
		"size": city_size,
		"buildings": [],
		"population": int(50 + randf() * 200),
		"has_hospital": randf() > 0.3,
		"has_police": randf() > 0.4,
		"has_fire_station": randf() > 0.5
	}
	
	_generate_city_buildings(city)
	return city

func _generate_city_buildings(city: Dictionary):
	var building_count = int(city["size"] / 50)
	
	for i in range(building_count):
		var building_type = _get_random_building_type()
		var building_pos = city["position"] + Vector2(
			(randf() - 0.5) * city["size"],
			(randf() - 0.5) * city["size"]
		)
		
		var building = {
			"type": building_type,
			"position": building_pos,
			"loot_quality": _get_loot_quality(building_type)
		}
		
		city["buildings"].append(building)

func _generate_villages():
	print("[WorldGenerator] Generating villages...")
	
	for i in range(village_count):
		var village = _generate_village(i)
		if village:
			villages.append(village)
			emit_signal("village_generated", village)

func _generate_village(index: int) -> Dictionary:
	var village_size = 150 + randf() * 100
	var village_pos = _find_valid_position(village_size)
	
	if village_pos == Vector2.ZERO:
		return {}
	
	var village = {
		"name": _generate_village_name(index),
		"position": village_pos,
		"size": village_size,
		"buildings": [],
		"population": int(10 + randf() * 40)
	}
	
	var building_count = int(village_size / 30)
	for i in range(building_count):
		var building_type = _get_random_village_building()
		var building_pos = village["position"] + Vector2(
			(randf() - 0.5) * village["size"],
			(randf() - 0.5) * village["size"]
		)
		
		var building = {
			"type": building_type,
			"position": building_pos,
			"loot_quality": _get_loot_quality(building_type)
		}
		
		village["buildings"].append(building)
	
	return village

func _generate_roads():
	print("[WorldGenerator] Generating roads...")
	
	for i in range(cities.size() - 1):
		var start = cities[i]["position"]
		var end = cities[i + 1]["position"]
		_generate_road(start, end)
	
	for village in villages:
		var nearest_city = _find_nearest_city(village["position"])
		if nearest_city:
			_generate_road(village["position"], nearest_city["position"])

func _generate_road(start: Vector2, end: Vector2):
	var road = {
		"start": start,
		"end": end,
		"points": _generate_road_path(start, end)
	}
	roads.append(road)

func _generate_road_path(start: Vector2, end: Vector2) -> Array[Vector2]:
	var points: Array[Vector2] = []
	var current = start
	var target = end
	
	while current.distance_to(target) > 50:
		points.append(current)
		var direction = (target - current).normalized()
		current += direction * (40 + randf() * 20)
	
	points.append(target)
	return points

func _generate_points_of_interest():
	print("[WorldGenerator] Generating points of interest...")
	
	var poi_types = [
		{"type": "hospital", "count": 2},
		{"type": "police_station", "count": 2},
		{"type": "fire_station", "count": 2},
		{"type": "military_base", "count": 1},
		{"type": "gas_station", "count": 5},
		{"type": "supermarket", "count": 4},
		{"type": "warehouse", "count": 3}
	]
	
	for poi_type in poi_types:
		for i in range(poi_type["count"]):
			var pos = _find_valid_position(100)
			if pos != Vector2.ZERO:
				var poi = {
					"type": poi_type["type"],
					"position": pos,
					"loot_quality": "high"
				}
				points_of_interest.append(poi)

func _find_valid_position(size: float) -> Vector2:
	for attempt in range(10):
		var pos = Vector2(
			(randf() - 0.5) * (world_size.x - size),
			(randf() - 0.5) * (world_size.y - size)
		)
		
		var valid = true
		for city in cities:
			if pos.distance_to(city["position"]) < city["size"] + size:
				valid = false
				break
		
		if valid:
			return pos
	
	return Vector2.ZERO

func _find_nearest_city(pos: Vector2) -> Dictionary:
	var nearest: Dictionary = {}
	var min_dist = INF
	
	for city in cities:
		var dist = pos.distance_to(city["position"])
		if dist < min_dist:
			min_dist = dist
			nearest = city
	
	return nearest

func _get_random_building_type() -> StructureType:
	var types = StructureType.values()
	return types[randi() % types.size()]

func _get_random_village_building() -> StructureType:
	var village_types = [StructureType.HOUSE, StructureType.SHOP, StructureType.HOUSE, StructureType.HOUSE]
	return village_types[randi() % village_types.size()]

func _get_loot_quality(building_type: StructureType) -> String:
	match building_type:
		StructureType.HOSPITAL: return "medical"
		StructureType.POLICE: return "weapons"
		StructureType.SHOP: return "food"
		StructureType.WAREHOUSE: return "materials"
		_: return "basic"

func _generate_city_name(index: int) -> String:
	var names = ["Новоград", "Мирополь", "Светлоград", "Зеленск", "Речной", "Горный", "Солнечный"]
	return names[index % names.size()] if index < names.size() else "Город %d" % index

func _generate_village_name(index: int) -> String:
	var names = ["Берёзка", "Дубровка", "Ясенево", "Полянка", "Сосновка", "Еловка", "Рябиновка"]
	return names[index % names.size()] if index < names.size() else "Деревня %d" % index

func get_world_data() -> Dictionary:
	return {
		"cities": cities,
		"villages": villages,
		"roads": roads,
		"points_of_interest": points_of_interest
	}
