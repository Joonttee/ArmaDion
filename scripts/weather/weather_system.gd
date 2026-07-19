extends Node

# WeatherSystem - система погоды
# Управляет погодными условиями и их влиянием на геймплей

signal weather_changed(new_weather)
signal intensity_changed(new_intensity)

enum Weather { CLEAR, CLOUDY, RAIN, HEAVY_RAIN, STORM, SNOW, FOG, BLIZZARD }
enum Season { SPRING, SUMMER, AUTUMN, WINTER }

var current_weather: Weather = Weather.CLEAR
var current_season: Season = Season.SUMMER
var intensity: float = 0.5
var wind_direction: Vector2 = Vector2.ZERO
var wind_speed: float = 0.0
var temperature: float = 20.0

# Настройки
var weather_change_interval: float = 300.0
var weather_timer: float = 0.0

# Влияние на геймплей
var visibility_modifier: float = 1.0
var zombie_speed_modifier: float = 1.0
var player_speed_modifier: float = 1.0
var crop_growth_modifier: float = 1.0

# Эффекты
var rain_particles: CPUParticles2D = null
var snow_particles: CPUParticles2D = null
var fog_layer: ColorRect = null

func _ready():
	_setup_effects()
	print("[WeatherSystem] Initialized")

func _setup_effects():
	# Создаём частицы дождя
	rain_particles = CPUParticles2D.new()
	rain_particles.name = "RainParticles"
	rain_particles.emitting = false
	rain_particles.amount = 500
	rain_particles.lifetime = 2.0
	rain_particles.gravity = Vector2(0, 400)
	rain_particles.direction = Vector2(0, 1)
	rain_particles.spread = 10.0
	rain_particles.initial_velocity_min = 200.0
	rain_particles.initial_velocity_max = 300.0
	rain_particles.modulate = Color(0.7, 0.8, 1.0, 0.6)
	get_tree().root.add_child(rain_particles)
	
	# Создаём частицы снега
	snow_particles = CPUParticles2D.new()
	snow_particles.name = "SnowParticles"
	snow_particles.emitting = false
	snow_particles.amount = 300
	snow_particles.lifetime = 5.0
	snow_particles.gravity = Vector2(0, 50)
	snow_particles.direction = Vector2(0, 1)
	snow_particles.spread = 20.0
	snow_particles.initial_velocity_min = 20.0
	snow_particles.initial_velocity_max = 50.0
	snow_particles.modulate = Color(1, 1, 1, 0.8)
	get_tree().root.add_child(snow_particles)

func _process(delta):
	weather_timer += delta
	if weather_timer >= weather_change_interval:
		weather_timer = 0.0
		_maybe_change_weather()
	
	_update_effects(delta)

func _maybe_change_weather():
	var roll = randf()
	
	# Шанс смены погоды зависит от текущей
	if current_weather == Weather.CLEAR:
		if roll < 0.3:
			set_weather(Weather.CLOUDY)
	elif current_weather == Weather.CLOUDY:
		if roll < 0.3:
			set_weather(Weather.RAIN)
		elif roll < 0.5:
			set_weather(Weather.CLEAR)
	elif current_weather == Weather.RAIN:
		if roll < 0.2:
			set_weather(Weather.HEAVY_RAIN)
		elif roll < 0.4:
			set_weather(Weather.CLOUDY)
	elif current_weather == Weather.HEAVY_RAIN:
		if roll < 0.3:
			set_weather(Weather.STORM)
		elif roll < 0.5:
			set_weather(Weather.RAIN)

func set_weather(weather: Weather):
	current_weather = weather
	_apply_weather_effects()
	emit_signal("weather_changed", weather)
	print("[WeatherSystem] Weather changed to: %d" % weather)

