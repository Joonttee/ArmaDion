extends Resource
class_name EquipmentDatabase

# EquipmentDatabase - база данных экипировки

const EQUIPMENT_ITEMS = {
	# === ГОЛОВА ===
	"hood": {
		"name": "Капюшон",
		"slot": Equipment.Slot.HEAD,
		"defense": 2.0,
		"warmth": 5.0,
		"weight": 0.3,
		"sprite": "res://assets/sprites/player/head/hood.png"
	},
	"leather_cap": {
		"name": "Кожаная кепка",
		"slot": Equipment.Slot.HEAD,
		"defense": 3.0,
		"warmth": 3.0,
		"weight": 0.4,
		"sprite": "res://assets/sprites/player/head/leather_cap.png"
	},
	"military_helmet": {
		"name": "Военный шлем",
		"slot": Equipment.Slot.HEAD,
		"defense": 8.0,
		"warmth": 4.0,
		"weight": 1.5,
		"sprite": "res://assets/sprites/player/head/military_helmet.png"
	},
	"gas_mask": {
		"name": "Противогаз",
		"slot": Equipment.Slot.HEAD,
		"defense": 4.0,
		"warmth": 2.0,
		"weight": 1.0,
		"sprite": "res://assets/sprites/player/head/gas_mask.png"
	},
	"bandana": {
		"name": "Бандана",
		"slot": Equipment.Slot.HEAD,
		"defense": 1.0,
		"warmth": 1.0,
		"weight": 0.1,
		"sprite": "res://assets/sprites/player/head/bandana.png"
	},
	
	# === ТЕЛО ===
	"tshirt": {
		"name": "Футболка",
		"slot": Equipment.Slot.BODY,
		"defense": 1.0,
		"warmth": 3.0,
		"weight": 0.3,
		"sprite": "res://assets/sprites/player/body/tshirt.png"
	},
	"jacket": {
		"name": "Куртка",
		"slot": Equipment.Slot.BODY,
		"defense": 4.0,
		"warmth": 8.0,
		"weight": 1.0,
		"sprite": "res://assets/sprites/player/body/jacket.png"
	},
	"leather_jacket": {
		"name": "Кожаная куртка",
		"slot": Equipment.Slot.BODY,
		"defense": 6.0,
		"warmth": 6.0,
		"weight": 1.5,
		"sprite": "res://assets/sprites/player/body/leather_jacket.png"
	},
	"military_vest": {
		"name": "Военный жилет",
		"slot": Equipment.Slot.BODY,
		"defense": 12.0,
		"warmth": 4.0,
		"weight": 3.0,
		"sprite": "res://assets/sprites/player/body/military_vest.png"
	},
	"armor_plate": {
		"name": "Бронежилет",
		"slot": Equipment.Slot.BODY,
		"defense": 20.0,
		"warmth": 2.0,
		"weight": 5.0,
		"sprite": "res://assets/sprites/player/body/armor_plate.png"
	},
	"winter_coat": {
		"name": "Зимнее пальто",
		"slot": Equipment.Slot.BODY,
		"defense": 3.0,
		"warmth": 15.0,
		"weight": 2.0,
		"sprite": "res://assets/sprites/player/body/winter_coat.png"
	},
	"raincoat": {
		"name": "Плащ",
		"slot": Equipment.Slot.BODY,
		"defense": 2.0,
		"warmth": 5.0,
		"weight": 0.8,
		"sprite": "res://assets/sprites/player/body/raincoat.png"
	},
	"hoodie": {
		"name": "Худи",
		"slot": Equipment.Slot.BODY,
		"defense": 2.0,
		"warmth": 7.0,
		"weight": 0.6,
		"sprite": "res://assets/sprites/player/body/hoodie.png"
	},
	
	# === НОГИ ===
	"jeans": {
		"name": "Джинсы",
		"slot": Equipment.Slot.LEGS,
		"defense": 2.0,
		"warmth": 4.0,
		"weight": 0.8,
		"sprite": "res://assets/sprites/player/legs/jeans.png"
	},
	"cargo_pants": {
		"name": "Карго штаны",
		"slot": Equipment.Slot.LEGS,
		"defense": 3.0,
		"warmth": 4.0,
		"weight": 1.0,
		"sprite": "res://assets/sprites/player/legs/cargo_pants.png"
	},
	"military_pants": {
		"name": "Военные штаны",
		"slot": Equipment.Slot.LEGS,
		"defense": 5.0,
		"warmth": 5.0,
		"weight": 1.2,
		"sprite": "res://assets/sprites/player/legs/military_pants.png"
	},
	"leather_pants": {
		"name": "Кожаные штаны",
		"slot": Equipment.Slot.LEGS,
		"defense": 7.0,
		"warmth": 4.0,
		"weight": 1.5,
		"sprite": "res://assets/sprites/player/legs/leather_pants.png"
	},
	"shorts": {
		"name": "Шорты",
		"slot": Equipment.Slot.LEGS,
		"defense": 1.0,
		"warmth": 1.0,
		"weight": 0.3,
		"sprite": "res://assets/sprites/player/legs/shorts.png"
	},
	
	# === ОБУВЬ ===
	"sneakers": {
		"name": "Кроссовки",
		"slot": Equipment.Slot.FEET,
		"defense": 1.0,
		"warmth": 2.0,
		"weight": 0.5,
		"sprite": "res://assets/sprites/player/feet/sneakers.png"
	},
	"boots": {
		"name": "Ботинки",
		"slot": Equipment.Slot.FEET,
		"defense": 3.0,
		"warmth": 4.0,
		"weight": 1.0,
		"sprite": "res://assets/sprites/player/feet/boots.png"
	},
	"military_boots": {
		"name": "Военные ботинки",
		"slot": Equipment.Slot.FEET,
		"defense": 5.0,
		"warmth": 5.0,
		"weight": 1.5,
		"sprite": "res://assets/sprites/player/feet/military_boots.png"
	},
	"winter_boots": {
		"name": "Зимние ботинки",
		"slot": Equipment.Slot.FEET,
		"defense": 3.0,
		"warmth": 10.0,
		"weight": 1.2,
		"sprite": "res://assets/sprites/player/feet/winter_boots.png"
	},
	"running_shoes": {
		"name": "Беговые кроссовки",
		"slot": Equipment.Slot.FEET,
		"defense": 1.0,
		"warmth": 2.0,
		"weight": 0.3,
		"sprite": "res://assets/sprites/player/feet/running_shoes.png"
	},
	
	# === РУКИ ===
	"gloves": {
		"name": "Перчатки",
		"slot": Equipment.Slot.HANDS,
		"defense": 2.0,
		"warmth": 3.0,
		"weight": 0.2,
		"sprite": "res://assets/sprites/player/hands/gloves.png"
	},
	"leather_gloves": {
		"name": "Кожаные перчатки",
		"slot": Equipment.Slot.HANDS,
		"defense": 4.0,
		"warmth": 3.0,
		"weight": 0.3,
		"sprite": "res://assets/sprites/player/hands/leather_gloves.png"
	},
	"military_gloves": {
		"name": "Военные перчатки",
		"slot": Equipment.Slot.HANDS,
		"defense": 6.0,
		"warmth": 4.0,
		"weight": 0.4,
		"sprite": "res://assets/sprites/player/hands/military_gloves.png"
	},
	"fingerless_gloves": {
		"name": "Беспалые перчатки",
		"slot": Equipment.Slot.HANDS,
		"defense": 1.0,
		"warmth": 1.0,
		"weight": 0.1,
		"sprite": "res://assets/sprites/player/hands/fingerless_gloves.png"
	},
	
	# === АКСЕССУАРЫ ===
	"backpack": {
		"name": "Рюкзак",
		"slot": Equipment.Slot.ACCESSORY,
		"defense": 0.0,
		"warmth": 0.0,
		"weight": 0.5,
		"sprite": "res://assets/sprites/player/accessory/backpack.png"
	},
	"belt": {
		"name": "Пояс",
		"slot": Equipment.Slot.ACCESSORY,
		"defense": 1.0,
		"warmth": 0.0,
		"weight": 0.3,
		"sprite": "res://assets/sprites/player/accessory/belt.png"
	},
	"necklace": {
		"name": "Ожерелье",
		"slot": Equipment.Slot.ACCESSORY,
		"defense": 0.0,
		"warmth": 0.0,
		"weight": 0.1,
		"sprite": "res://assets/sprites/player/accessory/necklace.png"
	},
	"watch": {
		"name": "Часы",
		"slot": Equipment.Slot.ACCESSORY,
		"defense": 0.0,
		"warmth": 0.0,
		"weight": 0.1,
		"sprite": "res://assets/sprites/player/accessory/watch.png"
	},
	"scarf": {
		"name": "Шарф",
		"slot": Equipment.Slot.ACCESSORY,
		"defense": 1.0,
		"warmth": 5.0,
		"weight": 0.2,
		"sprite": "res://assets/sprites/player/accessory/scarf.png"
	},
	"glasses": {
		"name": "Очки",
		"slot": Equipment.Slot.ACCESSORY,
		"defense": 0.0,
		"warmth": 0.0,
		"weight": 0.1,
		"sprite": "res://assets/sprites/player/accessory/glasses.png"
	}
}

static func get_equipment_copy(equipment_id: String) -> Equipment:
	if EQUIPMENT_ITEMS.has(equipment_id):
		var data = EQUIPMENT_ITEMS[equipment_id]
		var equipment = Equipment.new()
		equipment.equipment_id = equipment_id
		equipment.equipment_name = data["name"]
		equipment.slot = data["slot"]
		equipment.defense = data.get("defense", 0.0)
		equipment.warmth = data.get("warmth", 0.0)
		equipment.weight = data.get("weight", 0.0)
		equipment.sprite_path = data.get("sprite", "")
		return equipment
	return null

static func get_all_equipment_ids() -> Array:
	return EQUIPMENT_ITEMS.keys()

static func get_equipment_by_slot(slot: Equipment.Slot) -> Array:
	var result = []
	for id in EQUIPMENT_ITEMS:
		if EQUIPMENT_ITEMS[id]["slot"] == slot:
			result.append(id)
	return result
