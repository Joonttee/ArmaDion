extends Control
class_name MainMenu

# MainMenu - главное меню игры

signal new_game_requested
signal load_game_requested
signal settings_requested
signal quit_requested

@onready var new_game_button: Button = $Panel/VBoxContainer/NewGameButton
@onready var load_game_button: Button = $Panel/VBoxContainer/LoadGameButton
@onready var settings_button: Button = $Panel/VBoxContainer/SettingsButton
@onready var quit_button: Button = $Panel/VBoxContainer/QuitButton
@onready var continue_button: Button = $Panel/VBoxContainer/ContinueButton
@onready var version_label: Label = $Panel/VersionLabel

@onready var save_load_ui: SaveLoadUI = $SaveLoadUI
@onready var settings_menu: SettingsMenu = $SettingsMenu

func _ready():
	_setup_buttons()
	_setup_sub_menus()
	_update_continue_button()
	print("[MainMenu] Initialized")

func _setup_buttons():
	new_game_button.connect("pressed", _on_new_game)
	load_game_button.connect("pressed", _on_load_game)
	settings_button.connect("pressed", _on_settings)
	quit_button.connect("pressed", _on_quit)
	continue_button.connect("pressed", _on_continue)

func _setup_sub_menus():
	save_load_ui.connect("load_selected", _on_save_slot_selected)
	save_load_ui.connect("back_requested", _on_save_load_back)
	settings_menu.connect("settings_closed", _on_settings_closed)

func _update_continue_button():
	continue_button.visible = SaveManager.has_save()

func _on_new_game():
	emit_signal("new_game_requested")
	print("[MainMenu] New game requested")

func _on_load_game():
	save_load_ui.show_load()
	print("[MainMenu] Load game requested")

func _on_settings():
	settings_menu.show_settings()
	print("[MainMenu] Settings requested")

func _on_quit():
	emit_signal("quit_requested")
	print("[MainMenu] Quit requested")

func _on_continue():
	# Load most recent save
	SaveManager.load_game(0)
	emit_signal("load_game_requested")

func _on_save_slot_selected(slot: int):
	SaveManager.load_game(slot)
	emit_signal("load_game_requested")

func _on_save_load_back():
	save_load_ui.hide_ui()

func _on_settings_closed():
	settings_menu.hide_settings()

func show_menu():
	visible = true
	_update_continue_button()

func hide_menu():
	visible = false
