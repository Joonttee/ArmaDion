extends Control
class_name InventoryUI

# InventoryUI - интерфейс инвентаря
# Отображает список предметов, позволяет использовать и выбрасывать

signal closed

@onready var item_grid: GridContainer = $Panel/ItemGrid
@onready var item_description: Label = $Panel/ItemDescription
@onready var item_scene: PackedScene = preload("res://scenes/ui/item_slot.tscn")

var inventory: Inventory
var is_open: bool = false

func _ready():
	visible = false
	print("[InventoryUI] Initialized")

func open(inv: Inventory):
	inventory = inv
	visible = true
	is_open = true
	_refresh_items()
	get_tree().paused = true
	EventManager.emit_signal("toggle_inventory")

func close():
	visible = false
	is_open = false
	get_tree().paused = false
	emit_signal("closed")
	EventManager.emit_signal("toggle_inventory")

func _refresh_items():
	# Очищаем сетку
	for child in item_grid.get_children():
		child.queue_free()
	
	# Добавляем предметы
	if inventory:
		for item in inventory.items:
			var slot = item_scene.instantiate()
			slot.setup(item)
			slot.connect("selected", _on_item_selected)
			slot.connect("use_pressed", _on_item_use)
			slot.connect("drop_pressed", _on_item_drop)
			item_grid.add_child(slot)

func _on_item_selected(item: Item):
	item_description.text = "%s\n%s\nВес: %.1f" % [item.item_name, item.description, item.weight]

func _on_item_use(item: Item):
	if inventory:
		inventory.use_item(item)
		_refresh_items()

func _on_item_drop(item: Item):
	if inventory:
		inventory.remove_item(item)
		_refresh_items()

func _input(event):
	if event.is_action_pressed("inventory") and is_open:
		close()
	elif event.is_action_pressed("ui_cancel") and is_open:
		close()
