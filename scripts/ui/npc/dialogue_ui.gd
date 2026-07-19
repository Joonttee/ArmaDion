extends Control
class_name DialogueUI

# DialogueUI - интерфейс диалога с НПС
# Показывает реплики и варианты ответов

signal dialogue_closed
signal dialogue_option_selected(option_id)

@onready var npc_name_label: Label = $Panel/NPCNameLabel
@onready var dialogue_text: Label = $Panel/DialogueText
@onready var options_container: VBoxContainer = $Panel/OptionsContainer
@onready var close_button: Button = $Panel/CloseButton

var npc: NPC = null
var is_open: bool = false

# Варианты ответов
var dialogue_options = [
	{"id": "trade", "text": "Торговать"},
	{"id": "ask", "text": "Расспросить"},
	{"id": "leave", "text": "Уйти"}
]

func _ready():
	visible = false
	close_button.connect("pressed", _on_close)
	print("[DialogueUI] Initialized")

func open(npc_ref: NPC):
	npc = npc_ref
	visible = true
	is_open = true
	_update_dialogue()
	_create_options()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	npc = null
	get_tree().paused = false
	emit_signal("dialogue_closed")

func _update_dialogue():
	if npc:
		npc_name_label.text = npc.npc_name
		dialogue_text.text = npc.get_dialogue_line()

func _create_options():
	# Очищаем контейнер
	for child in options_container.get_children():
		child.queue_free()
	
	# Создаём кнопки опций
	for option in dialogue_options:
		# Показываем только релевантные опции
		if option["id"] == "trade" and not npc.can_trade:
			continue
		
		var btn = Button.new()
		btn.text = option["text"]
		btn.connect("pressed", func(): _on_option_selected(option["id"]))
		options_container.add_child(btn)

func _on_option_selected(option_id: String):
	emit_signal("dialogue_option_selected", option_id)
	
	match option_id:
		"trade":
			close()
			EventManager.emit_signal("open_npc_trade", npc)
		"ask":
			_update_dialogue()
		"leave":
			close()

func _on_close():
	close()

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel"):
		close()
