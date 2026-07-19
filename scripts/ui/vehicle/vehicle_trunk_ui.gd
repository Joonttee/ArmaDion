extends Control
class_name VehicleTrunkUI

# VehicleTrunkUI - интерфейс багажника транспорта

signal trunk_closed
signal item_stolen(item)

@onready var trunk_grid: GridContainer = $Panel/TrunkGrid
@onready var player_grid: GridContainer = $Panel/PlayerGrid
@onready var vehicle_info: Label = $Panel/VehicleInfo
@onready var close_button: Button = $Panel/CloseButton

var vehicle: Vehicle = null
var is_open: bool = false

func _ready():
	visible = false
	close_button.connect("pressed", _on_close)
	print("[VehicleTrunkUI] Initialized")

func open(veh: Vehicle):
	vehicle = veh
	visible = true
	is_open = true
	_update_ui()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	vehicle = null
	get_tree().paused = false
	emit_signal("trunk_closed")

func _update_ui():
	if not vehicle:
		return
	
	vehicle_info.text = "%s | HP: %.0f/%.0f | Топливо: %.0f/%.0f" % [
		vehicle.vehicle_name,
		vehicle.health,
		vehicle.max_health,
		vehicle.fuel,
		vehicle.max_fuel
	]
	
	# Очищаем сетки
	for child in trunk_grid.get_children():
		child.queue_free()
	for child in player_grid.get_children():
		child.queue_free()
	
	# Заполняем багажник
	for item in vehicle.trunk_items:
		var btn = Button.new()
		btn.text = item.item_name
		btn.connect("pressed", func(): _take_item(item))
		trunk_grid.add_child(btn)
	
	# Заполняем инвентарь игрока
	var player = GameManager.player
	if player and player.inventory:
		for item in player.inventory.items:
			var btn = Button.new()
			btn.text = item.item_name
			btn.connect("pressed", func(): _store_item(item))
			player_grid.add_child(btn)

func _take_item(item: Item):
	if vehicle and vehicle.remove_from_trunk(item):
		var player = GameManager.player
		if player and player.inventory:
			player.inventory.add_item(item)
	_update_ui()

func _store_item(item: Item):
	if vehicle and vehicle.add_to_trunk(item):
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
