extends CharacterBody2D
class_name Vehicle

# Vehicle - транспортное средство
# Поддержка багажника, прицепа, ремонта и улучшений

signal vehicle_destroyed(vehicle)
signal vehicle_damaged(vehicle, amount)
signal trunk_opened(vehicle)
signal trailer_attached(trailer)

enum VehicleType { CAR, TRUCK, MOTORCYCLE, BICYCLE, ATV, HELICOPTER, BOAT, TRAILER }
enum FuelType { GASOLINE, DIESEL, ELECTRIC, NONE }

@export var vehicle_type: VehicleType = VehicleType.CAR
@export var vehicle_name: String = "Транспорт"
@export var max_health: float = 200.0
@export var health: float = 200.0
@export var max_fuel: float = 100.0
@export var fuel: float = 100.0
@export var fuel_type: FuelType = FuelType.GASOLINE
@export var fuel_consumption: float = 0.5
@export var max_speed: float = 200.0
@export var acceleration: float = 50.0
@export var braking: float = 80.0
@export var turn_speed: float = 2.0
@export var trunk_size: int = 20
@export var passenger_seats: int = 2
@export var has_trailer_hitch: bool = false

# Состояние
var is_engine_on: bool = false
var is_locked: bool = true
var current_speed: float = 0.0
var driver: Node2D = null
var passengers: Array[Node2D] = []
var attached_trailer: Vehicle = null

# Багажник
var trunk_items: Array[Item] = []

# Улучшения
var upgrades: Dictionary = {}

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var exhaust_particles: CPUParticles2D = $ExhaustParticles

func _ready():
	add_to_group("vehicles")
	_setup_vehicle()
	print("[Vehicle] %s created" % vehicle_name)

func _setup_vehicle():
	match vehicle_type:
		VehicleType.CAR:
			max_health = 200.0
			max_fuel = 100.0
			max_speed = 200.0
			trunk_size = 20
			passenger_seats = 4
		VehicleType.TRUCK:
			max_health = 400.0
			max_fuel = 200.0
			max_speed = 150.0
			trunk_size = 50
			passenger_seats = 2
			has_trailer_hitch = true
		VehicleType.MOTORCYCLE:
			max_health = 80.0
			max_fuel = 30.0
			max_speed = 250.0
			trunk_size = 5
			passenger_seats = 1
		VehicleType.BICYCLE:
			max_health = 30.0
			max_fuel = 0.0
			fuel_type = FuelType.NONE
			max_speed = 50.0
			trunk_size = 2
			passenger_seats = 1
		VehicleType.ATV:
			max_health = 150.0
			max_fuel = 50.0
			max_speed = 120.0
			trunk_size = 10
			passenger_seats = 2
		VehicleType.HELICOPTER:
			max_health = 300.0
			max_fuel = 150.0
			max_speed = 300.0
			trunk_size = 15
			passenger_seats = 4
		VehicleType.BOAT:
			max_health = 250.0
			max_fuel = 80.0
			max_speed = 100.0
			trunk_size = 30
			passenger_seats = 6
		VehicleType.TRAILER:
			max_health = 150.0
			max_fuel = 0.0
			fuel_type = FuelType.NONE
			max_speed = 0.0
			trunk_size = 100
			passenger_seats = 0

func _process(delta):
	if is_engine_on and driver:
		_consume_fuel(delta)
		_update_exhaust()

func _consume_fuel(delta):
	if fuel_type == FuelType.NONE:
		return
	
	fuel -= fuel_consumption * delta
	if fuel <= 0:
		fuel = 0
		stop_engine()

func _update_exhaust():
	if exhaust_particles:
		exhaust_particles.emitting = is_engine_on and current_speed > 0

func interact(player: Node2D):
	if is_locked:
		# Попытка взломать или использовать ключ
		return
	
	if driver:
		if driver == player:
			exit_vehicle()
		else:
			# Сесть как пассажир
			enter_as_passenger(player)
	else:
		enter_as_driver(player)

func enter_as_driver(player: Node2D):
	driver = player
	player.visible = false
	player.global_position = global_position
	print("[Vehicle] %s entered as driver" % player.name)

func enter_as_passenger(player: Node2D):
	if passengers.size() < passenger_seats:
		passengers.append(player)
		player.visible = false
		print("[Vehicle] %s entered as passenger" % player.name)

func exit_vehicle():
	if driver:
		driver.visible = true
		driver.global_position = global_position + Vector2(30, 0)
		driver = null
		stop_engine()
	
	for passenger in passengers:
		passenger.visible = true
		passenger.global_position = global_position + Vector2(30, 0)
	passengers.clear()

func start_engine():
	if fuel > 0 or fuel_type == FuelType.NONE:
		is_engine_on = true
		print("[Vehicle] Engine started")

func stop_engine():
	is_engine_on = false
	print("[Vehicle] Engine stopped")

func toggle_lock():
	is_locked = not is_locked
	print("[Vehicle] Locked: %s" % is_locked)

func open_trunk() -> Array[Item]:
	EventManager.emit_signal("toggle_vehicle_trunk", self)
	emit_signal("trunk_opened", self)
	return trunk_items

func add_to_trunk(item: Item) -> bool:
	if trunk_items.size() < trunk_size:
		trunk_items.append(item)
		return true
	return false

func remove_from_trunk(item: Item) -> bool:
	trunk_items.erase(item)
	return true

func get_trunk_free_space() -> int:
	return trunk_size - trunk_items.size()

func attach_trailer(trailer: Vehicle) -> bool:
	if has_trailer_hitch and trailer.vehicle_type == VehicleType.TRAILER:
		attached_trailer = trailer
		emit_signal("trailer_attached", trailer)
		return true
	return false

func detach_trailer():
	if attached_trailer:
		attached_trailer = null

func take_damage(amount: float):
	health -= amount
	emit_signal("vehicle_damaged", self, amount)
	
	if health <= 0:
		_destroy()

func repair(amount: float):
	health = min(max_health, health + amount)

func add_fuel(amount: float):
	fuel = min(max_fuel, fuel + amount)

func install_upgrade(upgrade_id: String) -> bool:
	if upgrades.has(upgrade_id):
		return false
	
	upgrades[upgrade_id] = true
	_apply_upgrade(upgrade_id)
	return true

func _apply_upgrade(upgrade_id: String):
	match upgrade_id:
		"armor":
			max_health += 100
			health += 100
		"engine":
			max_speed += 50
			acceleration += 20
		"trunk_ext":
			trunk_size += 20
		"fuel_tank":
			max_fuel += 50
			fuel += 50
		"turbo":
			max_speed += 100
			acceleration += 50
		"offroad":
			turn_speed += 1.0
		"nitrous":
			max_speed += 150
		"reinforced":
			max_health += 200
			health += 200
		"bulletproof":
			max_health += 150
			health += 150

func _destroy():
	emit_signal("vehicle_destroyed(self)")
	queue_free()

func get_status() -> Dictionary:
	return {
		"health": health,
		"max_health": max_health,
		"fuel": fuel,
		"max_fuel": max_fuel,
		"speed": current_speed,
		"engine_on": is_engine_on,
		"locked": is_locked,
		"trunk_items": trunk_items.size(),
		"trunk_size": trunk_size,
		"upgrades": upgrades.keys()
	}

func serialize() -> Dictionary:
	return {
		"vehicle_type": vehicle_type,
		"position": {"x": position.x, "y": position.y},
		"health": health,
		"fuel": fuel,
		"upgrades": upgrades,
		"trunk_items": trunk_items.map(func(item): return item.item_id)
	}
