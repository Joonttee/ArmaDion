extends Control
class_name BagUI

# BagUI - интерфейс управления сумками
# Показывает экипированную сумку и позволяет её сменить

signal bag_equipped(bag)
signal bag_unequipped

@onready var bag_icon: TextureRect = $Panel/BagIcon
@onready var bag_name_label: Label = $Panel/BagNameLabel
@onready var bag_stats_label: Label = $Panel/BagStatsLabel
@onready var unequip_button: Button = $Panel/UnequipButton
@onready var available_bags: GridContainer = $Panel/AvailableBags

var is_open: bool = false

func _ready():
	visible = false
	unequip_button.connect("pressed", _on_unequip)
	print("[BagUI] Initialized")

func open():
	visible = true
	is_open = true
	_update_bag_display()
	_update_available_bags()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	get_tree().paused = false

func _update_bag_display():
	var player = GameManager.player
	if not player or not player.inventory:
		return
	
	var bag = player.inventory.equipped_bag
	
	if bag:
		bag_name_label.text = bag.item_name
		bag_stats_label.text = "+%d слотов, -%.0f%% веса" % [
			player.inventory.bag_slots_bonus,
			player.inventory.bag_weight_reduction * 100
		]
		unequip_button.disabled = false
	else:
		bag_name_label.text = "Сумка не экипирована"
		bag_stats_label.text = "Базовый инвентарь: %d слотов" % player.inventory.base_max_slots
		unequip_button.disabled = true

func _update_available_bags():
	# Очищаем контейнер
	for child in available_bags.get_children():
		child.queue_free()
	
	var player = GameManager.player
	if not player or not player.inventory:
		return
	
	# Показываем все сумки в инвентаре
	for item in player.inventory.items:
		if item.item_id in BagItem.BAG_DEFINITIONS:
			var btn = Button.new()
			btn.text = item.item_name
			btn.connect("pressed", func(): _on_bag_selected(item))
			available_bags.add_child(btn)

func _on_bag_selected(bag: Item):
	var player = GameManager.player
	if player and player.inventory:
		player.inventory.equip_bag(bag)
		_update_bag_display()
		emit_signal("bag_equipped", bag)

func _on_unequip():
	var player = GameManager.player
	if player and player.inventory:
		player.inventory.unequip_bag()
		_update_bag_display()
		emit_signal("bag_unequipped")

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel"):
		close()
