extends Resource
class_name NPCTrade

# NPCTrade - система торговли с НПС
# Управляет товарами и ценами

# Товары для торговли
@export var items_for_sale: Dictionary = {}  # item_id: {price: int, count: int}
@export var items_buying: Dictionary = {}   # item_id: price_multiplier

var npc: NPC = null

func _init():
	_setup_default_trade()

func _setup_default_trade():
	# Базовые товары для продажи
	items_for_sale = {
		"canned_food": {"price": 10, "count": 5},
		"water_bottle": {"price": 8, "count": 5},
		"bandage": {"price": 15, "count": 3},
		"pills": {"price": 20, "count": 2},
		"bat": {"price": 50, "count": 1},
		"knife": {"price": 40, "count": 1},
		"wood": {"price": 5, "count": 10},
		"nails": {"price": 3, "count": 20}
	}
	
	# Предметы, которые НПС покупает (множитель от базовой цены)
	items_buying = {
		"canned_food": 0.5,
		"water_bottle": 0.5,
		"wood": 0.3,
		"metal": 0.6,
		"cloth": 0.4,
		"apple": 0.3,
		"carrot": 0.3,
		"potato": 0.3
	}

# Получить цену продажи
func get_sell_price(item_id: String) -> int:
	if items_for_sale.has(item_id):
		return items_for_sale[item_id]["price"]
	return -1

# Получить цену покупки
func get_buy_price(item_id: String) -> int:
	if items_buying.has(item_id):
		var base_price = 10  # Базовая цена
		return int(base_price * items_buying[item_id])
	return -1

# Купить предмет у НПС
func buy_item(item_id: String, player: Node2D) -> bool:
	if not items_for_sale.has(item_id):
		return false
	
	var item_data = items_for_sale[item_id]
	if item_data["count"] <= 0:
		return false
	
	# Проверяем деньги игрока (если есть система денег)
	# Пока просто добавляем предмет
	
	item_data["count"] -= 1
	print("[NPCTrade] Bought: %s" % item_id)
	return true

# Продать предмет НПС
func sell_item(item_id: String, player: Node2D) -> bool:
	if not items_buying.has(item_id):
		return false
	
	print("[NPCTrade] Sold: %s" % item_id)
	return true

# Получить список товаров для продажи
func get_available_items() -> Array:
	var result = []
	for item_id in items_for_sale:
		if items_for_sale[item_id]["count"] > 0:
			result.append(item_id)
	return result

# Получить список предметов, которые НПС покупает
func get_buyable_items() -> Array:
	return items_buying.keys()
