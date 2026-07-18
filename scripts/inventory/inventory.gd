extends Node
class_name Inventory

# Inventory - система инвентаря игрока
# Хранит предметы, управляет добавлением/удалением

signal item_added(item)
signal item_removed(item)
signal inventory_changed

@export var max_slots: int = 20

var items: Array[Item] = []
var equipped_item: Item = null

func _ready():
	print("[Inventory] Inventory initialized with %d slots" % max_slots)

func add_item(item: Item) -> bool:
	if items.size() >= max_slots:
		print("[Inventory] Inventory full!")
		return false
	
	items.append(item)
	item.picked_up = true
	
	# Добавляем визуальный элемент в UI если есть
	if item.item_scene:
		var item_instance = item.item_scene.instantiate()
		item.visual_node = item_instance
	
	emit_signal("item_added", item)
	emit_signal("inventory_changed")
	EventManager.emit_signal("item_picked_up", item)
	print("[Inventory] Added item: %s" % item.item_name)
	return true

func remove_item(item: Item) -> bool:
	var index = items.find(item)
	if index == -1:
		return false
	
	items.remove_at(index)
	
	if equipped_item == item:
		equipped_item = null
	
	emit_signal("item_removed", item)
	emit_signal("inventory_changed")
	EventManager.emit_signal("item_dropped", item)
	print("[Inventory] Removed item: %s" % item.item_name)
	return true

func has_item(item_id: String) -> bool:
	for item in items:
		if item.item_id == item_id:
			return true
	return false

func get_item_count(item_id: String) -> int:
	var count = 0
	for item in items:
		if item.item_id == item_id:
			count += 1
	return count

func get_item_by_id(item_id: String) -> Item:
	for item in items:
		if item.item_id == item_id:
			return item
	return null

func equip_item(item: Item):
	if item in items:
		equipped_item = item
		print("[Inventory] Equipped: %s" % item.item_name)

func use_item(item: Item) -> bool:
	if not item in items:
		return false
	
	if item.has_method("use"):
		item.use()
		if item.consumable:
			remove_item(item)
		return true
	return false

func serialize() -> Array:
	var data = []
	for item in items:
		data.append(item.serialize())
	return data

func deserialize(data: Array):
	items.clear()
	for item_data in data:
		var item = Item.new()
		item.deserialize(item_data)
		items.append(item)
	emit_signal("inventory_changed")

func get_weight() -> float:
	var total = 0.0
	for item in items:
		total += item.weight
	return total
