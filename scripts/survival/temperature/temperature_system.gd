extends Node
class_name TemperatureSystem

# TemperatureSystem - система температуры тела (как в CDDA)
# Отслеживает температуру тела, влияние одежды и окружающей среды

signal temperature_changed(new_temp, old_temp)
signal hypothermia_warning()
signal hyperthermia_warning()

# Температурные зоны (в градусах Цельсия)
const TEMP_HYPOTHERMIA_SEVERE = 30.0  # Сильная гипотермия
const TEMP_HYPOTHERMIA = 34.0         # Гипотермия
const TEMP_COLD = 36.0                # Холодно
const TEMP_NORMAL = 37.0              # Норма
const TEMP_WARM = 38.0                # Тепло
const TEMP_HOT = 39.0                 # Жарко
const TEMP_HYPERTHERMIA = 40.0        # Гипертермия
const TEMP_HYPERTHERMIA_SEVERE = 42.0 # Сильная гипертермия

var body_temperature: float = 37.0
var ambient_temperature: float = 20.0

# Модификаторы
var clothing_insulation: float = 0.0  # Теплоизоляция одежды
var wetness: float = 0.0              # Влажность (0-100)
var wind_exposure: float = 0.0        # Ветер (0-100)
var activity_level: float = 0.0       # Активность (0-100)
var is_indoors: bool = false
var is_in_water: bool = false

# Эффекты
var frostbite_level: float = 0.0      # Обморожение (0-100)
var heatstroke_level: float = 0.0     # Тепловой удар (0-100)

func _process(delta):
	_update_temperature(delta)
	_check_temperature_effects(delta)

func _update_temperature(delta):
	var target_temp = _calculate_target_temperature()
	var temp_change_rate = 0.5  # Скорость изменения температуры
	
	# Влажность ускоряет охлаждение
	if wetness > 50:
		temp_change_rate *= 1.5
	
	# Ветер усиливает охлаждение
	if wind_exposure > 30:
		temp_change_rate *= 1.0 + (wind_exposure / 100.0)
	
	# Вода сильно охлаждает
	if is_in_water:
		temp_change_rate *= 3.0
	
	# Приближаемся к целевой температуре
	var old_temp = body_temperature
	body_temperature = lerp(body_temperature, target_temp, temp_change_rate * delta)
	
	if abs(body_temperature - old_temp) > 0.1:
		emit_signal("temperature_changed", body_temperature, old_temp)

func _calculate_target_temperature() -> float:
	var base_temp = ambient_temperature
	
	# Одежда добавляет теплоизоляцию
	base_temp += clothing_insulation * 0.5
	
	# Активность нагревает тело
	base_temp += activity_level * 0.02
	
	# В помещении теплее
	if is_indoors:
		base_temp += 5.0
	
	return base_temp

func _check_temperature_effects(delta):
	# Гипотермия
	if body_temperature < TEMP_HYPOTHERMIA:
		frostbite_level += delta * 2.0
		if body_temperature < TEMP_HYPOTHERMIA_SEVERE:
			frostbite_level += delta * 5.0
			emit_signal("hypothermia_warning")
	else:
		frostbite_level = max(0, frostbite_level - delta)
	
	# Гипертермия
	if body_temperature > TEMP_HYPERTHERMIA:
		heatstroke_level += delta * 2.0
		if body_temperature > TEMP_HYPERTHERMIA_SEVERE:
			heatstroke_level += delta * 5.0
			emit_signal("hyperthermia_warning")
	else:
		heatstroke_level = max(0, heatstroke_level - delta)

func get_temperature_status() -> String:
	if body_temperature < TEMP_HYPOTHERMIA_SEVERE:
		return "Сильная гипотермия!"
	elif body_temperature < TEMP_HYPOTHERMIA:
		return "Гипотермия"
	elif body_temperature < TEMP_COLD:
		return "Холодно"
	elif body_temperature < TEMP_WARM:
		return "Норма"
	elif body_temperature < TEMP_HOT:
		return "Тепло"
	elif body_temperature < TEMP_HYPERTHERMIA:
		return "Жарко"
	else:
		return "Тепловой удар!"

func get_temperature_bonus() -> float:
	# Бонусы/штрафы от температуры
	if body_temperature < TEMP_HYPOTHERMIA or body_temperature > TEMP_HYPERTHERMIA:
		return -20.0  # Штраф к действиям
	elif body_temperature < TEMP_COLD or body_temperature > TEMP_HOT:
		return -5.0
	return 0.0

func add_insulation(amount: float):
	clothing_insulation += amount

func set_wetness(amount: float):
	wetness = clamp(amount, 0, 100)

func set_activity(level: float):
	activity_level = clamp(level, 0, 100)
