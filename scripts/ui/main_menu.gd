extends Control
class_name MainMenu

# MainMenu - главное меню игры

@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var load_game_button: Button = $VBoxContainer/LoadGameButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready():
	print("[MainMenu] Main menu ready")
	
	# Подключение кнопок
	new_game_button.connect("pressed", _on_new_game)
	load_game_button.connect("pressed", _on_load_game)
	settings_button.connect("pressed", _on_settings)
	quit_button.connect("pressed", _on_quit)
	
	# Проверяем наличие сохранения
	load_game_button.disabled = not SaveManager.has_save()

func _on_new_game():
	print("[MainMenu] Starting new game")
	SaveManager.delete_save()
	get_tree().change_scene_to_file("res://scenes/world/main_world.tscn")

func _on_load_game():
	print("[MainMenu] Loading game")
	if SaveManager.load_game():
		get_tree().change_scene_to_file("res://scenes/world/main_world.tscn")
	else:
		print("[MainMenu] No save found")

func _on_settings():
	print("[MainMenu] Settings not implemented yet")
	# TODO: Открыть меню настроек

func _on_quit():
	print("[MainMenu] Quitting game")
	get_tree().quit()
