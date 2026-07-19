extends Node

# AudioManager - менеджер звуков
# Управляет музыкой, эффектами и эмбиентом

signal music_changed(track_name)
signal sound_played(sound_name)

# Аудио шины
@onready var music_bus: AudioStreamPlayer = $MusicPlayer
@onready var ambient_bus: AudioStreamPlayer = $AmbientPlayer
@onready var sfx_bus: AudioStreamPlayer = $SFXPlayer
@onready var ui_bus: AudioStreamPlayer = $UIPlayer

# Громкость (0.0 - 1.0)
var music_volume: float = 0.7
var ambient_volume: float = 0.5
var sfx_volume: float = 0.8
var ui_volume: float = 0.6

# Треки музыки
var music_tracks: Dictionary = {
	"menu": "res://assets/sounds/music/menu_theme.ogg",
	"day": "res://assets/sounds/music/day_ambient.ogg",
	"night": "res://assets/sounds/music/night_tension.ogg",
	"combat": "res://assets/sounds/music/combat_theme.ogg",
	"safe_zone": "res://assets/sounds/music/safe_zone.ogg"
}

# Звуковые эффекты
var sound_effects: Dictionary = {
	# Игрок
	"player_walk": "res://assets/sounds/effects/footstep.ogg",
	"player_run": "res://assets/sounds/effects/footstep_run.ogg",
	"player_attack": "res://assets/sounds/effects/swing.ogg",
	"player_hurt": "res://assets/sounds/effects/player_hurt.ogg",
	"player_death": "res://assets/sounds/effects/player_death.ogg",
	"player_pickup": "res://assets/sounds/effects/pickup.ogg",
	"player_craft": "res://assets/sounds/effects/craft.ogg",
	"player_build": "res://assets/sounds/effects/build.ogg",
	
	# Зомби
	"zombie_growl": "res://assets/sounds/effects/zombie_growl.ogg",
	"zombie_attack": "res://assets/sounds/effects/zombie_attack.ogg",
	"zombie_death": "res://assets/sounds/effects/zombie_death.ogg",
	"zombie_alert": "res://assets/sounds/effects/zombie_alert.ogg",
	
	# Окружение
	"door_open": "res://assets/sounds/effects/door_open.ogg",
	"door_close": "res://assets/sounds/effects/door_close.ogg",
	"container_open": "res://assets/sounds/effects/container_open.ogg",
	"tree_chop": "res://assets/sounds/effects/chop_tree.ogg",
	
	# UI
	"ui_click": "res://assets/sounds/effects/click.ogg",
	"ui_hover": "res://assets/sounds/effects/hover.ogg",
	"ui_open": "res://assets/sounds/effects/inventory_open.ogg",
	"ui_close": "res://assets/sounds/effects/inventory_close.ogg",
	
	# Погода
	"rain": "res://assets/sounds/ambient/rain.ogg",
	"thunder": "res://assets/sounds/effects/thunder.ogg",
	"wind": "res://assets/sounds/ambient/wind.ogg"
}

# Загруженные звуки
var loaded_sounds: Dictionary = {}

func _ready():
	_load_sounds()
	print("[AudioManager] Initialized")

func _load_sounds():
	# Загружаем все звуки
	for sound_name in sound_effects:
		var path = sound_effects[sound_name]
		if ResourceLoader.exists(path):
			loaded_sounds[sound_name] = load(path)

# Воспроизвести звуковой эффект
func play_sfx(sound_name: String, volume: float = 1.0, pitch: float = 1.0):
	if not loaded_sounds.has(sound_name):
		return
	
	var player = AudioStreamPlayer.new()
	player.stream = loaded_sounds[sound_name]
	player.volume_db = linear_to_db(sfx_volume * volume)
	player.pitch_scale = pitch
	player.bus = "SFX"
	
	add_child(player)
	player.play()
	
	player.connect("finished", func(): player.queue_free())
	emit_signal("sound_played", sound_name)

# Воспроизвести музыку
func play_music(track_name: String, fade: bool = true):
	if not music_tracks.has(track_name):
		return
	
	if fade:
		_fade_out_music()
	
	music_bus.stream = load(music_tracks[track_name])
	music_bus.volume_db = linear_to_db(music_volume)
	music_bus.play()
	emit_signal("music_changed", track_name)

func _fade_out_music():
	var tween = create_tween()
	tween.tween_property(music_bus, "volume_db", -80, 1.0)
	tween.tween_callback(func(): music_bus.stop())

# Остановить музыку
func stop_music():
	music_bus.stop()

# Воспроизвести эмбиент
func play_ambient(ambient_name: String):
	var path = "res://assets/sounds/ambient/%s.ogg" % ambient_name
	if ResourceLoader.exists(path):
		ambient_bus.stream = load(path)
		ambient_bus.volume_db = linear_to_db(ambient_volume)
		ambient_bus.play()

# Остановить эмбиент
func stop_ambient():
	ambient_bus.stop()

# Установить громкость
func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	music_bus.volume_db = linear_to_db(music_volume)

func set_ambient_volume(volume: float):
	ambient_volume = clamp(volume, 0.0, 1.0)
	ambient_bus.volume_db = linear_to_db(ambient_volume)

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0.0, 1.0)

func set_ui_volume(volume: float):
	ui_volume = clamp(volume, 0.0, 1.0)

# Воспроизвести UI звук
func play_ui(sound_name: String):
	play_sfx("ui_" + sound_name, ui_volume)

# Звук в позиции 3D
func play_sfx_at_position(sound_name: String, position: Vector2, volume: float = 1.0):
	# Для 2D можно использовать обычный play_sfx
	play_sfx(sound_name, volume)

# Музыка по времени суток
func update_music_for_time(is_night: bool):
	if is_night:
		play_music("night")
	else:
		play_music("day")

# Сериализация настроек
func serialize_data() -> Dictionary:
	return {
		"music_volume": music_volume,
		"ambient_volume": ambient_volume,
		"sfx_volume": sfx_volume,
		"ui_volume": ui_volume
	}

func deserialize_data(data: Dictionary):
	music_volume = data.get("music_volume", 0.7)
	ambient_volume = data.get("ambient_volume", 0.5)
	sfx_volume = data.get("sfx_volume", 0.8)
	ui_volume = data.get("ui_volume", 0.6)
