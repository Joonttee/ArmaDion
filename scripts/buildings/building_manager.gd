extends Node

# BuildingManager - менеджер строительства
# Управляет размещением и строительством объектов базы

signal piece_placed(piece)
signal piece_built(piece)
signal piece_destroyed(piece)
signal placement_valid(valid, position)
signal placement_mode_exited

var item_database: ItemDatabase
var is_placement_mode: bool = false
var current_piece_type: String = ""
var ghost_piece: Node2D = null
var placed_pieces: Array[BuildingPiece] = []
var grid_size: int = 32

@onready var building_layer: Node2D

func _ready():
	item_database = ItemDatabase.new()
	print("[BuildingManager] Initialized")

func start_placement(piece_type: String):
	current_piece_type = piece_type
	is_placement_mode = true
	_create_ghost_piece(piece_type)
	print("[BuildingManager] Placement mode started: %s" % piece_type)

func cancel_placement():
	is_placement_mode = false
	if ghost_piece:
		ghost_piece.queue_free()
		ghost_piece = null
	emit_signal("placement_mode_exited")
	print("[BuildingManager] Placement cancelled")

func confirm_placement():
	if not ghost_piece or not _is_valid_placement():
		return false
	
	# Создаём реальный объект
	var piece = _create_piece(current_piece_type)
	piece.position = ghost_piece.position
	piece.build()
	
	building_layer.add_child(piece)
	placed_pieces.append(piece)
	
	# Подключаем сигналы
	piece.connect("piece_destroyed", _on_piece_destroyed)
	
	emit_signal("piece_placed", piece)
	
	# Удаляем призрак
	ghost_piece.queue_free()
	ghost_piece = null
	is_placement_mode = false
	
	print("[BuildingManager] Piece placed: %s" % current_piece_type)
	return true

func _create_ghost_piece(piece_type: String):
	ghost_piece = Node2D.new()
	ghost_piece.name = "GhostPiece"
	
	# Визуальное представление призрака
	var sprite = Sprite2D.new()
	sprite.modulate = Color(0.5, 1.0, 0.5, 0.5)  # Полупрозрачный зелёный
	ghost_piece.add_child(sprite)
	
	building_layer.add_child(ghost_piece)

func _create_piece(piece_type: String) -> BuildingPiece:
	var piece: BuildingPiece
	
	match piece_type:
		"foundation":
			piece = preload("res://scenes/buildings/foundation.tscn").instantiate()
		"wall_wood":
			piece = preload("res://scenes/buildings/wall.tscn").instantiate()
			piece.wall_type = "wood"
		"wall_metal":
			piece = preload("res://scenes/buildings/wall.tscn").instantiate()
			piece.wall_type = "metal"
		"wall_brick":
			piece = preload("res://scenes/buildings/wall.tscn").instantiate()
			piece.wall_type = "brick"
		"door":
			piece = preload("res://scenes/buildings/door.tscn").instantiate()
		"storage":
			piece = preload("res://scenes/buildings/storage.tscn").instantiate()
		_:
			piece = preload("res://scenes/buildings/wall.tscn").instantiate()
	
	return piece

func _is_valid_placement() -> bool:
	if not ghost_piece:
		return false
	
	# Проверка коллизий с существующими объектами
	var space_state = get_tree().root.world_2d.space
	var query = PhysicsRayQueryParameters2D.create(
		ghost_piece.position,
		ghost_piece.position,
		0xFFFFFFFF
	)
	
	# Проверяем, что позиция не занята
	for piece in placed_pieces:
		if piece.position.distance_to(ghost_piece.position) < grid_size:
			return false
	
	return true

func _process(delta):
	if is_placement_mode and ghost_piece:
		_update_ghost_position()

func _update_ghost_position():
	# Привязка к сетке
	var mouse_pos = get_viewport().get_mouse_position()
	var snapped_x = snapped(mouse_pos.x, float(grid_size)) - grid_size / 2.0
	var snapped_y = snapped(mouse_pos.y, float(grid_size)) - grid_size / 2.0
	ghost_piece.position = Vector2(snapped_x, snapped_y)
	
	# Обновляем цвет в зависимости от валидности
	var sprite = ghost_piece.get_child(0) as Sprite2D
	if sprite:
		sprite.modulate = Color(0.5, 1.0, 0.5, 0.5) if _is_valid_placement() else Color(1.0, 0.5, 0.5, 0.5)

func _input(event):
	if not is_placement_mode:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			confirm_placement()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_placement()
	
	if event.is_action_pressed("ui_cancel"):
		cancel_placement()

func _on_piece_destroyed(piece: BuildingPiece):
	placed_pieces.erase(piece)
	emit_signal("piece_destroyed", piece)

func get_pieces_in_radius(position: Vector2, radius: float) -> Array[BuildingPiece]:
	var pieces: Array[BuildingPiece] = []
	for piece in placed_pieces:
		if piece.position.distance_to(position) <= radius:
			pieces.append(piece)
	return pieces

func get_total_health() -> float:
	var total = 0.0
	for piece in placed_pieces:
		total += piece.health
	return total

func serialize_data() -> Dictionary:
	var data = []
	for piece in placed_pieces:
		data.append(piece.serialize())
	return {"pieces": data}

func deserialize_data(data: Dictionary):
	# Очищаем существующие объекты
	for piece in placed_pieces:
		piece.queue_free()
	placed_pieces.clear()
	
	# Загружаем сохранённые
	for piece_data in data.get("pieces", []):
		var piece = _create_piece(piece_data.get("piece_id", "wall_wood"))
		piece.position = Vector2(piece_data.get("position", {}).get("x", 0), piece_data.get("position", {}).get("y", 0))
		building_layer.add_child(piece)
		piece.deserialize(piece_data)
		placed_pieces.append(piece)
		piece.connect("piece_destroyed", _on_piece_destroyed)
