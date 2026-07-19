extends Control
class_name Minimap

# Minimap - миникарта
# Показывает позицию игрока, НПС, зомби и исследованные области

@export var minimap_size: Vector2 = Vector2(200, 200)
@export var zoom_level: float = 1.0
@export var show_npcs: bool = true
@export var show_zombies: bool = true
@export var show_points_of_interest: bool = true

# Цвета элементов
const COLOR_PLAYER = Color(0, 1, 0)        # Зелёный
const COLOR_NPC_FRIENDLY = Color(0, 0.5, 1) # Синий
const COLOR_NPC_NEUTRAL = Color(1, 1, 0)    # Жёлтый
const COLOR_NPC_HOSTILE = Color(1, 0, 0)    # Красный
const COLOR_ZOMBIE = Color(0.5, 0, 0)       # Тёмно-красный
const COLOR_POI = Color(1, 0.5, 0)          # Оранжевый
const COLOR_UNEXPLORED = Color(0.2, 0.2, 0.2) # Серый
const COLOR_EXPLORED = Color(0.4, 0.4, 0.4)   # Светло-серый

# Исследованные области
var explored_cells: Dictionary = {}  # cell_position: bool
var cell_size: int = 64

# Родительский канвас
@onready var canvas: SubViewport = $SubViewport

func _ready():
	custom_minimum_size = minimap_size
	print("[Minimap] Initialized")

func _draw():
	_draw_explored_areas()
	_draw_entities()
	_draw_player()

func _draw_explored_areas():
	# Рисуем исследованные клетки
	for cell_pos in explored_cells:
		var screen_pos = _world_to_minimap(Vector2(cell_pos.x * cell_size, cell_pos.y * cell_size))
		draw_rect(Rect2(screen_pos, Vector2(4, 4)), COLOR_EXPLORED)

func _draw_entities():
	var player = GameManager.player
	if not player:
		return
	
	# Рисуем зомби
	if show_zombies:
		var zombies = get_tree().get_nodes_in_group("zombies")
		for zombie in zombies:
			if zombie.global_position.distance_to(player.global_position) < 300:
				var pos = _world_to_minimap(zombie.global_position)
				draw_circle(pos, 2, COLOR_ZOMBIE)
	
	# Рисуем НПС
	if show_npcs:
		var npcs = get_tree().get_nodes_in_group("npcs")
		for npc in npcs:
			if npc.global_position.distance_to(player.global_position) < 300:
				var pos = _world_to_minimap(npc.global_position)
				var color = COLOR_NPC_NEUTRAL
				if npc.has_method("npc_type"):
					match npc.npc_type:
						0: color = COLOR_NPC_FRIENDLY  # FRIENDLY
						1: color = COLOR_NPC_NEUTRAL   # NEUTRAL
						2: color = COLOR_NPC_HOSTILE   # HOSTILE
				draw_circle(pos, 3, color)
	
	# Рисуем точки интереса
	if show_points_of_interest:
		var pois = get_tree().get_nodes_in_group("points_of_interest")
		for poi in pois:
			if poi.global_position.distance_to(player.global_position) < 400:
				var pos = _world_to_minimap(poi.global_position)
				draw_rect(Rect2(pos - Vector2(3, 3), Vector2(6, 6)), COLOR_POI)

func _draw_player():
	var player = GameManager.player
	if not player:
		return
	
	var center = minimap_size / 2
	
	# Игрок всегда в центре
	draw_circle(center, 4, COLOR_PLAYER)
	
	# Направление взгляда
	var direction = player.facing_direction if "facing_direction" in player else Vector2.DOWN
	var arrow_end = center + direction * 8
	draw_line(center, arrow_end, COLOR_PLAYER, 2)

func _world_to_minimap(world_pos: Vector2) -> Vector2:
	var player = GameManager.player
	if not player:
		return minimap_size / 2
	
	var offset = world_pos - player.global_position
	var center = minimap_size / 2
	
	return center + offset * zoom_level * 0.5

func _minimap_to_world(minimap_pos: Vector2) -> Vector2:
	var player = GameManager.player
	if not player:
		return Vector2.ZERO
	
	var center = minimap_size / 2
	var offset = (minimap_pos - center) / (zoom_level * 0.5)
	
	return player.global_position + offset

# Обновить исследованные области
func update_exploration():
	var player = GameManager.player
	if not player:
		return
	
	var cell_x = int(player.global_position.x / cell_size)
	var cell_y = int(player.global_position.y / cell_size)
	
	# Помечаем текущую и соседние клетки как исследованные
	for x in range(-2, 3):
		for y in range(-2, 3):
			var key = Vector2(cell_x + x, cell_y + y)
			explored_cells[key] = true

# Установить зум
func set_zoom(zoom: float):
	zoom_level = clamp(zoom, 0.5, 3.0)
	queue_redraw()

# Очистить исследованные области
func clear_exploration():
	explored_cells.clear()

# Сериализация
func serialize() -> Dictionary:
	return {
		"explored_cells": explored_cells,
		"zoom": zoom_level
	}

# Десериализация
func deserialize(data: Dictionary):
	explored_cells = data.get("explored_cells", {})
	zoom_level = data.get("zoom", 1.0)
