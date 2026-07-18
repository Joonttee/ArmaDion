extends Control
class_name MutationDisplay

# MutationDisplay - отображение мутаций и радиации
# Показывает активные мутации и уровень облучения

signal closed

@onready var mutation_list: VBoxContainer = $Panel/MutationScroll/MutationList
@onready var radiation_bar: ProgressBar = $Panel/RadiationBar
@onready var radiation_label: Label = $Panel/RadiationLabel

var mutation_system: Mutation
var is_open: bool = false

func _ready():
	visible = false
	print("[MutationDisplay] Initialized")

func open(mut_system: Mutation):
	mutation_system = mut_system
	visible = true
	is_open = true
	_populate_mutations()
	_update_radiation()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	get_tree().paused = false
	emit_signal("closed")

func _populate_mutations():
	# Очищаем список
	for child in mutation_list.get_children():
		child.queue_free()
	
	if not mutation_system:
		return
	
	# Группируем по категориям
	var categories = {
		Mutation.Category.PHYSICAL: "🧬 ФИЗИЧЕСКИЕ",
		Mutation.Category.MENTAL: "🧠 МЕНТАЛЬНЫЕ",
		Mutation.Category.PSYCHIC: "✨ ПСИХИЧЕСКИЕ",
		Mutation.Category.INSTABILITY: "⚠️ НЕСТАБИЛЬНОСТЬ"
	}
	
	for category in categories:
		var mutations = mutation_system.get_mutations_by_category(category)
		var has_active = false
		
		for mut_id in mutations:
			if mutation_system.has_mutation(mut_id):
				has_active = true
				break
		
		if has_active:
			# Заголовок категории
			var cat_label = Label.new()
			cat_label.text = "=== " + categories[category] + " ==="
			cat_label.add_theme_font_size_override("font_size", 16)
			mutation_list.add_child(cat_label)
			
			# Мутации категории
			for mut_id in mutations:
				if mutation_system.has_mutation(mut_id):
					_create_mutation_entry(mut_id)
			
			# Отступ
			var spacer = Control.new()
			spacer.custom_minimum_size = Vector2(0, 10)
			mutation_list.add_child(spacer)

func _create_mutation_entry(mutation_id: String):
	var mut_def = mutation_system.MUTATION_DEFINITIONS[mutation_id]
	var stage = mutation_system.get_mutation_stage(mutation_id)
	var max_stage = mutation_system.get_max_stage(mutation_id)
	
	var hbox = HBoxContainer.new()
	hbox.custom_minimum_size = Vector2(0, 40)
	
	# Иконка типа
	var type_label = Label.new()
	match mut_def["type"]:
		Mutation.Type.POSITIVE:
			type_label.text = "✅"
			type_label.modulate = Color.GREEN
		Mutation.Type.NEGATIVE:
			type_label.text = "❌"
			type_label.modulate = Color.RED
		Mutation.Type.MIXED:
			type_label.text = "⚠️"
			type_label.modulate = Color.YELLOW
	type_label.custom_minimum_size = Vector2(30, 0)
	hbox.add_child(type_label)
	
	# Название и стадия
	var vbox = VBoxContainer.new()
	
	var name_label = Label.new()
	name_label.text = mut_def["name"] + " (%d/%d)" % [stage, max_stage]
	name_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(name_label)
	
	var desc_label = Label.new()
	desc_label.text = mut_def["description"]
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc_label.add_theme_font_size_override("font_size", 11)
	vbox.add_child(desc_label)
	
	hbox.add_child(vbox)
	mutation_list.add_child(hbox)

func _update_radiation():
	if mutation_system:
		radiation_bar.value = min(mutation_system.radiation_level, 100)
		radiation_label.text = "Радиация: %.1f%%" % mutation_system.radiation_level
		
		# Цвет в зависимости от уровня
		if mutation_system.radiation_level < 25:
			radiation_bar.modulate = Color.GREEN
		elif mutation_system.radiation_level < 50:
			radiation_bar.modulate = Color.YELLOW
		elif mutation_system.radiation_level < 75:
			radiation_bar.modulate = Color.ORANGE
		else:
			radiation_bar.modulate = Color.RED

func _process(_delta):
	if visible and mutation_system:
		_update_radiation()

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("mutations"):
		close()
