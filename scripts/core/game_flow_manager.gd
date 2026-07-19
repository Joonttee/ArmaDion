extends Node
class_name GameFlowManager

# GameFlowManager - управляет потоком игры (меню → игра → пауза)

enum GameState { MENU, PLAYING, PAUSED, SETTINGS, GAME_OVER }

var current_state: GameState = GameState.MENU

@onready var main_menu: Control = $MainMenu
@onready var game_world: Node2D = $GameWorld
@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu
@onready var game_over_screen: Control = $GameOverScreen

func _ready():
	_setup_signals()
	_show_main_menu()
	print("[GameFlowManager] Initialized")

func _setup_signals():
	if main_menu:
		main_menu.connect("new_game_requested", _on_new_game)
		main_menu.connect("load_game_requested", _on_load_game)
		main_menu.connect("quit_requested", _on_quit)
	
	if GameManager:
		GameManager.connect("game_over", _on_game_over)

func _show_main_menu():
	current_state = GameState.MENU
	if main_menu:
		main_menu.show_menu()
	if game_world:
		game_world.visible = false
	if pause_menu:
		pause_menu.visible = false
	if settings_menu:
		settings_menu.visible = false
	if game_over_screen:
		game_over_screen.visible = false

func _on_new_game():
	print("[GameFlowManager] Starting new game...")
	current_state = GameState.PLAYING
	
	if main_menu:
		main_menu.hide_menu()
	
	if game_world:
		game_world.visible = true
		if game_world.has_method("generate_world"):
			game_world.generate_world()
	
	if GameManager:
		GameManager.start_game()

func _on_load_game():
	print("[GameFlowManager] Loading game...")
	
	if SaveManager and SaveManager.load_game(0):
		current_state = GameState.PLAYING
		
		if main_menu:
			main_menu.hide_menu()
		
		if game_world:
			game_world.visible = true
		
		if GameManager:
			GameManager.start_game()

func _on_quit():
	print("[GameFlowManager] Quitting game...")
	get_tree().quit()

func _on_game_over():
	current_state = GameState.GAME_OVER
	if game_over_screen:
		game_over_screen.show()

func pause_game():
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		if pause_menu:
			pause_menu.show()

func resume_game():
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		if pause_menu:
			pause_menu.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		match current_state:
			GameState.PLAYING:
				pause_game()
			GameState.PAUSED:
				resume_game()
			GameState.SETTINGS:
				_show_main_menu()
