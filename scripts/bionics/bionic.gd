extends Resource
class_name Bionic

# Bionic - бионический имплант (как в CDDA)
# Даёт пассивные или активные способности

enum BionicType { PASSIVE, ACTIVE, TOGGLE }
enum BionicSlot { ARM, LEG, HEAD, TORSO, EYE, HAND }

@export var bionic_id: String = ""
@export var bionic_name: String = ""
@export var description: String = ""
@export var bionic_type: BionicType = BionicType.PASSIVE
@export var slot: BionicSlot = BionicSlot.TORSO

# Требования
@export var power_cost: float = 0.0  # Потребление энергии
@export var health_cost: float = 0.0  # Влияние на здоровье

# Эффекты
@export var effects: Dictionary = {}

# Состояние
var is_installed: bool = false
var is_active: bool = false
var power_level: float = 100.0

func activate():
	if bionic_type == BionicType.ACTIVE and power_level >= power_cost:
		is_active = true
		power_level -= power_cost
		return true
	return false

func deactivate():
	is_active = false

func update(delta: float):
	if is_active:
		power_level -= power_cost * delta
		if power_level <= 0:
			deactivate()

func get_effect_value(effect_name: String) -> float:
	return effects.get(effect_name, 0.0)
