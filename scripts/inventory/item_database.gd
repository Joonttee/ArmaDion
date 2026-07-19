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
	
	# === СЕМЕНА ===
	_add_item("carrot_seeds", {
		"item_name": "Семена моркови",
		"description": "Семена для посадки моркови. Быстро растёт.",
		"weight": 0.1,
		"item_type": Item.ItemType.MISC,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("potato_seeds", {
		"item_name": "Семена картофеля",
		"description": "Семена для посадки картофеля. Высокий урожай.",
		"weight": 0.1,
		"item_type": Item.ItemType.MISC,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("tomato_seeds", {
		"item_name": "Семена помидоров",
		"description": "Семена для посадки помидоров. Утоляют жажду.",
		"weight": 0.1,
		"item_type": Item.ItemType.MISC,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("corn_seeds", {
		"item_name": "Семена кукурузы",
		"description": "Семена для посадки кукурузы. Очень питательна.",
		"weight": 0.1,
		"item_type": Item.ItemType.MISC,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("wheat_seeds", {
		"item_name": "Семена пшеницы",
		"description": "Семена для посадки пшеницы. Для выпечки хлеба.",
		"weight": 0.1,
		"item_type": Item.ItemType.MISC,
		"stackable": true,
		"max_stack": 20
	})
	
	# === УРОЖАЙ ===
	_add_item("carrot", {
		"item_name": "Морковь",
		"description": "Свежая морковь. Утоляет голод.",
		"weight": 0.2,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"hunger_recovery": 20.0,
		"thirst_recovery": 5.0,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("potato", {
		"item_name": "Картофель",
		"description": "Сырой картофель. Лучше приготовить.",
		"weight": 0.3,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"hunger_recovery": 15.0,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("tomato", {
		"item_name": "Помидор",
		"description": "Сочный помидор. Утоляет жажду.",
		"weight": 0.2,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"hunger_recovery": 10.0,
		"thirst_recovery": 20.0,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("corn", {
		"item_name": "Кукуруза",
		"description": "Початок кукурузы. Очень питательна.",
		"weight": 0.3,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"hunger_recovery": 30.0,
		"thirst_recovery": 5.0,
		"stackable": true,
		"max_stack": 20
	})
	
	_add_item("wheat", {
		"item_name": "Пшеница",
		"description": "Колос пшеницы. Можно сделать муку.",
		"weight": 0.2,
		"item_type": Item.ItemType.FOOD,
		"consumable": true,
		"hunger_recovery": 10.0,
		"stackable": true,
		"max_stack": 30
	})
	
	# === СТРОИТЕЛЬНЫЕ МАТЕРИАЛЫ ===
	_add_item("wall_wood", {
		"item_name": "Деревянная стена",
		"description": "Планки для строительства деревянной стены.",
		"weight": 5.0,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 10
	})
	
	_add_item("wall_metal", {
		"item_name": "Металлическая стена",
		"description": "Металлические листы для прочной стены.",
		"weight": 8.0,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 10
	})
	
	_add_item("foundation_item", {
		"item_name": "Фундамент",
		"description": "Основа для строительства базы.",
		"weight": 6.0,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 10
	})
	
	_add_item("door_item", {
		"item_name": "Дверь",
		"description": "Дверь для входа в базу.",
		"weight": 4.0,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 5
	})
	
	_add_item("storage_box", {
		"item_name": "Сундук",
		"description": "Хранилище для предметов.",
		"weight": 3.0,
		"item_type": Item.ItemType.MATERIAL,
		"stackable": true,
		"max_stack": 5
	})
	
	# === СУМКИ ===
	_add_item("small_backpack", {
		"item_name": "Малая сумка",
		"description": "Небольшая сумка для дополнительных припасов. +4 слота.",
		"weight": 0.5,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 4,
		"weight_reduction": 0.05
	})
	
	_add_item("backpack", {
		"item_name": "Рюкзак",
		"description": "Стандартный туристический рюкзак. +8 слотов.",
		"weight": 1.0,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 8,
		"weight_reduction": 0.10
	})
	
	_add_item("large_backpack", {
		"item_name": "Большой рюкзак",
		"description": "Вместительный рюкзак для длительных походов. +12 слотов.",
		"weight": 1.5,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 12,
		"weight_reduction": 0.15
	})
	
	_add_item("satchel", {
		"item_name": "Сумка через плечо",
		"description": "Удобная сумка для быстрого доступа. +6 слотов.",
		"weight": 0.3,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 6,
		"weight_reduction": 0.0
	})
	
	_add_item("duffel_bag", {
		"item_name": "Вещмешок",
		"description": "Прочный мешок для снаряжения. +10 слотов.",
		"weight": 0.8,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 10,
		"weight_reduction": 0.10
	})
	
	_add_item("military_backpack", {
		"item_name": "Военный рюкзак",
		"description": "Прочный рюкзак с множеством карманов. +16 слотов.",
		"weight": 2.0,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 16,
		"weight_reduction": 0.20
	})
	
	# === ДОПОЛНИТЕЛЬНЫЕ СУМКИ ===
	_add_item("belt_pouch", {
		"item_name": "Поясная сумка",
		"description": "Небольшая сумка на поясе для мелочей. +2 слота.",
		"weight": 0.2,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 2,
		"weight_reduction": 0.0
	})
	
	_add_item("holster", {
		"item_name": "Кобура",
		"description": "Кобура для оружия. +1 слот для оружия.",
		"weight": 0.3,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 1,
		"weight_reduction": 0.0
	})
	
	_add_item("quiver", {
		"item_name": "Колчан",
		"description": "Колчан для стрел. +3 слота для боеприпасов.",
		"weight": 0.4,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 3,
		"weight_reduction": 0.0
	})
	
	_add_item("medical_bag", {
		"item_name": "Медицинская сумка",
		"description": "Сумка для медикаментов. +4 слота, лучшие бинты.",
		"weight": 0.6,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 4,
		"weight_reduction": 0.05
	})
	
	_add_item("tool_belt", {
		"item_name": "Пояс для инструментов",
		"description": "Пояс с карманами для инструментов. +3 слота.",
		"weight": 0.7,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 3,
		"weight_reduction": 0.0
	})
	
	_add_item("ammo_pouch", {
		"item_name": "Подсумок",
		"description": "Подсумок для боеприпасов. +5 слотов для патронов.",
		"weight": 0.5,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 5,
		"weight_reduction": 0.0
	})
	
	# === СПЕЦИАЛЬНЫЕ СУМКИ ===
	_add_item("explorer_backpack", {
		"item_name": "Рюкзак исследователя",
		"description": "Прочный рюкзак для долгих экспедиций. +14 слотов, -12% веса.",
		"weight": 1.8,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 14,
		"weight_reduction": 0.12
	})
	
	_add_item("hiking_backpack", {
		"item_name": "Туристический рюкзак",
		"description": "Лёгкий рюкзак для походов. +10 слотов, -8% веса.",
		"weight": 1.2,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 10,
		"weight_reduction": 0.08
	})
	
	_add_item("tactical_vest", {
		"item_name": "Тактический жилет",
		"description": "Жилет с множеством карманов. +8 слотов, быстрый доступ.",
		"weight": 1.5,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 8,
		"weight_reduction": 0.05
	})
	
	_add_item("messenger_bag", {
		"item_name": "Сумка курьера",
		"description": "Удобная сумка для документов и мелочей. +5 слотов.",
		"weight": 0.4,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 5,
		"weight_reduction": 0.0
	})
	
	_add_item("suitcase", {
		"item_name": "Чемодан",
		"description": "Прочный чемодан для ценных вещей. +7 слотов, защита содержимого.",
		"weight": 1.0,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 7,
		"weight_reduction": 0.05
	})
	
	# === РЕДКИЕ СУМКИ ===
	_add_item("adventure_backpack", {
		"item_name": "Рюкзак авантюриста",
		"description": "Легендарный рюкзак с магией хранения. +20 слотов, -25% веса.",
		"weight": 2.5,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 20,
		"weight_reduction": 0.25
	})
	
	_add_item("invisible_bag", {
		"item_name": "Невидимая сумка",
		"description": "Зачарованная сумка, невидимая для других. +12 слотов.",
		"weight": 0.1,
		"item_type": Item.ItemType.MISC,
		"is_bag": true,
		"slots_bonus": 12,
		"weight_reduction": 0.30
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
