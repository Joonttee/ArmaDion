extends Node

# GameManager - оптимизированный главный менеджер игры

signal game_started
signal game_paused
signal game_resumed
signal game_over
signal state_changed(new_state)

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER }

var current_state: GameState = GameState.MENU
var player: CharacterBody2D = null
var world: Node2D = null
var game_time: float = 0.0
var day_count: int = 1
var game_session_id: String = ""

# Кэш для производительности
var _day_length: float = 720.0  # Длина дня в секундах

func _ready():
	game_session_id = str(randi())
	print("[GameManager] Initialized")

func start_game():
	current_state = GameState.PLAYING
	game_time = 0.0
	day_count = 1
	emit_signal("game_started")
	emit_signal("state_changed", current_state)
	print("[GameManager] Game started")

func pause_game():
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		emit_signal("game_paused")
		emit_signal("state_changed", current_state)

func resume_game():
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		emit_signal("game_resumed")
		emit_signal("state_changed", current_state)

func end_game():
	current_state = GameState.GAME_OVER
	emit_signal("game_over")
	emit_signal("state_changed", current_state)

func _process(delta):
	if current_state != GameState.PLAYING:
		return
	
	game_time += delta
	
	# Проверка нового дня
	if game_time >= _day_length * day_count:
		day_count += 1
		EventManager.emit_signal("new_day", day_count)

func is_playing() -> bool:
	return current_state == GameState.PLAYING

func get_game_time_formatted() -> String:
	var hours = int(game_time / 3600.0) % 24
	var minutes = int(game_time / 60.0) % 60
	return "%02d:%02d" % [hours, minutes]

func get_state() -> Dictionary:
	return {
		"state": current_state,
		"time": game_time,
		"day": day_count,
		"session": game_session_id
	}
