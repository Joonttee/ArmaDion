extends Node2D
class_name ZombieSpawner

# ZombieSpawner - спавнер зомби
# Управляет появлением зомби в мире

@export var max_zombies: int = 50
@export var spawn_radius: float = 400.0
@export var min_spawn_distance: float = 200.0
@export var spawn_interval: float = 5.0
@export var zombie_scene: PackedScene

var spawn_timer: float = 0.0
var current_zombies: int = 0

func _ready():
	if zombie_scene == null:
		print("[ZombieSpawner] Warning: No zombie scene assigned!")
	_process(0)  # Начальный спавн

func _process(delta):
	if not GameManager.is_playing():
		return
	
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_try_spawn()

func _try_spawn():
	if current_zombies >= max_zombies:
		return
	
	var player = GameManager.player
	if player == null:
		return
	
	# Случайная позиция вокруг игрока
	var angle = randf() * 2 * PI
	var distance = min_spawn_distance + randf() * (spawn_radius - min_spawn_distance)
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * distance
	
	_spawn_zombie(spawn_pos)

func _spawn_zombie(position: Vector2):
	if zombie_scene == null:
		return
	
	var zombie = zombie_scene.instantiate()
	zombie.global_position = position
	add_child(zombie)
	current_zombies += 1
	
	zombie.died.connect(_on_zombie_died)
	print("[ZombieSpawner] Zombie spawned at %s" % position)

func _on_zombie_died(zombie):
	current_zombies -= 1

func set_zombie_scene(scene: PackedScene):
	zombie_scene = scene
