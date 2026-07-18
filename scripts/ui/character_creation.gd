extends Control
class_name CharacterCreation

# CharacterCreation - экран создания персонажа
# Выбор профессии, черт и имени

signal character_created(skill_set, trait_set, profession_id)
signal creation_cancelled

@onready var profession_option: OptionButton = $Panel/ProfessionOption
@onready var positive_list: VBoxContainer = $Panel/TabContainer/Positive/Scroll/Grid
@onready var negative_list: VBoxContainer = $Panel/TabContainer/Negative/Scroll/Grid
@onready var selected_list: VBoxContainer = $Panel/SelectedTraits
@onready var points_label: Label = $Panel/PointsLabel
@onready var name_input: LineEdit = $Panel/NameInput
@onready var description_label: Label = $Panel/DescriptionLabel
@onready var profession_desc: Label = $Panel/ProfessionDesc

var trait_set: TraitSet
var skill_set: SkillSet
var profession: Profession
var selected_profession: String = "unemployed"
var trait_checkboxes: Dictionary = {}  # trait_id: CheckBox

func _ready():
	visible = false
	trait_set = TraitSet.new()
	skill_set = SkillSet.new()
	profession = Profession.new()
	_setup_profession_list()
	_populate_trait_lists()
	_update_points_display()
	print("[CharacterCreation] Initialized")

func open():
	visible = true
	get_tree().paused = true

func close():
	visible = false
	get_tree().paused = false

func _setup_profession_list():
	profession_option.clear()
	for prof_id in profession.get_all_professions():
		var prof = profession.get_profession(prof_id)
		profession_option.add_item(prof["name"], prof_id)
	profession_option.connect("item_selected", func(index): _on_profession_selected(index))

func _on_profession_selected(index: int):
	selected_profession = profession_option.get_item_id(index)
	var prof = profession.get_profession(selected_profession)
	profession_desc.text = prof["description"] + "\n\nСпособность: " + prof["special_ability"]

func _populate_trait_lists():
	# Очищаем списки
	for child in positive_list.get_children():
		child.queue_free()
	for child in negative_list.get_children():
		child.queue_free()
	
	# Позитивные черты
	for trait_id in trait_set.get_all_positive_traits():
		_create_trait_checkbox(trait_id, positive_list)
	
	# Негативные черты
	for trait_id in trait_set.get_all_negative_traits():
		_create_trait_checkbox(trait_id, negative_list)

func _create_trait_checkbox(trait_id: String, parent: VBoxContainer):
	var trait_def = trait_set.TRAIT_DEFINITIONS[trait_id]
	
	var hbox = HBoxContainer.new()
	
	var checkbox = CheckBox.new()
	checkbox.text = "%s (%+d очков)" % [trait_def["name"], trait_def["points"]]
	checkbox.tooltip_text = trait_def["description"]
	checkbox.connect("toggled", func(pressed): _on_trait_toggled(trait_id, pressed))
	
	trait_checkboxes[trait_id] = checkbox
	hbox.add_child(checkbox)
	
	parent.add_child(hbox)

func _on_trait_toggled(trait_id: String, pressed: bool):
	if pressed:
		if not trait_set.add_trait(trait_id):
			# Не удалось добавить — снимаем галочку
			trait_checkboxes[trait_id].button_pressed = false
			_show_error("Нельзя взять эту черту!")
	else:
		trait_set.remove_trait(trait_id)
	
	_update_points_display()
	_update_selected_list()

func _update_points_display():
	points_label.text = "Очки черт: %d / %d" % [trait_set.get_remaining_points(), trait_set.MAX_TRAIT_POINTS]

func _update_selected_list():
	# Очищаем список выбранных
	for child in selected_list.get_children():
		child.queue_free()
	
	# Добавляем выбранные черты
	for trait_id in trait_set.positive_traits:
		var label = Label.new()
		label.text = "+ " + trait_set.TRAIT_DEFINITIONS[trait_id]["name"]
		label.modulate = Color.GREEN
		selected_list.add_child(label)
	
	for trait_id in trait_set.negative_traits:
		var label = Label.new()
		label.text = "- " + trait_set.TRAIT_DEFINITIONS[trait_id]["name"]
		label.modulate = Color.RED
		selected_list.add_child(label)

func _show_error(message: String):
	description_label.text = message
	description_label.modulate = Color.RED
	await get_tree().create_timer(2.0).timeout
	description_label.modulate = Color.WHITE
	description_label.text = "Выберите профессию и черты для вашего персонажа"

func _on_create_pressed():
	var char_name = name_input.text.strip_edges()
	if char_name == "":
		_show_error("Введите имя персонажа!")
		return
	
	# Применяем профессию
	profession.apply_profession(selected_profession, skill_set, trait_set)
	
	emit_signal("character_created", skill_set, trait_set, selected_profession)
	close()
	print("[CharacterCreation] Character created: %s (%s)" % [char_name, selected_profession])

func _on_cancel_pressed():
	emit_signal("creation_cancelled")
	close()
