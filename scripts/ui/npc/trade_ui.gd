extends Control
class_name TradeUI

# TradeUI - интерфейс торговли с НПС
# Показывает товары для покупки и продажи

signal trade_closed

@onready var npc_name_label: Label = $Panel/NPCNameLabel
@onready var sell_list: VBoxContainer = $Panel/SellScroll/SellList
@onready var buy_list: VBoxContainer = $Panel/BuyScroll/BuyList
@onready var player_inventory: GridContainer = $Panel/PlayerInventory
@onready var close_button: Button = $Panel/CloseButton

var npc: NPC = null
var trade_system: NPCTrade = null
var is_open: bool = false

func _ready():
	visible = false
	close_button.connect("pressed", _on_close)
	print("[TradeUI] Initialized")

func open(npc_ref: NPC):
	npc = npc_ref
	trade_system = NPCTrade.new()
	visible = true
	is_open = true
	_update_trade_list()
	_update_player_inventory()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	npc = null
	trade_system = null
	get_tree().paused = false
	emit_signal("trade_closed")

func _update_trade_list():
	# Очищаем списки
	for child in sell_list.get_children():
		child.queue_free()
	for child in buy_list.get_children():
		child.queue_free()
	
	if not trade_system:
		return
	
	# Товары для продажи
	for item_id in trade_system.get_available_items():
		var price = trade_system.get_sell_price(item_id)
		var hbox = _create_trade_item(item_id, price, true)
		sell_list.add_child(hbox)
	
	# Товары для покупки
	for item_id in trade_system.get_buyable_items():
		var price = trade_system.get_buy_price(item_id)
		var hbox = _create_trade_item(item_id, price, false)
		buy_list.add_child(hbox)

func _create_trade_item(item_id: String, price: int, is_selling: bool) -> HBoxContainer:
	var hbox = HBoxContainer.new()
	
	# Название предмета
	var name_label = Label.new()
	name_label.text = item_id
	name_label.custom_minimum_size = Vector2(100, 0)
	hbox.add_child(name_label)
	
	# Цена
	var price_label = Label.new()
	price_label.text = "%d$" % price
	price_label.custom_minimum_size = Vector2(50, 0)
	hbox.add_child(price_label)
	
	# Кнопка
	var btn = Button.new()
	btn.text = "Купить" if is_selling else "Продать"
	btn.connect("pressed", func(): _on_trade_item(item_id, is_selling))
	hbox.add_child(btn)
	
	return hbox

func _update_player_inventory():
	# Очищаем
	for child in player_inventory.get_children():
		child.queue_free()
	
	var player = GameManager.player
	if not player or not player.inventory:
		return
	
	# Показываем предметы игрока
	for item in player.inventory.items:
		var btn = Button.new()
		btn.text = item.item_name
		btn.connect("pressed", func(): _on_sell_item(item))
		player_inventory.add_child(btn)

func _on_trade_item(item_id: String, is_buying: bool):
	var player = GameManager.player
	if not player:
		return
	
	if is_buying:
		if trade_system.buy_item(item_id, player):
			print("[TradeUI] Bought: %s" % item_id)
	else:
		if trade_system.sell_item(item_id, player):
			print("[TradeUI] Sold: %s" % item_id)
	
	_update_trade_list()
	_update_player_inventory()

func _on_sell_item(item: Item):
	var player = GameManager.player
	if not player:
		return
	
	if trade_system.sell_item(item.item_id, player):
		player.inventory.remove_item(item)
		_update_trade_list()
		_update_player_inventory()

func _on_close():
	close()

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel"):
		close()
