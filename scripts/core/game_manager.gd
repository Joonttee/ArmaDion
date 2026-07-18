extends Node

# GameManager - главный менеджер игры (автозагрузка)
# Управляет состоянием игры, паузой, игровым циклом

signal game_started
signal game_paused
signal game_resumed
signal game_over

enum GameState { MENU, PLAYING, PAUSED, INVENTORY, CRAFTING, GAME_OVER }

var current_state: GameState = GameState.MENU
var player: CharacterBody2D = null
var world: Node2D = null
var game_time: float = 0.0  # Время в игре (секунды)
var day_count: int = 1

func _ready():
	print("[GameManager] Initialized")

func start_game():
	current_state = GameState.PLAYING
	game_time = 0.0
	day_count = 1
	emit_signal("game_started")
	print("[GameManager] Game started")

func pause_game():
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		emit_signal("game_paused")
		print("[GameManager] Game paused")

func resume_game():
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		emit_signal("game_resumed")
		print("[GameManager] Game resumed")

func end_game():
	current_state = GameState.GAME_OVER
	emit_signal("game_over")
	print("[GameManager] Game over")

func _process(delta):
	if current_state == GameState.PLAYING:
		game_time += delta
		# Новый день каждые 12 минут реального времени (24 часа в игре)
		if game_time >= 720.0 * day_count:
			day_count += 1
			EventManager.emit_signal("new_day", day_count)
			print("[GameManager] Day %d started" % day_count)

func is_playing() -> bool:
	return current_state == GameState.PLAYING

func get_game_time_formatted() -> String:
	var hours = int(game_time / 3600.0) % 24
	var minutes = int(game_time / 60.0) % 60
	return "%02d:%02d" % [hours, minutes]
