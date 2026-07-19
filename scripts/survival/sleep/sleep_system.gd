extends Node
class_name SleepSystem

# SleepSystem - система сна (как в CDDA)
# Усталость, сны, бессонница, качество сна

signal sleep_started(duration)
signal sleep_ended(quality)
signal fatigue_changed(new_fatigue)

enum SleepQuality { TERRIBLE, POOR, NORMAL, GOOD, EXCELLENT }

var fatigue: float = 0.0  # 0-100
var is_sleeping: bool = false
var sleep_duration: float = 0.0
var sleep_quality: SleepQuality = SleepQuality.NORMAL

# Модификаторы
var comfort_bonus: float = 0.0
var environment_bonus: float = 0.0
var stress_penalty: float = 0.0

# Состояния
var has_insomnia: bool = false
var is_restless: bool = false
var sleep_debt: float = 0.0

func _process(delta):
	if is_sleeping:
		_update_sleep(delta)
	else:
		_increase_fatigue(delta)

func _update_sleep(delta):
	sleep_duration -= delta
	
	# Восстанавливаем усталость
	var recovery_rate = 10.0  # Базовая скорость
	recovery_rate += comfort_bonus * 5.0
	recovery_rate += environment_bonus * 3.0
	recovery_rate -= stress_penalty * 4.0
	
	if has_insomnia:
		recovery_rate *= 0.5
	
	fatigue = max(0, fatigue - recovery_rate * delta)
	
	if sleep_duration <= 0 or fatigue <= 0:
		_wake_up()

func _increase_fatigue(delta):
	fatigue = min(100, fatigue + delta * 0.5)
	emit_signal("fatigue_changed", fatigue)

func sleep(duration: float, comfort: float = 0.0) -> bool:
	if is_sleeping:
		return false
	
	# Бессонница мешает заснуть
	if has_insomnia and randf() < 0.3:
		return false
	
	is_sleeping = true
	sleep_duration = duration
	comfort_bonus = comfort
	
	# Рассчитываем качество сна
	_calculate_sleep_quality()
	
	emit_signal("sleep_started", duration)
	return true

func _calculate_sleep_quality():
	var quality_score = 50.0  # Базовое качество
	quality_score += comfort_bonus * 20.0
	quality_score += environment_bonus * 15.0
	quality_score -= stress_penalty * 25.0
	
	if has_insomnia:
		quality_score -= 30.0
	
	if quality_score < 20:
		sleep_quality = SleepQuality.TERRIBLE
	elif quality_score < 40:
		sleep_quality = SleepQuality.POOR
	elif quality_score < 60:
		sleep_quality = SleepQuality.NORMAL
	elif quality_score < 80:
		sleep_quality = SleepQuality.GOOD
	else:
		sleep_quality = SleepQuality.EXCELLENT

func _wake_up():
	is_sleeping = false
	
	# Бонусы от качества сна
	var bonus = 0.0
	match sleep_quality:
		SleepQuality.TERRIBLE: bonus = -20.0
		SleepQuality.POOR: bonus = -10.0
		SleepQuality.NORMAL: bonus = 0.0
		SleepQuality.GOOD: bonus = 15.0
		SleepQuality.EXCELLENT: bonus = 30.0
	
	sleep_debt = max(0, sleep_debt - 8.0 + bonus / 10.0)
	
	emit_signal("sleep_ended", sleep_quality)

func get_fatigue_penalty() -> float:
	if fatigue > 80:
		return -30.0
	elif fatigue > 60:
		return -15.0
	elif fatigue > 40:
		return -5.0
	return 0.0

func get_fatigue_status() -> String:
	if fatigue > 80:
		return "Полное истощение"
	elif fatigue > 60:
		return "Сильная усталость"
	elif fatigue > 40:
		return "Усталость"
	elif fatigue > 20:
		return "Лёгкая усталость"
	return "Отдохнувший"

func add_sleep_debt(amount: float):
	sleep_debt = min(100, sleep_debt + amount)

func cure_insomnia():
	has_insomnia = false

func cause_insomnia():
	has_insomnia = true
