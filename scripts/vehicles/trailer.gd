extends Vehicle
class_name Trailer

# Trailer - прицеп для транспорта

@export var cargo_size: int = 100
@export var cargo_items: Array[Item] = []
@export var is_attached: bool = false

func _ready():
	vehicle_type = VehicleType.TRAILER
	trunk_size = cargo_size
	cargo_items = []
	print("[Trailer] Created")

func attach_to_vehicle(vehicle: Vehicle) -> bool:
	if vehicle.attach_trailer(self):
		is_attached = true
		global_position = vehicle.global_position - Vector2(60, 0)
		print("[Trailer] Attached to %s" % vehicle.vehicle_name)
		return true
	return false

func detach():
	is_attached = false
	print("[Trailer] Detached")

func add_cargo(item: Item) -> bool:
	if cargo_items.size() < cargo_size:
		cargo_items.append(item)
		return true
	return false

func remove_cargo(item: Item) -> bool:
	cargo_items.erase(item)
	return true

func get_cargo_weight() -> float:
	var weight = 0.0
	for item in cargo_items:
		weight += item.weight
	return weight

func get_cargo_free_space() -> int:
	return cargo_size - cargo_items.size()
