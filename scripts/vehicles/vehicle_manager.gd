extends Node
class_name VehicleManager

# VehicleManager - менеджер транспорта

signal vehicle_spawned(vehicle)
signal vehicle_destroyed(vehicle)

var vehicles: Array[Vehicle] = []
var vehicle_scene: PackedScene = preload("res://scenes/vehicles/vehicle.tscn")
var trailer_scene: PackedScene = preload("res://scenes/vehicles/trailer.tscn")

# Кэш для быстрого поиска
var _vehicles_by_id: Dictionary = {}

func _ready():
	print("[VehicleManager] Initialized")

func spawn_vehicle(vehicle_type: Vehicle.Type, position: Vector2) -> Vehicle:
	var vehicle = vehicle_scene.instantiate()
	vehicle.vehicle_type = vehicle_type
	vehicle.global_position = position
	
	get_tree().current_scene.add_child(vehicle)
	vehicles.append(vehicle)
	
	_vehicles_by_id[vehicle.vehicle_name + "_" + str(randi())] = vehicle
	
	vehicle.connect("vehicle_destroyed", func(v): _on_vehicle_destroyed(v))
	
	emit_signal("vehicle_spawned", vehicle)
	return vehicle

func spawn_trailer(position: Vector2) -> Trailer:
	var trailer = trailer_scene.instantiate()
	trailer.global_position = position
	
	get_tree().current_scene.add_child(trailer)
	vehicles.append(trailer)
	
	emit_signal("vehicle_spawned", trailer)
	return trailer

func _on_vehicle_destroyed(vehicle: Vehicle):
	vehicles.erase(vehicle)
	emit_signal("vehicle_destroyed", vehicle)

func get_nearest_vehicle(position: Vector2, max_distance: float = 100.0) -> Vehicle:
	var nearest: Vehicle = null
	var min_dist = max_distance
	
	for vehicle in vehicles:
		var dist = position.distance_to(vehicle.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = vehicle
	
	return nearest

func get_vehicles_in_range(position: Vector2, range: float) -> Array[Vehicle]:
	return vehicles.filter(func(v): return position.distance_to(v.global_position) <= range)

func remove_vehicle(vehicle: Vehicle):
	vehicles.erase(vehicle)
	vehicle.queue_free()

func clear_all():
	for vehicle in vehicles:
		vehicle.queue_free()
	vehicles.clear()
	_vehicles_by_id.clear()

func serialize() -> Array:
	return vehicles.map(func(v): return v.serialize())
