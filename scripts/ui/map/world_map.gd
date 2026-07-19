extends Control
class_name WorldMap

# WorldMap - полная карта мира
# Показывает всю карту, исследованные области, точки интереса

signal map_closed
signal location_selected(position)

@onready var map_texture: TextureRect = $Panel/MapTexture
@onready var map_scroll: ScrollContainer = $Panel/MapScroll
@onready var close_button: Button = $Panel/CloseButton
@onready var zoom_slider: HSlider = $Panel/ZoomSlider

# Настройки карты
var map_size: Vector2 = Vector2(2000, 2000)
var zoom_level: float = 1.0
var is_dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO

# Иконки на карте
var map_markers: Array[Dictionary] = []  # {position, type, name}

func _ready():
	visible = false
	close_button.connect("pressed", _on_close)
	zoom_slider.connect("value_changed", _on_zoom_changed)
	print("[WorldMap] Initialized")

func open():
	visible = true
	get_tree().paused = true
	_update_map_markers()
	queue_redraw()

func close():
	visible = false
	get_tree().paused = false
	emit_signal("map_closed")

func _draw():
	_draw_terrain()
	_draw_exploration()
	_draw_markers()
	_draw_player_position()

func _draw_terrain():
	# Рисуем базовый террейн
	var terrain_colors = {
		"grass": Color(0.3, 0.6, 0.2),
		"dirt": Color(0.5, 0.4, 0.2),
		"water": Color(0.2, 0.4, 0.7),
		"road": Color(0.4, 0.4, 0.4),
		"forest": Color(0.1, 0.4, 0.1)
	}
	
	# Здесь будет отрисовка террейна из данных мира
	# Пока рисуем заглушку
	draw_rect(Rect2(Vector2.ZERO, map_size * zoom_level), Color(0.3, 0.5, 0.2))

func _draw_exploration():
	# Рисуем исследованные области
	var minimap = get_viewport().get_node_or_null("HUD/Minimap")
	if minimap and minimap.has_method("explored_cells"):
		for cell_pos in minimap.explored_cells:
			var screen_pos = _world_to_map(Vector2(cell_pos.x * 64, cell_pos.y * 64))
			draw_rect(Rect2(screen_pos, Vector2(4, 4) * zoom_level), Color(1, 1, 1, 0.3))

func _draw_markers():
	for marker in map_markers:
		var screen_pos = _world_to_map(marker.position)
		var color = Color.WHITE
		var size = 8.0
		
		match marker.type:
			"player":
				color = Color.GREEN
				size = 10.0
			"npc_friendly":
				color = Color.BLUE
				size = 6.0
			"npc_hostile":
				color = Color.RED
				size = 6.0
			"zombie":
				color = Color(0.5, 0, 0)
				size = 4.0
			"poi":
				color = Color.ORANGE
				size = 8.0
			"base":
				color = Color.CYAN
				size = 10.0
		
		draw_circle(screen_pos, size, color)
		
		# Подпись
		if marker.has("name"):
			# В Godot 4 нет прямого метода для рисования текста в _draw
			# Используем Label для подписей
			pass

func _draw_player_position():
	var player = GameManager.player
	if not player:
		return
	
	var screen_pos = _world_to_map(player.global_position)
	
	# Игрок - зелёная стрелка
	draw_circle(screen_pos, 8, Color.GREEN)
	
	# Направление
	var direction = player.facing_direction if "facing_direction" in player else Vector2.DOWN
	var arrow_end = screen_pos + direction * 15
	draw_line(screen_pos, arrow_end, Color.GREEN, 3)

func _world_to_map(world_pos: Vector2) -> Vector2:
	return world_pos * zoom_level * 0.1

func _map_to_world(map_pos: Vector2) -> Vector2:
	return map_pos / (zoom_level * 0.1)

func _update_map_markers():
	map_markers.clear()
	
	var player = GameManager.player
	if not player:
		return
	
	# Игрок
	map_markers.append({
		"position": player.global_position,
		"type": "player",
		"name": "Вы"
	})
	
	# НПС
	var npcs = get_tree().get_nodes_in_group("npcs")
	for npc in npcs:
		if npc.global_position.distance_to(player.global_position) < 500:
			var type_str = "npc_neutral"
			if npc.has_method("npc_type"):
				match npc.npc_type:
					0: type_str = "npc_friendly"
					1: type_str = "npc_neutral"
					2: type_str = "npc_hostile"
			map_markers.append({
				"position": npc.global_position,
				"type": type_str,
				"name": npc.npc_name
			})
	
	# Зомби
	var zombies = get_tree().get_nodes_in_group("zombies")
	for zombie in zombies:
		if zombie.global_position.distance_to(player.global_position) < 300:
			map_markers.append({
				"position": zombie.global_position,
				"type": "zombie",
				"name": ""
			})
	
	# Точки интереса
	var pois = get_tree().get_nodes_in_group("points_of_interest")
	for poi in pois:
		map_markers.append({
			"position": poi.global_position,
			"type": "poi",
			"name": poi.name if "name" in poi else "Точка интереса"
		})

func _on_close():
	close()

func _on_zoom_changed(value: float):
	zoom_level = value
	queue_redraw()

func _input(event):
	if not visible:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_start = event.position
			else:
				is_dragging = false
		
		# Зум колесом мыши
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			set_zoom(zoom_level + 0.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			set_zoom(zoom_level - 0.1)
	
	if event is InputEventMouseMotion and is_dragging:
		# Перетаскивание карты
		pass
	
	if event.is_action_pressed("ui_cancel"):
		close()

func set_zoom(zoom: float):
	zoom_level = clamp(zoom, 0.5, 3.0)
	if zoom_slider:
		zoom_slider.value = zoom_level
	queue_redraw()

func add_marker(position: Vector2, type: String, name: String = ""):
	map_markers.append({
		"position": position,
		"type": type,
		"name": name
	})
	queue_redraw()

func clear_markers():
	map_markers.clear()
	queue_redraw()
