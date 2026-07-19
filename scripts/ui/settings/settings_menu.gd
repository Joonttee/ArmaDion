extends Control
class_name SettingsMenu

# SettingsMenu - меню настроек

signal settings_closed
signal settings_applied(settings)

@onready var graphics_tab: VBoxContainer = $Panel/TabContainer/Graphics
@onready var audio_tab: VBoxContainer = $Panel/TabContainer/Audio
@onready var gameplay_tab: VBoxContainer = $Panel/TabContainer/Gameplay

# Graphics settings
@onready var resolution_option: OptionButton = $Panel/TabContainer/Graphics/ResolutionOption
@onready var fullscreen_check: CheckBox = $Panel/TabContainer/Graphics/FullscreenCheck
@onready var vsync_check: CheckBox = $Panel/TabContainer/Graphics/VsyncCheck

# Audio settings
@onready var master_volume_slider: HSlider = $Panel/TabContainer/Audio/MasterVolumeSlider
@onready var music_volume_slider: HSlider = $Panel/TabContainer/Audio/MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $Panel/TabContainer/Audio/SFXVolumeSlider
@onready var ambient_volume_slider: HSlider = $Panel/TabContainer/Audio/AmbientVolumeSlider

# Gameplay settings
@onready var difficulty_option: OptionButton = $Panel/TabContainer/Gameplay/DifficultyOption
@onready var auto_save_check: CheckBox = $Panel/TabContainer/Gameplay/AutoSaveCheck
@onready var show_hud_check: CheckBox = $Panel/TabContainer/Gameplay/ShowHUDCheck

# Buttons
@onready var apply_button: Button = $Panel/ApplyButton
@onready var cancel_button: Button = $Panel/CancelButton
@onready var reset_button: Button = $Panel/ResetButton

var current_settings: Dictionary = {}

func _ready():
	visible = false
	_setup_buttons()
	_load_settings()
	print("[SettingsMenu] Initialized")

func _setup_buttons():
	apply_button.connect("pressed", _on_apply)
	cancel_button.connect("pressed", _on_cancel)
	reset_button.connect("pressed", _on_reset)

func _load_settings():
	# Load from SaveManager or use defaults
	current_settings = {
		"resolution": "1280x720",
		"fullscreen": false,
		"vsync": true,
		"master_volume": 0.8,
		"music_volume": 0.7,
		"sfx_volume": 0.8,
		"ambient_volume": 0.5,
		"difficulty": "normal",
		"auto_save": true,
		"show_hud": true
	}
	
	# Apply to UI
	_update_ui_from_settings()

func _update_ui_from_settings():
	# Graphics
	fullscreen_check.button_pressed = current_settings["fullscreen"]
	vsync_check.button_pressed = current_settings["vsync"]
	
	# Audio
	master_volume_slider.value = current_settings["master_volume"]
	music_volume_slider.value = current_settings["music_volume"]
	sfx_volume_slider.value = current_settings["sfx_volume"]
	ambient_volume_slider.value = current_settings["ambient_volume"]
	
	# Gameplay
	auto_save_check.button_pressed = current_settings["auto_save"]
	show_hud_check.button_pressed = current_settings["show_hud"]

func _update_settings_from_ui():
	current_settings = {
		"resolution": resolution_option.get_item_text(resolution_option.selected),
		"fullscreen": fullscreen_check.button_pressed,
		"vsync": vsync_check.button_pressed,
		"master_volume": master_volume_slider.value,
		"music_volume": music_volume_slider.value,
		"sfx_volume": sfx_volume_slider.value,
		"ambient_volume": ambient_volume_slider.value,
		"difficulty": difficulty_option.get_item_text(difficulty_option.selected),
		"auto_save": auto_save_check.button_pressed,
		"show_hud": show_hud_check.button_pressed
	}

func show_settings():
	visible = true
	_load_settings()

func hide_settings():
	visible = false
	emit_signal("settings_closed")

func _on_apply():
	_update_settings_from_ui()
	_apply_settings()
	SaveManager.save_settings()
	hide_settings()
	emit_signal("settings_applied", current_settings)

func _on_cancel():
	hide_settings()

func _on_reset():
	current_settings = {
		"resolution": "1280x720",
		"fullscreen": false,
		"vsync": true,
		"master_volume": 0.8,
		"music_volume": 0.7,
		"sfx_volume": 0.8,
		"ambient_volume": 0.5,
		"difficulty": "normal",
		"auto_save": true,
		"show_hud": true
	}
	_update_ui_from_settings()

func _apply_settings():
	# Apply graphics settings
	if current_settings["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# Apply audio settings
	if AudioManager:
		AudioManager.set_music_volume(current_settings["music_volume"])
		AudioManager.set_sfx_volume(current_settings["sfx_volume"])
		AudioManager.set_ambient_volume(current_settings["ambient_volume"])

func get_settings() -> Dictionary:
	return current_settings
