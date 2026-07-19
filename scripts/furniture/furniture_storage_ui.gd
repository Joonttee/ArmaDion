extends Control
class_name FurnitureStorageUI

# FurnitureStorageUI - интерфейс хранилища мебели

signal storage_closed

@onready var storage_grid: GridContainer = $Panel/StorageGrid
@onready var player_grid: GridContainer = $Panel/PlayerGrid
@onready var furniture_info: Label = $Panel/FurnitureInfo
@onready var close_button: Button = $Panel/CloseButton

var furniture: Furniture = null
var is_open: bool = false

func _ready():
	visible = false
	close_button.connect("pressed", _on_close)
	print("[FurnitureStorageUI] Initialized")

func open(furn: Furniture):
	furniture = furn
	visible = true
	is_open = true
	_update_ui()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	furniture = null
	get_tree().paused = false
	emit_signal("storage_closed")

func _update_ui():
	if not furniture:
		return
	
	furniture_info.text = "%s | Мест: %d/%d" % [
		furniture.furniture_name,
		furniture.storage_items.size(),
		furniture.storage_size
	]
	
	# Очищаем сетки
	for child in storage_grid.get_children():
		child.queue_free()
	for child in player_grid.get_children():
		child.queue_free()
	
	# Заполняем хранилище
	for item in furniture.storage_items:
		var btn = Button.new()
		btn.text = item.item_name
		btn.connect("pressed", func(): _take_item(item))
		storage_grid.add_child(btn)
	
	# Заполняем инвентарь игрока
	var player = GameManager.player
	if player and player.inventory:
		for item in player.inventory.items:
			var btn = Button.new()
			btn.text = item.item_name
			btn.connect("pressed", func(): _store_item(item))
			player_grid.add_child(btn)

func _take_item(item: Item):
	if furniture and furniture.remove_from_storage(item):
		var player = GameManager.player
		if player and player.inventory:
			player.inventory.add_item(item)
	_update_ui()

func _store_item(item: Item):
	if furniture and furniture.add_to_storage(item):
		var player = GameManager.player
		if player and player.inventory:
			player.inventory.remove_item(item)
	_update_ui()

func _on_close():
	close()

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel"):
		close()
