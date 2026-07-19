extends Node
class_name EquipmentManager

# EquipmentManager - управляет экипировкой и внешним видом персонажа

signal equipment_changed(slot, item)

@onready var player_sprite: Sprite2D = $"../Sprite2D"
@onready var equipment_sprites: Node2D = $EquipmentSprites

# Экипированные предметы
var equipped_items: Dictionary = {}  # Slot: Item

# Слои спрайтов для каждого слоя экипировки
var sprite_layers: Dictionary = {}  # Slot: Sprite2D

# Базовый спрайт персонажа
var base_sprite_path: String = "res://assets/sprites/player/player_base.png"

func _ready():
	_setup_sprite_layers()
	print("[EquipmentManager] Initialized")

func _setup_sprite_layers():
	# Создаём слои спрайтов для экипировия
	for slot in Equipment.Slot.values():
		var layer = Sprite2D.new()
		layer.name = Equipment.Slot.keys()[slot]
		layer.z_index = slot
		layer.visible = false
		equipment_sprites.add_child(layer)
		sprite_layers[slot] = layer

func equip_item(item: Item) -> bool:
	if not item.has_method("get_slot"):
		return false
	
	var slot = item.get_slot()
	
	# Снимаем текущий предмет если есть
	if equipped_items.has(slot):
		unequip_slot(slot)
	
	# Экипируем новый
	equipped_items[slot] = item
	_update_sprite_for_slot(slot, item)
	emit_signal("equipment_changed", slot, item)
	
	print("[EquipmentManager] Equipped: %s in slot %d" % [item.item_name, slot])
	return true

func unequip_slot(slot: Equipment.Slot):
	if equipped_items.has(slot):
		var item = equipped_items[slot]
		equipped_items.erase(slot)
		_clear_sprite_for_slot(slot)
		emit_signal("equipment_changed", slot, null)
		return item
	return null

func get_equipped_item(slot: Equipment.Slot) -> Item:
	return equipped_items.get(slot, null)

func get_total_defense() -> float:
	var total = 0.0
	for item in equipped_items.values():
		if item.has_method("get_defense"):
			total += item.get_defense()
	return total

func get_total_warmth() -> float:
	var total = 0.0
	for item in equipped_items.values():
		if item.has_method("get_warmth"):
			total += item.get_warmth()
	return total

func get_total_weight() -> float:
	var total = 0.0
	for item in equipped_items.values():
		total += item.weight
	return total

func _update_sprite_for_slot(slot: Equipment.Slot, item: Item):
	if sprite_layers.has(slot):
		var layer = sprite_layers[slot]
		if item.has_method("get_sprite_path") and item.get_sprite_path() != "":
			layer.texture = load(item.get_sprite_path())
			layer.visible = true
		else:
			layer.visible = false

func _clear_sprite_for_slot(slot: Equipment.Slot):
	if sprite_layers.has(slot):
		var layer = sprite_layers[slot]
		layer.texture = null
		layer.visible = false

func get_equipment_bonuses() -> Dictionary:
	return {
		"defense": get_total_defense(),
		"warmth": get_total_warmth(),
		"weight": get_total_weight()
	}

func serialize() -> Dictionary:
	var data = {}
	for slot in equipped_items:
		data[slot] = equipped_items[slot].item_id
	return data

func deserialize(data: Dictionary):
	for slot in data:
		var item_id = data[slot]
		var item = ItemDatabase.get_item_copy(item_id)
		if item:
			equip_item(item)
