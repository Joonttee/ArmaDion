extends CanvasLayer
class_name HUD

# HUD - интерфейс игрока
# Отображает здоровье, голод, жажду, стамини, время

@onready var health_bar: ProgressBar = $HealthBar
@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var hunger_bar: ProgressBar = $HungerBar
@onready var thirst_bar: ProgressBar = $ThirstBar
@onready var time_label: Label = $TimeLabel
@onready var day_label: Label = $DayLabel
@onready var equipped_item_label: Label = $EquippedItemLabel

func _ready():
	print("[HUD] HUD initialized")
	_connect_signals()

func _connect_signals():
	# Подключаемся к событиям игрока
	await get_tree().process_frame
	if GameManager.player:
		GameManager.player.connect("health_changed", _on_health_changed)
		GameManager.player.connect("stamina_changed", _on_stamina_changed)
		GameManager.player.connect("hunger_changed", _on_hunger_changed)
		GameManager.player.connect("thirst_changed", _on_thirst_changed)

func _process(_delta):
	if not GameManager.is_playing():
		return
	
	# Обновление времени
	time_label.text = GameManager.get_game_time_formatted()
	day_label.text = "День %d" % GameManager.day_count

func _on_health_changed(new_health: float, max_health: float):
	health_bar.value = (new_health / max_health) * 100

func _on_stamina_changed(new_stamina: float, max_stamina: float):
	stamina_bar.value = (new_stamina / max_stamina) * 100

func _on_hunger_changed(new_hunger: float):
	hunger_bar.value = new_hunger

func _on_thirst_changed(new_thirst: float):
	thirst_bar.value = new_thirst

func update_equipped_item(item_name: String):
	equipped_item_label.text = "Экипировано: %s" % item_name

func show_message(text: String, duration: float = 2.0):
	# Показать временное сообщение
	var message_label = Label.new()
	message_label.text = text
	message_label.position = Vector2(400, 300)
	add_child(message_label)
	
	await get_tree().create_timer(duration).timeout
	message_label.queue_free()
