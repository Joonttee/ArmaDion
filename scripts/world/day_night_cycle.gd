extends Node

# DayNightCycle - система цикла дня и ночи
# Управляет временем суток, освещением и событиями

signal time_changed(hour, minute)
signal day_changed(day_count)
signal period_changed(new_period)
signal lighting_changed(color, intensity)

# Периоды суток
enum Period { DAWN, MORNING, AFTERNOON, EVENING, NIGHT, MIDNIGHT }

# Настройки
@export var day_duration_minutes: float = 24.0  # Длина дня в реальных минутах
@export var start_hour: int = 8

# Текущее время
var current_hour: int = 8
var current_minute: int = 0
var day_count: int = 1
var current_period: Period = Period.MORNING

# Скорость времени
var time_multiplier: float = 60.0

# Цвета освещения для разных периодов
const SKY_COLORS = {
	Period.DAWN: Color(0.9, 0.6, 0.4, 0.8),
	Period.MORNING: Color(0.95, 0.95, 0.85, 1.0),
	Period.AFTERNOON: Color(1.0, 1.0, 0.95, 1.0),
	Period.EVENING: Color(0.85, 0.5, 0.35, 0.8),
	Period.NIGHT: Color(0.25, 0.25, 0.45, 0.6),
	Period.MIDNIGHT: Color(0.12, 0.12, 0.25, 0.5)
}

# Интенсивность освещения
const LIGHT_INTENSITY = {
	Period.DAWN: 0.6,
	Period.MORNING: 0.9,
	Period.AFTERNOON: 1.0,
	Period.EVENING: 0.5,
	Period.NIGHT: 0.2,
	Period.MIDNIGHT: 0.1
}

# Модификаторы зомби по времени суток
const ZOMBIE_MODIFIERS = {
	Period.DAWN: {"speed": 0.9, "detection": 0.8, "aggression": 0.7},
	Period.MORNING: {"speed": 0.8, "detection": 0.7, "aggression": 0.6},
	Period.AFTERNOON: {"speed": 0.9, "detection": 0.8, "aggression": 0.7},
	Period.EVENING: {"speed": 1.1, "detection": 1.2, "aggression": 1.0},
	Period.NIGHT: {"speed": 1.3, "detection": 1.5, "aggression": 1.4},
	Period.MIDNIGHT: {"speed": 1.4, "detection": 1.6, "aggression": 1.5}
}

# Canvas modulate для затемнения
var canvas_modulate: CanvasModulate = null

func _ready():
	current_hour = start_hour
	_update_period()
	_setup_lighting()
	print("[DayNightCycle] Initialized - Day %d, %02d:%02d" % [day_count, current_hour, current_minute])

func _setup_lighting():
	# Создаём CanvasModulate для затемнения
	canvas_modulate = CanvasModulate.new()
	canvas_modulate.name = "DayNightModulate"
	canvas_modulate.color = SKY_COLORS[current_period]
	get_tree().root.add_child(canvas_modulate)

func _process(delta):
	_advance_time(delta)
	_update_lighting()

func _advance_time(delta):
	var game_seconds = delta * time_multiplier
	current_minute += int(game_seconds)
	
	while current_minute >= 60:
		current_minute -= 60
		current_hour += 1
		
		if current_hour >= 24:
			current_hour = 0
			day_count += 1
			emit_signal("day_changed", day_count)
			EventManager.emit_signal("new_day", day_count)
	
	emit_signal("time_changed", current_hour, current_minute)
	
	var old_period = current_period
	_update_period()
	if current_period != old_period:
		emit_signal("period_changed", current_period)
		_on_period_changed()

func _update_period():
	match current_hour:
		5, 6:
			current_period = Period.DAWN
		7, 8, 9, 10:
			current_period = Period.MORNING
		11, 12, 13, 14, 15:
			current_period = Period.AFTERNOON
		16, 17, 18:
			current_period = Period.EVENING
		19, 20, 21, 22:
			current_period = Period.NIGHT
		_:
			current_period = Period.MIDNIGHT

func _update_lighting():
	if canvas_modulate:
		var target_color = SKY_COLORS[current_period]
		canvas_modulate.color = canvas_modulate.color.lerp(target_color, 0.02)
	
	emit_signal("lighting_changed", SKY_COLORS[current_period], LIGHT_INTENSITY[current_period])

func _on_period_changed():
	print("[DayNightCycle] Period: %d" % current_period)
	
	# Обновляем музыку
	if AudioManager:
		AudioManager.update_music_for_time(is_night())
	
	# Обновляем зомби
	var zombies = get_tree().get_nodes_in_group("zombies")
	for zombie in zombies:
		if zombie.has_method("update_time_modifiers"):
			zombie.update_time_modifiers(get_zombie_modifiers())

# Получить текущее время в формате строки
func get_time_string() -> String:
	return "%02d:%02d" % [current_hour, current_minute]

# Получить текущий период
func get_period() -> Period:
	return current_period

# День ли сейчас?
func is_day() -> bool:
	return current_period in [Period.MORNING, Period.AFTERNOON]

# Ночь ли сейчас?
func is_night() -> bool:
	return current_period in [Period.NIGHT, Period.MIDNIGHT]

# Получить цвет неба
func get_sky_color() -> Color:
	return SKY_COLORS.get(current_period, Color.WHITE)

# Получить интенсивность освещения
func get_light_intensity() -> float:
	return LIGHT_INTENSITY.get(current_period, 1.0)

# Получить модификаторы зомби
func get_zombie_modifiers() -> Dictionary:
	return ZOMBIE_MODIFIERS.get(current_period, {})

# Установить время
func set_time(hour: int, minute: int = 0):
	current_hour = hour % 24
	current_minute = minute % 60
	_update_period()
	emit_signal("time_changed", current_hour, current_minute)

# Установить множитель времени
func set_time_multiplier(multiplier: float):
	time_multiplier = multiplier

# Сериализация
func serialize_data() -> Dictionary:
	return {
		"hour": current_hour,
		"minute": current_minute,
		"day": day_count,
		"multiplier": time_multiplier
	}

# Десериализация
func deserialize_data(data: Dictionary):
	current_hour = data.get("hour", 8)
	current_minute = data.get("minute", 0)
	day_count = data.get("day", 1)
	time_multiplier = data.get("multiplier", 60.0)
	_update_period()
