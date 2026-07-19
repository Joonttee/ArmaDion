extends Control
class_name SaveLoadUI

# SaveLoadUI - интерфейс сохранения/загрузки

signal save_selected(save_slot)
signal load_selected(save_slot)
signal back_requested

const SAVE_SLOTS = 5

@onready var save_slots: VBoxContainer = $Panel/SaveSlots
@onready var back_button: Button = $Panel/BackButton

var is_save_mode: bool = true
var selected_slot: int = -1

func _ready():
	visible = false
	back_button.connect("pressed", _on_back)
	_setup_slots()
	print("[SaveLoadUI] Initialized")

func _setup_slots():
	for i in range(SAVE_SLOTS):
		var hbox = HBoxContainer.new()
		
		var slot_label = Label.new()
		slot_label.text = "Слот %d:" % (i + 1)
		slot_label.custom_minimum_size = Vector2(80, 0)
		hbox.add_child(slot_label)
		
		var info_label = Label.new()
		info_label.name = "InfoLabel"
		info_label.text = _get_slot_info(i)
		hbox.add_child(info_label)
		
		var button = Button.new()
		button.text = "Выбрать"
		button.pressed.connect(func(): _on_slot_selected(i))
		hbox.add_child(button)
		
		save_slots.add_child(hbox)

func _get_slot_info(slot: int) -> String:
	var save_path = "user://saves/save_%d.save" % slot
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var json = JSON.new()
			json.parse(file.get_as_text())
			file.close()
			var data = json.data
			return "День %d | %s" % [data.get("day", 1), data.get("timestamp", "Неизвестно")]
	return "Пусто"

func show_save():
	is_save_mode = true
	visible = true
	_refresh_slots()

func show_load():
	is_save_mode = false
	visible = true
	_refresh_slots()

func hide_ui():
	visible = false
	emit_signal("back_requested")

func _refresh_slots():
	for i in range(SAVE_SLOTS):
		var hbox = save_slots.get_child(i)
		if hbox:
			var info_label = hbox.get_node("InfoLabel")
			if info_label:
				info_label.text = _get_slot_info(i)

func _on_slot_selected(slot: int):
	selected_slot = slot
	if is_save_mode:
		emit_signal("save_selected", slot)
	else:
		emit_signal("load_selected", slot)
	_refresh_slots()

func _on_back():
	hide_ui()
