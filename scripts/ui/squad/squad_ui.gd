extends Control
class_name SquadUI

# SquadUI - интерфейс управления отрядом
# Показывает членов отряда, их состояние и позволяет управлять ими

signal squad_ui_closed

@onready var member_list: VBoxContainer = $Panel/MemberList
@onready var member_details: VBoxContainer = $Panel/MemberDetails
@onready var mission_list: VBoxContainer = $Panel/MissionList
@onready var close_button: Button = $Panel/CloseButton

var selected_member: SquadMember = null
var is_open: bool = false

func _ready():
	visible = false
	close_button.connect("pressed", _on_close)
	print("[SquadUI] Initialized")

func open():
	visible = true
	is_open = true
	_update_member_list()
	_update_mission_list()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	selected_member = null
	get_tree().paused = false
	emit_signal("squad_ui_closed")

func _update_member_list():
	# Очищаем список
	for child in member_list.get_children():
		child.queue_free()
	
	# Добавляем членов отряда
	for member in SquadManager.squad_members:
		var btn = Button.new()
		btn.text = "%s (Lv.%d)" % [member.npc_name, member.level]
		
		# Цвет в зависимости от состояния
		match member.member_state:
			SquadMember.State.IDLE:
				btn.modulate = Color.WHITE
			SquadMember.State.ON_MISSION:
				btn.modulate = Color.YELLOW
			SquadMember.State.AT_BASE:
				btn.modulate = Color.GREEN
			SquadMember.State.INJURED:
				btn.modulate = Color.RED
			SquadMember.State.RESTING:
				btn.modulate = Color.CYAN
		
		btn.connect("pressed", func(): _select_member(member))
		member_list.add_child(btn)

func _select_member(member: SquadMember):
	selected_member = member
	_update_member_details()

func _update_member_details():
	# Очищаем
	for child in member_details.get_children():
		child.queue_free()
	
	if not selected_member:
		return
	
	var member = selected_member
	
	# Имя и уровень
	var name_label = Label.new()
	name_label.text = "%s - Уровень %d" % [member.npc_name, member.level]
	name_label.add_theme_font_size_override("font_size", 16)
	member_details.add_child(name_label)
	
	# Роль
	var role_label = Label.new()
	role_label.text = "Роль: %s" % _get_role_name(member.member_role)
	member_details.add_child(role_label)
	
	# Здоровье
	var health_label = Label.new()
	health_label.text = "Здоровье: %.0f/%.0f" % [member.health, member.max_health]
	member_details.add_child(health_label)
	
	# Мораль
	var morale_label = Label.new()
	morale_label.text = "Мораль: %.0f" % member.morale
	member_details.add_child(morale_label)
	
	# Лояльность
	var loyalty_label = Label.new()
	loyalty_label.text = "Лояльность: %.0f" % member.loyalty
	member_details.add_child(loyalty_label)
	
	# Состояние
	var state_label = Label.new()
	state_label.text = "Состояние: %s" % _get_state_name(member.member_state)
	member_details.add_child(state_label)
	
	# Кнопки управления
	if member.member_state == SquadMember.State.IDLE:
		var mission_btn = Button.new()
		mission_btn.text = "Отправить на миссию"
		mission_btn.connect("pressed", func(): _open_mission_select(member))
		member_details.add_child(mission_btn)
		
		var task_btn = Button.new()
		task_btn.text = "Назначить на базу"
		task_btn.connect("pressed", func(): _open_task_select(member))
		member_details.add_child(task_btn)
		
		var dismiss_btn = Button.new()
		dismiss_btn.text = "Уволить"
		dismiss_btn.modulate = Color.RED
		dismiss_btn.connect("pressed", func(): _dismiss_member(member))
		member_details.add_child(dismiss_btn)

func _update_mission_list():
	# Очищаем
	for child in mission_list.get_children():
		child.queue_free()
	
	# Показываем доступные миссии
	for mission in SquadManager.available_missions:
		var hbox = HBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = mission["name"]
		name_label.custom_minimum_size = Vector2(150, 0)
		hbox.add_child(name_label)
		
		var desc_label = Label.new()
		desc_label.text = mission["description"]
		desc_label.custom_minimum_size = Vector2(200, 0)
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		hbox.add_child(desc_label)
		
		var duration_label = Label.new()
		duration_label.text = "%.0fс" % mission["duration"]
		duration_label.custom_minimum_size = Vector2(40, 0)
		hbox.add_child(duration_label)
		
		mission_list.add_child(hbox)

func _open_mission_select(member: SquadMember):
	# Показываем доступные миссии для этого члена отряда
	print("[SquadUI] Opening mission select for: %s" % member.npc_name)

func _open_task_select(member: SquadMember):
	# Показываем доступные задания на базе
	print("[SquadUI] Opening task select for: %s" % member.npc_name)

func _dismiss_member(member: SquadMember):
	SquadManager.dismiss_member(member)
	_update_member_list()
	selected_member = null
	_update_member_details()

func _get_role_name(role: SquadMember.Role) -> String:
	match role:
		SquadMember.Role.FIGHTER: return "Боец"
		SquadMember.Role.SCOUT: return "Разведчик"
		SquadMember.Role.WORKER: return "Рабочий"
		SquadMember.Role.MEDIC: return "Медик"
		SquadMember.Role.TRADER: return "Торговец"
		_: return "Неизвестно"

func _get_state_name(state: SquadMember.State) -> String:
	match state:
		SquadMember.State.IDLE: return "Свободен"
		SquadMember.State.ON_MISSION: return "На миссии"
		SquadMember.State.AT_BASE: return "На базе"
		SquadMember.State.INJURED: return "Ранен"
		SquadMember.State.RESTING: return "Отдыхает"
		_: return "Неизвестно"

func _on_close():
	close()

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel"):
		close()
