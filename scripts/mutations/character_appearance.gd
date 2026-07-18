extends Node2D
class_name CharacterAppearance

# CharacterAppearance - управляет внешним видом персонажа
# Изменяет спрайт в зависимости от активных мутаций

# Слои спрайтов
@onready var base_sprite: Sprite2D = $BaseSprite
@onready var overlay_container: Node2D = $Overlays

# Словарь оверлеев по слоям
var overlays: Dictionary = {}  # layer_name: Sprite2D

# Система мутаций
var mutation_system: Mutation = null

func _ready():
	print("[CharacterAppearance] Initialized")

# Установить систему мутаций
func set_mutation_system(system: Mutation):
	mutation_system = system
	system.connect("mutation_gained", _on_mutation_gained)
	system.connect("mutation_lost", _on_mutation_lost)
	_refresh_appearance()

# Обновить внешний вид
func _refresh_appearance():
	_clear_overlays()
	
	if not mutation_system:
		return
	
	for mutation_id in mutation_system.get_active_mutations():
		_apply_mutation_visual(mutation_id)

# Применить визуал мутации
func _apply_mutation_visual(mutation_id: String):
	match mutation_id:
		"thick_skin":
			_add_overlay("res://assets/sprites/mutations/thick_skin_overlay.svg", "body")
		"night_vision_mut":
			_add_overlay("res://assets/sprites/mutations/night_vision_overlay.svg", "head")
		"extra_eye":
			_add_overlay("res://assets/sprites/mutations/extra_eye_overlay.svg", "head")
		"carapace":
			_add_overlay("res://assets/sprites/mutations/carapace_overlay.svg", "back")
		"venom_glands":
			_add_overlay("res://assets/sprites/mutations/venom_glands_overlay.svg", "hands")
		"regeneration":
			_add_overlay("res://assets/sprites/mutations/regeneration_overlay.svg", "body")
		"skin_lesions":
			_add_overlay("res://assets/sprites/mutations/skin_lesions_overlay.svg", "body")
		"muscle_degeneration":
			_add_overlay("res://assets/sprites/mutations/muscle_degeneration_overlay.svg", "body")
		"water_breathing":
			_add_overlay("res://assets/sprites/mutations/gills_overlay.svg", "neck")
		"zombie_virus":
			_add_overlay("res://assets/sprites/mutations/zombie_virus_overlay.svg", "body")

# Добавить оверлей
func _add_overlay(texture_path: String, layer: String):
	if not ResourceLoader.exists(texture_path):
		return
	
	var overlay = Sprite2D.new()
	overlay.texture = load(texture_path)
	overlay.position = Vector2.ZERO
	overlay.z_index = _get_layer_z_index(layer)
	
	overlay_container.add_child(overlay)
	
	if not overlays.has(layer):
		overlays[layer] = []
	overlays[layer].append(overlay)

# Удалить оверлей
func _remove_overlays_for_mutation(mutation_id: String):
	# Удаляем все оверлеи и пересоздаём
	_refresh_appearance()

# Очистить все оверлеи
func _clear_overlays():
	for layer in overlays:
		for overlay in overlays[layer]:
			overlay.queue_free()
	overlays.clear()

# Получить Z-индекс для слоя
func _get_layer_z_index(layer: String) -> int:
	match layer:
		"body": return 1
		"head": return 2
		"hands": return 3
		"back": return 0
		"neck": return 2
		_: return 1

# Обработчики событий мутаций
func _on_mutation_gained(mutation_id: String):
	_apply_mutation_visual(mutation_id)

func _on_mutation_lost(mutation_id: String):
	_remove_overlays_for_mutation(mutation_id)

# Установить видимость
func set_visible(visible: bool):
	base_sprite.visible = visible
	for layer in overlays:
		for overlay in overlays[layer]:
			overlay.visible = visible
