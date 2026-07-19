extends Node
class_name AddictionSystem

# AddictionSystem - система зависимостей (как в CDDA)
# Отслеживает зависимости, их эффекты и ломку

signal addiction_gained(addiction_id, severity)
signal withdrawal_started(addiction_id)
signal withdrawal_ended(addiction_id)

enum AddictionType { ALCOHOL, TOBACCO, OPIOIDS, STIMULANTS, CANNABIS, COCAINE, HALLUCINOGENS, CAFFEINE }

# Активные зависимости
var addictions: Dictionary = {}  # addiction_id: {severity: float, time_since_last: float}

# Эффекты ломки
var withdrawal_severity: float = 0.0
var is_in_withdrawal: bool = false

func _process(delta):
	_update_addictions(delta)

func _update_addictions(delta):
	for addiction_id in addictions:
		var data = addictions[addiction_id]
		data["time_since_last"] += delta
		
		# Проверяем начало ломки
		var threshold = _get_withdrawal_threshold(addiction_id)
		if data["time_since_last"] > threshold and not is_in_withdrawal:
			_start_withdrawal(addiction_id)
	
	# Обновляем ломку
	if is_in_withdrawal:
		_update_withdrawal(delta)

func add_addiction(addiction_id: String, amount: float = 10.0):
	if not addictions.has(addiction_id):
		addictions[addiction_id] = {
			"severity": 0.0,
			"time_since_last": 0.0,
			"total_uses": 0
		}
	
	var data = addictions[addiction_id]
	data["severity"] = min(100, data["severity"] + amount)
	data["time_since_last"] = 0.0
	data["total_uses"] += 1
	
	emit_signal("addiction_gained", addiction_id, data["severity"])

func use_substance(addiction_id: String):
	if addictions.has(addiction_id):
		addictions[addiction_id]["time_since_last"] = 0.0
		
		# Снимаем ломку временно
		if is_in_withdrawal:
			withdrawal_severity = max(0, withdrawal_severity - 30.0)

func _start_withdrawal(addiction_id: String):
	is_in_withdrawal = true
	withdrawal_severity = addictions[addiction_id]["severity"]
	emit_signal("withdrawal_started", addiction_id)
	print("[Addiction] Withdrawal started: %s" % addiction_id)

func _update_withdrawal(delta):
	# Ломка со временем уменьшается
	withdrawal_severity -= delta * 0.5
	if withdrawal_severity <= 0:
		withdrawal_severity = 0
		is_in_withdrawal = false
		emit_signal("withdrawal_ended", "")

func _get_withdrawal_threshold(addiction_id: String) -> float:
	match addiction_id:
		"alcohol": return 3600.0  # 1 час
		"tobacco": return 600.0   # 10 минут
		"opioids": return 1800.0  # 30 минут
		"stimulants": return 1200.0  # 20 минут
		"caffeine": return 900.0   # 15 минут
		_: return 1800.0

func get_withdrawal_effects() -> Dictionary:
	if not is_in_withdrawal:
		return {}
	
	return {
		"morale_penalty": -withdrawal_severity * 0.5,
		"speed_penalty": -withdrawal_severity * 0.2,
		"stamina_penalty": -withdrawal_severity * 0.3,
		"pain_tolerance": -withdrawal_severity * 0.4
	}

func get_addiction_severity(addiction_id: String) -> float:
	if addictions.has(addiction_id):
		return addictions[addiction_id]["severity"]
	return 0.0

func is_addicted(addiction_id: String) -> bool:
	return addictions.has(addiction_id) and addictions[addiction_id]["severity"] > 20.0

func get_all_addictions() -> Array:
	return addictions.keys()
