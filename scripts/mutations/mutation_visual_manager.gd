extends Node2D
class_name MutationVisualManager

# MutationVisualManager - управляет визуальным отображением мутаций
# Накладывает оверлеи на спрайт персонажа

# Словарь мутация -> путь к оверлею
const MUTATION_OVERLAYS = {
	"thick_skin": "res://assets/sprites/mutations/thick_skin_overlay.svg",
	"night_vision_mut": "res://assets/sprites/mutations/night_vision_overlay.svg",
	"extra_eye": "res://assets/sprites/mutations/extra_eye_overlay.svg",
	"carapace": "res://assets/sprites/mutations/carapace_overlay.svg",
	"venom_glands": "res://assets/sprites/mutations/venom_glands_overlay.svg",
	"regeneration": "res://assets/sprites/mutations/regeneration_overlay.svg",
	"skin_lesions": "res://assets/sprites/mutations/skin_lesions_overlay.svg",
	"muscle_degeneration": "res://assets/sprites/mutations/muscle_degeneration_overlay.svg",
	"water_breathing": "res://assets/sprites/mutations/gills_overlay.svg",
	"zombie_virus": "res://assets/sprites/mutations/zombie_virus_overlay.svg"
}

# Словарь загруженных текстур
var loaded_textures: Dictionary = {}
# Активные оверлеи
var active_overlays: Dictionary = {}  # mutation_id: Sprite2D
# Целевой спрайт
var target_sprite: Sprite2D = null
# Система мутаций
var mutation_system: Mutation = null

func _ready():
	_load_textures()
	print("[MutationVisualManager] Initialized")

# Загрузить все текстуры оверлеев
func _load_textures():
	for mutation_id in MUTATION_OVERLAYS:
		var path = MUTATION_OVERLAYS[mutation_id]
		if ResourceLoader.exists(path):
			loaded_textures[mutation_id] = load(path)
		else:
			push_warning("Mutation overlay not found: " + path)

# Установить целевой спрайт
func set_target_sprite(sprite: Sprite2D):
	target_sprite = sprite

# Установить систему мутаций
func set_mutation_system(system: Mutation):
	mutation_system = system
	system.connect("mutation_gained", _on_mutation_gained)
	system.connect("mutation_lost", _on_mutation_lost)
	system.connect("mutation_stage_changed", _on_mutation_stage_changed)
	_refresh_all_overlays()

# Обновить все оверлеи
func _refresh_all_overlays():
	# Удаляем все текущие оверлеи
	for overlay in active_overlays.values():
		overlay.queue_free()
	active_overlays.clear()
	
	if not mutation_system:
		return
	
	# Добавляем оверлеи для активных мутаций
	for mutation_id in mutation_system.get_active_mutations():
		_add_overlay(mutation_id)

# Добавить оверлей мутации
func _add_overlay(mutation_id: String):
	if active_overlays.has(mutation_id):
		return
	
	if not loaded_textures.has(mutation_id):
		return
	
	if not target_sprite:
		return
	
	var overlay_sprite = Sprite2D.new()
	overlay_sprite.texture = loaded_textures[mutation_id]
	overlay_sprite.position = target_sprite.position
	overlay_sprite.z_index = target_sprite.z_index + 1
	
	# Добавляем как дочерний элемент к родителю целевого спрайта
	target_sprite.get_parent().add_child(overlay_sprite)
	
	active_overlays[mutation_id] = overlay_sprite
	print("[MutationVisualManager] Added overlay: " % mutation_id)

# Удалить оверлей мутации
func _remove_overlay(mutation_id: String):
	if active_overlays.has(mutation_id):
		active_overlays[mutation_id].queue_free()
		active_overlays.erase(mutation_id)
		print("[MutationVisualManager] Removed overlay: " % mutation_id)

# Обработка получения мутации
func _on_mutation_gained(mutation_id: String):
	_add_overlay(mutation_id)

# Обработка потери мутации
func _on_mutation_lost(mutation_id: String):
	_remove_overlay(mutation_id)

# Обработка изменения стадии мутации
func _on_mutation_stage_changed(mutation_id: String, new_stage: int):
	# Можно менять прозрачность или цвет в зависимости от стадии
	if active_overlays.has(mutation_id):
		var overlay = active_overlays[mutation_id]
		# Увеличиваем интенсивность с ростом стадии
		overlay.modulate = Color(1, 1, 1, 0.5 + (new_stage * 0.1))

# Обновление позиции оверлеев (вызывается каждый кадр)
func _process(_delta):
	if not target_sprite:
		return
	
	for overlay in active_overlays.values():
		overlay.position = target_sprite.position

# Установить видимость оверлеев
func set_overlays_visible(visible: bool):
	for overlay in active_overlays.values():
		overlay.visible = visible

# Получить список активных визуальных оверлеев
func get_active_overlay_ids() -> Array:
	return active_overlays.keys()
