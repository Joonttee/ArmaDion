extends Node
class_name MoraleSystem

# MoraleSystem - система морали (как в CDDA)
# Отслеживает настроение, стресс и их влияние на персонажа

signal morale_changed(new_morale, old_morale)
signal morale_effect_triggered(effect)

enum MoraleLevel { SUICIDAL, VERY_BAD, BAD, NEUTRAL, GOOD, VERY_GOOD, ECSTATIC }

var morale: float = 50.0  # 0-100
var stress: float = 0.0   # 0-100
var happiness: float = 50.0  # 0-100

# Модификаторы
var hunger_modifier: float = 0.0
var thirst_modifier: float = 0.0
var pain_modifier: float = 0.0
var fatigue_modifier: float = 0.0
var social_modifier: float = 0.0
var environment_modifier: float = 0.0

# Эффекты
var is_depressed: bool = false
var is_euphoric: bool = false
var has_morale_bonus: bool = false

func _process(delta):
	_update_morale(delta)
	_check_morale_effects()

func _update_morale(delta):
	var target_morale = 50.0  # Базовый уровень
	
	# Влияние различных факторов
	target_morale += hunger_modifier
	target_morale += thirst_modifier
	target_morale += pain_modifier
	target_morale += fatigue_modifier
	target_morale += social_modifier
	target_morale += environment_modifier
	
	# Стресс снижает мораль
	target_morale -= stress * 0.3
	
	# Плавное изменение
	var old_morale = morale
	morale = lerp(morale, target_morale, 0.1 * delta)
	morale = clamp(morale, 0, 100)
	
	if abs(morale - old_morale) > 1.0:
		emit_signal("morale_changed", morale, old_morale)

func _check_morale_effects():
	# Депрессия
	is_depressed = morale < 20
	is_euphoric = morale > 80
	
	if is_depressed:
		emit_signal("morale_effect_triggered", "depression")
	elif is_euphoric:
		emit_signal("morale_effect_triggered", "euphoria")

func get_morale_level() -> MoraleLevel:
	if morale < 10:
		return MoraleLevel.SUICIDAL
	elif morale < 25:
		return MoraleLevel.VERY_BAD
	elif morale < 40:
		return MoraleLevel.BAD
	elif morale < 60:
		return MoraleLevel.NEUTRAL
	elif morale < 75:
		return MoraleLevel.GOOD
	elif morale < 90:
		return MoraleLevel.VERY_GOOD
	else:
		return MoraleLevel.ECSTATIC

func get_morale_bonus() -> float:
	# Бонусы/штрафы от морали
	if morale < 20:
		return -30.0  # Сильный штраф
	elif morale < 40:
		return -15.0
	elif morale < 60:
		return 0.0
	elif morale < 80:
		return 10.0
	else:
		return 20.0  # Бонус

func add_morale(amount: float, reason: String = ""):
	morale = clamp(morale + amount, 0, 100)
	print("[Morale] %s: %.0f (%s)" % ["+" if amount > 0 else "", amount, reason])

func add_stress(amount: float):
	stress = clamp(stress + amount, 0, 100)

func reduce_stress(amount: float):
	stress = max(0, stress - amount)

func get_morale_status() -> String:
	match get_morale_level():
		MoraleLevel.SUICIDAL: return "Суицидальное"
		MoraleLevel.VERY_BAD: return "Очень плохое"
		MoraleLevel.BAD: return "Плохое"
		MoraleLevel.NEUTRAL: return "Нейтральное"
		MoraleLevel.GOOD: return "Хорошее"
		MoraleLevel.VERY_GOOD: return "Очень хорошее"
		MoraleLevel.ECSTATIC: return "Эйфория"
	return "Неизвестно"
