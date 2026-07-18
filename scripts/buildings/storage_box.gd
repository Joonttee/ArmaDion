extends BuildingPiece
class_name StorageBox

# StorageBox - хранилище/сундук
# Для хранения предметов

@export var storage_size: int = 20

var items: Array = []
var is_open: bool = false

func _ready():
	piece_id = "storage"
	piece_name = "Хранилище"
	blocks_movement = true
	_setup_storage()

func _setup_storage():
	max_health = 60.0
	material_cost = {"wood": 3, "nails": 1}
	build_time = 2.0
	health = max_health

func interact(player: Node2D):
	if not is_built:
		continue_building(0.5)
	else:
		# Открыть хранилище
		is_open = true
		EventManager.emit_signal("open_storage", self)

func add_item(item: Item) -> bool:
	if items.size() >= storage_size:
		return false
	items.append(item)
	return true

func remove_item(item: Item) -> bool:
	var index = items.find(item)
	if index == -1:
		return false
	items.remove_at(index)
	return true

func get_items() -> Array:
	return items

func serialize_storage() -> Array:
	var data = []
	for item in items:
		data.append(item.serialize())
	return data

func deserialize_storage(data: Array):
	items.clear()
	for item_data in data:
		var item = Item.new()
		item.deserialize(item_data)
		items.append(item)
