extends Resource
class_name BagItem

# BagItem - ресурс сумки/рюкзака
# Увеличивает вместимость инвентаря

enum BagType { SMALL_BACKPACK, BACKPACK, LARGE_BACKPACK, SATCHEL, DUFFEL_BAG }

@export var bag_id: String = ""
@export var bag_name: String = "Сумка"
@export var description: String = ""
@export var icon: Texture2D
@export var weight: float = 0.5
@export var slots_bonus: int = 4
@export var bag_type: BagType = BagType.SMALL_BACKPACK
@export var weight_reduction: float = 0.0  # Снижение веса предметов (0-20%)

const BAG_DEFINITIONS = {
	"small_backpack": {
		"name": "Малая сумка",
		"description": "Небольшая сумка для дополнительных припасов.",
		"slots_bonus": 4,
		"weight": 0.5,
		"weight_reduction": 0.05
	},
	"backpack": {
		"name": "Рюкзак",
		"description": "Стандартный туристический рюкзак.",
		"slots_bonus": 8,
		"weight": 1.0,
		"weight_reduction": 0.10
	},
	"large_backpack": {
		"name": "Большой рюкзак",
		"description": "Вместительный рюкзак для длительных походов.",
		"slots_bonus": 12,
		"weight": 1.5,
		"weight_reduction": 0.15
	},
	"satchel": {
		"name": "Сумка через плечо",
		"description": "Удобная сумка для быстрого доступа.",
		"slots_bonus": 6,
		"weight": 0.3,
		"weight_reduction": 0.0
	},
	"duffel_bag": {
		"name": "Вещмешок",
		"description": "Прочный мешок для снаряжения.",
		"slots_bonus": 10,
		"weight": 0.8,
		"weight_reduction": 0.10
	},
	"military_backpack": {
		"name": "Военный рюкзак",
		"description": "Прочный рюкзак с множеством карманов.",
		"slots_bonus": 16,
		"weight": 2.0,
		"weight_reduction": 0.20
	}
}

func get_bonus_slots() -> int:
	return slots_bonus

func get_weight_reduction() -> float:
	return weight_reduction