func _apply_weather_effects():
	match current_weather:
		Weather.CLEAR:
			visibility_modifier = 1.0
			zombie_speed_modifier = 1.0
			player_speed_modifier = 1.0
			crop_growth_modifier = 1.0
			intensity = 0.0
			_stop_all_particles()
		Weather.CLOUDY:
			visibility_modifier = 0.9
			zombie_speed_modifier = 1.0
			player_speed_modifier = 1.0
			crop_growth_modifier = 0.9
			intensity = 0.2
			_stop_all_particles()
		Weather.RAIN:
			visibility_modifier = 0.7
			zombie_speed_modifier = 0.9
			player_speed_modifier = 0.85
			crop_growth_modifier = 1.2
			intensity = 0.5
			_start_rain()
		Weather.HEAVY_RAIN:
			visibility_modifier = 0.5
			zombie_speed_modifier = 0.8
			player_speed_modifier = 0.7
			crop_growth_modifier = 1.3
			intensity = 0.8
			_start_rain()
		Weather.STORM:
			visibility_modifier = 0.3
			zombie_speed_modifier = 0.7
			player_speed_modifier = 0.6
			crop_growth_modifier = 1.1
			intensity = 1.0
			_start_rain()
		Weather.SNOW:
			visibility_modifier = 0.6
			zombie_speed_modifier = 0.85
			player_speed_modifier = 0.75
			crop_growth_modifier = 0.5
			intensity = 0.6
			_start_snow()
		Weather.FOG:
			visibility_modifier = 0.2
			zombie_speed_modifier = 0.9
			player_speed_modifier = 0.9
			crop_growth_modifier = 0.8
			intensity = 0.7
			_stop_all_particles()
		Weather.BLIZZARD:
			visibility_modifier = 0.1
			zombie_speed_modifier = 0.6
			player_speed_modifier = 0.5
			crop_growth_modifier = 0.2
			intensity = 1.0
			_start_snow()

func _start_rain():
	if rain_particles:
		rain_particles.emitting = true
		rain_particles.amount = int(200 + intensity * 800)
	if snow_particles:
		snow_particles.emitting = false

func _start_snow():
	if snow_particles:
		snow_particles.emitting = true
		snow_particles.amount = int(100 + intensity * 400)
	if rain_particles:
		rain_particles.emitting = false

func _stop_all_particles():
	if rain_particles:
		rain_particles.emitting = false
	if snow_particles:
		snow_particles.emitting = false

func _update_effects(delta):
	# Обновляем позицию частиц относительно игрока
	var player = GameManager.player
	if player:
		if rain_particles:
			rain_particles.global_position = player.global_position + Vector2(0, -400)
		if snow_particles:
			snow_particles.global_position = player.global_position + Vector2(0, -400)

func set_season(season: Season):
	current_season = season
	_apply_season_effects()

func _apply_season_effects():
	match current_season:
		Season.SPRING:
			temperature = 15.0
			crop_growth_modifier *= 1.2
		Season.SUMMER:
			temperature = 25.0
			crop_growth_modifier *= 1.0
		Season.AUTUMN:
			temperature = 10.0
			crop_growth_modifier *= 0.8
		Season.WINTER:
			temperature = -5.0
			crop_growth_modifier *= 0.3

func get_weather_name() -> String:
	match current_weather:
		Weather.CLEAR: return "Ясно"
		Weather.CLOUDY: return "Облачно"
		Weather.RAIN: return "Дождь"
		Weather.HEAVY_RAIN: return "Ливень"
		Weather.STORM: return "Гроза"
		Weather.SNOW: return "Снег"
		Weather.FOG: return "Туман"
		Weather.BLIZZARD: return "Метель"
		_: return "Неизвестно"

func serialize() -> Dictionary:
	return {
		"weather": current_weather,
		"season": current_season,
		"intensity": intensity,
		"temperature": temperature
	}

func deserialize(data: Dictionary):
	current_weather = data.get("weather", Weather.CLEAR)
	current_season = data.get("season", Season.SUMMER)
	intensity = data.get("intensity", 0.5)
	temperature = data.get("temperature", 20.0)
