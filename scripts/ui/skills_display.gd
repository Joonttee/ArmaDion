extends Control
class_name SkillsDisplay

# SkillsDisplay - отображение навыков и черт в игре
# Показывает прогресс прокачки

signal closed

@onready var skills_container: VBoxContainer = $Panel/SkillsScroll/SkillsContainer
@onready var traits_container: VBoxContainer = $Panel/TraitsScroll/TraitsContainer
@onready var level_label: Label = $Panel/LevelLabel

var skill_set: SkillSet
var trait_set: TraitSet
var is_open: bool = false

func _ready():
	visible = false
	print("[SkillsDisplay] Initialized")

func open(skills: SkillSet, traits: TraitSet):
	skill_set = skills
	trait_set = traits
	visible = true
		is_open = true
	_populate_skills()
	_populate_traits()
	_update_level_display()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	get_tree().paused = false
	emit_signal("closed")

func _populate_skills():
	# Очищаем
	for child in skills_container.get_children():
		child.queue_free()
	
	# Группируем по категориям
	var categories = {
		SkillSet.Category.COMBAT: "⚔️ БОЕВЫЕ",
		SkillSet.Category.SURVIVAL: "🏕️ ВЫЖИВАНИЕ",
		SkillSet.Category.CRAFTING: "🔧 РЕМЕСЛО",
		SkillSet.Category.SOCIAL: "💬 СОЦИАЛЬНЫЕ",
		SkillSet.Category.INTELLECTUAL: "📚 ИНТЕЛЛЕКТУАЛЬНЫЕ"
	}
	
	for category in categories:
		# Заголовок категории
		var cat_label = Label.new()
		cat_label.text = "=== " + categories[category] + " ==="
		cat_label.add_theme_font_size_override("font_size", 16)
		skills_container.add_child(cat_label)
		
		# Навыки категории
		for skill_id in skill_set.get_skills_by_category(category):
			_create_skill_bar(skill_id)
		
		# Отступ
		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(0, 10)
		skills_container.add_child(spacer)

func _create_skill_bar(skill_id: String):
	var skill_def = skill_set.SKILL_DEFINITIONS[skill_id]
	var level = skill_set.get_level(skill_id)
	var progress = skill_set.get_level_progress(skill_id)
	
	var hbox = HBoxContainer.new()
	hbox.custom_minimum_size = Vector2(0, 30)
	
	# Название навыка
	var name_label = Label.new()
	name_label.text = skill_def["name"]
	name_label.custom_minimum_size = Vector2(120, 0)
	hbox.add_child(name_label)
	
	# Уровень
	var level_label = Label.new()
	level_label.text = "Lv.%d" % level
	level_label.custom_minimum_size = Vector2(40, 0)
	# Цвет уровня
	if level >= 10:
		level_label.modulate = Color.GOLD
	elif level >= 5:
		level_label.modulate = Color.GREEN
	hbox.add_child(level_label)
	
	# Прогресс-бар
	var progress_bar = ProgressBar.new()
	progress_bar.value = progress * 100
	progress_bar.custom_minimum_size = Vector2(150, 20)
	progress_bar.show_percentage = false
	hbox.add_child(progress_bar)
	
	# Опыт
	var xp_label = Label.new()
	var xp = skill_set.get_xp(skill_id)
	var xp_next = skill_set.get_xp_for_next_level(skill_id)
	xp_label.text = "%.0f/%.0f" % [xp, xp_next]
	xp_label.custom_minimum_size = Vector2(80, 0)
	hbox.add_child(xp_label)
	
	skills_container.add_child(hbox)

func _populate_traits():
	# Очищаем
	for child in traits_container.get_children():
		child.queue_free()
	
	# Позитивные черты
	if trait_set.positive_traits.size() > 0:
		var pos_label = Label.new()
		pos_label.text = "✅ ПОЗИТИВНЫЕ ЧЕРТЫ"
		pos_label.modulate = Color.GREEN
		traits_container.add_child(pos_label)
		
		for trait_id in trait_set.positive_traits:
			var label = Label.new()
			var trait_def = trait_set.TRAIT_DEFINITIONS[trait_id]
			label.text = "• %s: %s" % [trait_def["name"], trait_def["description"]]
			label.modulate = Color(0.7, 1.0, 0.7)
			label.autowrap_mode = TextServer.AUTOWRAP_WORD
			traits_container.add_child(label)
	
	# Негативные черты
	if trait_set.negative_traits.size() > 0:
		var neg_label = Label.new()
		neg_label.text = "❌ НЕГАТИВНЫЕ ЧЕРТЫ"
		neg_label.modulate = Color.RED
		traits_container.add_child(neg_label)
		
		for trait_id in trait_set.negative_traits:
			var label = Label.new()
			var trait_def = trait_set.TRAIT_DEFINITIONS[trait_id]
			label.text = "• %s: %s" % [trait_def["name"], trait_def["description"]]
			label.modulate = Color(1.0, 0.7, 0.7)
			label.autowrap_mode = TextServer.AUTOWRAP_WORD
			traits_container.add_child(label)

func _update_level_display():
	if skill_set:
		var total_level = 0
		for skill_id in skill_set.skills:
			total_level += skill_set.get_level(skill_id)
		level_label.text = "Общий уровень: %d" % total_level

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("skills"):
		close()
