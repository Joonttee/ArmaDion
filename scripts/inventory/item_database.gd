extends Resource
class_name ItemDatabase

# ItemDatabase - база данных всех предметов в игре
# Используется для создания предметов по ID

@export var items: Dictionary = {}

func _init():
	_load_default_items()

func _load_default_items():
	# Оружие
	_add_item("axe", {
		"item_name": "Топор",
		"description": "Тяжёлый топор. Хорош для рубки деревьев и зомби.",
		"weight": 3.0,
		"item_type": Item.ItemType.WEAPON,
		"damage": 35.0
	})
	
	_add_item("bat", {
		"item_name": "Бита",
		"description": "Бейсбольная бита. Надёжное оружие ближнего боя.",
		"weight": 2.0,
		"item_type": Item.ItemType.WEAPON,
		"damage": 20.0
	})
	
	_add_item("knife", {
		"item_name": "Нож",
		"description": "Кухонный нож. Быстрый, но слабый.",
		"weight": 0.5,
		"item_type": Item.ItemType.WEAPON,
		"damage": 15.0
	})
	
	# Еда
	_add_item("canned_food", {
		"item_name": "Консервы",
		"description": "Банка тушёнки. Утоляет голод.",
		"weight": 0.5,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"hunger_recovery": 30.0
	})
	
	_add_item("apple", {
		"item_name": "Яблоко",
		"description": "Свежее яблоко. Немного утоляет голод и жажду.",
		"weight": 0.2,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"hunger_recovery": 15.0,
		"thirst_recovery": 10.0
	})
	
	_add_item("bread", {
		"item_name": "Хлеб",
		"description": "Буханка хлеба. Питательный.",
		"weight": 0.3,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"hunger_recovery": 25.0
	})
	
	# Напитки
	_add_item("water_bottle", {
		"item_name": "Бутылка воды",
		"description": "Чистая питьевая вода.",
		"weight": 0.5,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"thirst_recovery": 40.0
	})
	
	_add_item("soda", {
		"item_name": "Газировка",
		"description": "Сладкая газировка. Бодрит!",
		"weight": 0.4,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"thirst_recovery": 25.0,
		"hunger_recovery": 5.0
	})
	
	# Медикаменты
	_add_item("bandage", {
		"item_name": "Бинт",
		"description": "Стерильный бинт. Восстанавливает здоровье.",
		"weight": 0.1,
		"item_type": Item.ItemType.MEDICINE,
		"consumable": true,
		"healing": 20.0
	})
	
	_add_item("first_aid_kit", {
		"item_name": "Аптечка",
		"description": "Полная аптечка. Значительно восстанавливает здоровье.",
		"weight": 1.0,
		"item_type": Item.ItemType.MEDICINE,
		"consumable": true,
		"healing": 50.0
	})
	
	_add_item("pills", {
		"item_name": "Таблетки",
		"description": "Обезболивающее. Немного восстанавливает здоровье.",
		"weight": 0.1,
		"item_type": Item.ItemType.MEDICINE,
		"consumable": true,
		"healing": 15.0
	})
	
	# Материалы
	_add_item("wood", {
		"item_name": "Дерево",
		"description": "Доски и брёвна. Строительный материал.",
		"weight": 2.0,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 50
	})
	
	_add_item("metal", {
		"item_name": "Металл",
		"description": "Металлические детали. Для прочных конструкций.",
		"weight": 3.0,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 30
	})
	
	_add_item("cloth", {
		"item_name": "Ткань",
		"description": "Кусок ткани. Для бинтов и одежды.",
		"weight": 0.3,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("nails", {
		"item_name": "Гвозди",
		"description": "Коробка гвоздей. Необходимы для строительства.",
		"weight": 0.5,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 100
	})
	
	# Инструменты
	_add_item("hammer", {
		"item_name": "Молоток",
		"description": "Необходим для строительства.",
		"weight": 1.5,
		"item_type": Item.ItemType.TOOL,
		"damage": 10.0
	})
	
	_add_item("screwdriver", {
		"item_name": "Отвёртка",
		"description": "Полезный инструмент.",
		"weight": 0.5,
		"item_type": Item.ItemType.TOOL,
		"damage": 5.0
	})

func _add_item(id: String, data: Dictionary):
	var item = Item.new()
	item.item_id = id
	item.item_name = data.get("item_name", "Unknown")
	item.description = data.get("description", "")
	item.weight = data.get("weight", 1.0)
	item.item_type = data.get("item_type", Item.ItemType.MISC)
	item.damage = data.get("damage", 0.0)
	item.healing = data.get("healing", 0.0)
	item.hunger_recovery = data.get("hunger_recovery", 0.0)
	item.thirst_recovery = data.get("thirst_recovery", 0.0)
	item.stackable = data.get("stackable", false)
	item.max_stack = data.get("max_stack", 1)
	item.consumable = data.get("consumable", false)
	items[id] = item

func get_item_copy(item_id: String) -> Item:
	if items.has(item_id):
		return items[item_id].duplicate()
	push_warning("Item not found: " + item_id)
	return null

func get_all_items() -> Array:
	return items.values()
