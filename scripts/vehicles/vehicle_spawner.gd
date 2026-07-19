extends Node2D
class_name VehicleSpawner

# VehicleSpawner - спавнер транспорта в мире

@export var max_vehicles: int = 15
@export var spawn_radius: float = 500.0
@export var min_spawn_distance: float = 200.0
@export var spawn_interval: float = 60.0

var spawn_timer: float = 0.0
var current_vehicles: int = 0

# Шансы спавна разных типов
var spawn_weights = {
	"sedan": 15,
	"suv": 10,
	"pickup": 12,
	"hatchback": 10,
	"pickup_truck": 8,
	"box_truck": 5,
	"motorcycle": 10,
	"bicycle": 8,
	"atv": 5,
	"ambulance": 3,
	"fire_truck": 2,
	"police_car": 3,
	"bus": 2
}

func _ready():
	print("[VehicleSpawner] Initialized")

func _process(delta):
	if not GameManager.is_playing():
		return
	
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_try_spawn()

func _try_spawn():
	if current_vehicles >= max_vehicles:
		return
	
	var player = GameManager.player
	if not player:
		return
	
	# Выбираем случайный тип транспорта
	var vehicle_id = _get_random_vehicle_type()
	
	# Случайная позиция вокруг игрока
	var angle = randf() * 2 * PI
	var distance = min_spawn_distance + randf() * (spawn_radius - min_spawn_distance)
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * distance
	
	# Спавним транспорт
	var vehicle_data = VehicleDatabase.get_vehicle_data(vehicle_id)
	if vehicle_data.is_empty():
		return
	
	var vehicle = VehicleManager.spawn_vehicle(vehicle_data["type"], spawn_pos)
	if vehicle:
		vehicle.vehicle_name = vehicle_data["name"]
		vehicle.max_health = vehicle_data.get("health", 200)
		vehicle.health = vehicle.max_health
		vehicle.max_fuel = vehicle_data.get("fuel", 100)
		vehicle.fuel = vehicle.max_fuel * randf() * 0.5  # Случайное количество топлива
		vehicle.max_speed = vehicle_data.get("speed", 150)
		vehicle.trunk_size = vehicle_data.get("trunk", 20)
		vehicle.passenger_seats = vehicle_data.get("seats", 2)
		vehicle.has_trailer_hitch = vehicle_data.get("trailer", false)
		
		current_vehicles += 1
		print("[VehicleSpawner] Spawned: %s" % vehicle.vehicle_name)

func _get_random_vehicle_type() -> String:
	var total_weight = 0
	for weight in spawn_weights.values():
		total_weight += weight
	
	var random = randi() % total_weight
	var cumulative = 0
	
	for vehicle_id in spawn_weights:
		cumulative += spawn_weights[vehicle_id]
		if random < cumulative:
			return vehicle_id
	
	return "sedan"

func set_max_vehicles(max: int):
	max_vehicles = max

func set_spawn_interval(interval: float):
	spawn_interval = interval
