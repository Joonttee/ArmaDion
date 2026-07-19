extends Control
class_name VehicleRepairUI

# VehicleRepairUI - интерфейс ремонта и улучшения транспорта

signal repair_closed

@onready var vehicle_info: Label = $Panel/VehicleInfo
@onready var health_bar: ProgressBar = $Panel/HealthBar
@onready var repair_buttons: VBoxContainer = $Panel/RepairButtons
@onready var upgrade_buttons: VBoxContainer = $Panel/UpgradeButtons
@onready var close_button: Button = $Panel/CloseButton

var vehicle: Vehicle = null
var is_open: bool = false

func _ready():
	visible = false
	close_button.connect("pressed", _on_close)
	print("[VehicleRepairUI] Initialized")

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
	emit_signal("repair_closed")

func _update_ui():
	if not vehicle:
		return
	
	vehicle_info.text = "%s" % vehicle.vehicle_name
	health_bar.value = (vehicle.health / vehicle.max_health) * 100
	
	# Очищаем кнопки
	for child in repair_buttons.get_children():
		child.queue_free()
	for child in upgrade_buttons.get_children():
		child.queue_free()
	
	# Кнопки ремонта
	for kit_type in VehicleRepair.get_repairs_kits():
		var btn = Button.new()
		btn.text = "Ремонт (%s)" % kit_type
		btn.connect("pressed", func(): _repair(kit_type))
		repair_buttons.add_child(btn)
	
	# Кнопки улучшений
	for upgrade_id in VehicleRepair.get_all_upgrades():
		if not vehicle.upgrades.has(upgrade_id):
			var btn = Button.new()
			btn.text = "Улучшить: %s" % upgrade_id
			btn.connect("pressed", func(): _install_upgrade(upgrade_id))
			upgrade_buttons.add_child(btn)

func _repair(kit_type: String):
	if vehicle:
		VehicleRepair.repair_vehicle(vehicle, kit_type)
	_update_ui()

func _install_upgrade(upgrade_id: String):
	if vehicle:
		VehicleRepair.install_upgrade(vehicle, upgrade_id)
	_update_ui()

func _on_close():
	close()

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel"):
		close()
