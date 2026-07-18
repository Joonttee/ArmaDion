extends Node2D
class_name WorldGenerator

# WorldGenerator - генератор мира
# Создаёт карту с зданиями, деревьями, предметами

@export var world_width: int = 2000
@export var world_height: int = 2000
@export var tile_size: int = 64

@export var tree_count: int = 50
@export var building_count: int = 10
@export var item_spawn_count: int = 30

var ground_layer: TileMapLayer
var objects_layer: TileMapLayer
var buildings_layer: TileMapLayer

func _ready():
	print("[WorldGenerator] Generating world...")
	_generate_ground()
	_generate_trees()
	_generate_buildings()
	_generate_items()
	print("[WorldGenerator] World generation complete!")

func _generate_ground():
	# Создаём базовый слой земли
	for x in range(-world_width / tile_size, world_width / tile_size):
		for y in range(-world_height / tile_size, world_height / tile_size):
			# Простая генерация ландшафта
			var noise = _get_noise(x, y)
			if noise > 0.3:
				# Трава
				pass
			elif noise > 0:
				# Земля
				pass
			else:
				# Вода
				pass

func _generate_trees():
	var tree_scene = preload("res://scenes/world/tree.tscn")
	for i in range(tree_count):
		var x = randf_range(-world_width / 2, world_width / 2)
		var y = randf_range(-world_height / 2, world_height / 2)
		var tree = tree_scene.instantiate()
		tree.position = Vector2(x, y)
		add_child(tree)

func _generate_buildings():
	# Генерация зданий
	var building_scene = preload("res://scenes/world/building.tscn")
	for i in range(building_count):
		var x = randf_range(-world_width / 2 + 200, world_width / 2 - 200)
		var y = randf_range(-world_height / 2 + 200, world_height / 2 - 200)
		var building = building_scene.instantiate()
		building.position = Vector2(x, y)
		add_child(building)

func _generate_items():
	# Расстановка предметов на карте
	var item_ids = ["canned_food", "water_bottle", "bandage", "wood", "metal", "cloth", "axe", "bat"]
	for i in range(item_spawn_count):
		var x = randf_range(-world_width / 2 + 100, world_width / 2 - 100)
		var y = randf_range(-world_height / 2 + 100, world_height / 2 - 100)
		var item_id = item_ids[randi() % item_ids.size()]
		_spawn_item(item_id, Vector2(x, y))

func _spawn_item(item_id: String, position: Vector2):
	# Создание предмета на карте
	var item_pickup = Area2D.new()
	item_pickup.position = position
	item_pickup.add_to_group("interactables")
	
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 20.0
	collision.shape = shape
	item_pickup.add_child(collision)
	
	# Визуальное представление
	var sprite = Sprite2D.new()
	sprite.modulate = Color.YELLOW  # Заглушка
	item_pickup.add_child(sprite)
	
	add_child(item_pickup)

func _get_noise(x: float, y: float) -> float:
	# Простой шум для генерации
	return (sin(x * 0.01) + cos(y * 0.01) + 2) / 4

func get_random_spawn_position() -> Vector2:
	return Vector2(
		randf_range(-world_width / 4, world_width / 4),
		randf_range(-world_height / 4, world_height / 4)
	)
