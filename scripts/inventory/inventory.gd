extends Node
class_name Inventory

# Inventory - улучшенная система инвентаря
# Поддержка сумок, экипировки и ограничения по весу

signal item_added(item)
signal item_removed(item)
signal inventory_changed
signal bag_equipped(bag)
signal bag_unequipped(bag)

@export var base_max_slots: int = 20
@export var max_weight: float = 50.0

var items: Array[Item] = []
var equipped_item: Item = null
var equipped_bag: Item = null

# Бонусы от сумки
var bag_slots_bonus: int = 0
var bag_weight_reduction: float = 0.0

# Эффективный максимум слотов
var effective_max_slots: int = 20

func _ready():
	_update_effective_slots()
	print("[Inventory] Inventory initialized with %d slots" % effective_max_slots)

func _update_effective_slots():
	effective_max_slots = base_max_slots + bag_slots_bonus

func add_item(item: Item) -> bool:
	if items.size() >= effective_max_slots:
		print("[Inventory] Inventory full! (%d/%d)" % [items.size(), effective_max_slots])
		return false
	
	# Провяем вес с учётом редукции от сумки
	var current_weight = get_effective_weight()
	var weight_multiplier = 1.0 - bag_weight_reduction
	if current_weight + (item.weight * weight_multiplier) > max_weight:
		print("[Inventory] Too heavy! (%.1f/%.1f)" % [current_weight, max_weight])
		return false
	
	items.append(item)
	item.picked_up = true
	
	# Если это сумка и слот свободен - автоматически экипируем
	if item.item_id in BagItem.BAG_DEFINITIONS and not equipped_bag:
		equip_bag(item)
	
	emit_signal("item_added", item)
	emit_signal("inventory_changed")
	EventManager.emit_signal("item_picked_up", item)
	print("[Inventory] Added item: %s (%d/%d)" % [item.item_name, items.size(), effective_max_slots])
	return true

func remove_item(item: Item) -> bool:
	var index = items.find(item)
	if index == -1:
		return false
	
	items.remove_at(index)
	
	if equipped_item == item:
		equipped_item = null
	if equipped_bag == item:
		unequip_bag()
	
	emit_signal("item_removed", item)
	emit_signal("inventory_changed")
	EventManager.emit_signal("item_dropped", item)
	print("[Inventory] Removed item: %s" % item.item_name)
	return true

# Экипировать сумку
func equip_bag(bag: Item) -> bool:
	if not bag.item_id in BagItem.BAG_DEFINITIONS:
		return false
	
	# Снимаем старую сумку
	if equipped_bag:
		unequip_bag()
	
	equipped_bag = bag
	var bag_data = BagItem.BAG_DEFINITIONS[bag.item_id]
	bag_slots_bonus = bag_data["slots_bonus"]
	bag_weight_reduction = bag_data["weight_reduction"]
	_update_effective_slots()
	
	emit_signal("bag_equipped", bag)
	emit_signal("inventory_changed")
	print("[Inventory] Bag equipped: %s (+%d slots)" % [bag.bag_name, bag_slots_bonus])
	return true

# Снять сумку
func unequip_bag():
	if equipped_bag:
		var old_bag = equipped_bag
		equipped_bag = null
		bag_slots_bonus = 0
		bag_weight_reduction = 0.0
		_update_effective_slots()
		
		emit_signal("bag_unequipped", old_bag)
		emit_signal("inventory_changed")
		print("[Inventory] Bag unequipped")

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

func get_items_by_type(item_type: int) -> Array[Item]:
	var result: Array[Item] = []
	for item in items:
		if item.item_type == item_type:
			result.append(item)
	return result

func equip_item(item: Item):
	if item in items:
		equipped_item = item
		print("[Inventory] Equipped: %s" % item.item_name)

func unequip_item():
	equipped_item = null

func use_item(item: Item) -> bool:
	if not item in items:
		return false
	
	if item.has_method("use"):
		item.use()
		if item.consumable:
			remove_item(item)
		return true
	return false

# Получить общий вес
func get_total_weight() -> float:
	var total = 0.0
	for item in items:
		total += item.weight
	return total

# Получить эффективный вес (с учётом редукции от сумки)
func get_effective_weight() -> float:
	return get_total_weight() * (1.0 - bag_weight_reduction)

# Получить максимальный вес с учётом сумки
func get_max_weight() -> float:
	return max_weight

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

func get_slot_info() -> Dictionary:
	return {
		"current": items.size(),
		"max": effective_max_slots,
		"base": base_max_slots,
		"bonus": bag_slots_bonus
	}

func get_weight_info() -> Dictionary:
	return {
		"current": get_effective_weight(),
		"max": max_weight,
		"reduction": bag_weight_reduction
	}
