extends Node2D
class_name NPCSpawner

# NPCSpawner - спавнер НПС
# Управляет появлением НПС в мире

@export var max_npcs: int = 10
@export var spawn_radius: float = 300.0
@export var min_spawn_distance: float = 150.0
@export var spawn_interval: float = 30.0

var spawn_timer: float = 0.0
var current_npcs: int = 0

# Типы НПС и их шансы появления
var spawn_weights = {
	"survivor": 30,
	"trader": 15,
	"guard": 20,
	"doctor": 10,
	"bandit": 25
}

func _ready():
	print("[NPCSpawner] Initialized")

func _process(delta):
	if not GameManager.is_playing():
		return
	
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_try_spawn()

func _try_spawn():
	if current_npcs >= max_npcs:
		return
	
	var player = GameManager.player
	if not player:
		return
	
	# Выбираем случайный тип НПС с учётом весов
	var npc_type = _get_random_npc_type()
	
	# Случайная позиция вокруг игрока
	var angle = randf() * 2 * PI
	var distance = min_spawn_distance + randf() * (spawn_radius - min_spawn_distance)
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * distance
	
	# Спавним НПС
	var npc = NPCManager.spawn_npc(npc_type, spawn_pos)
	if npc:
		current_npcs += 1
		npc.connect("npc_died", func(n): _on_npc_died())

func _get_random_npc_type() -> String:
	var total_weight = 0
	for weight in spawn_weights.values():
		total_weight += weight
	
	var random = randi() % total_weight
	var cumulative = 0
	
	for npc_type in spawn_weights:
		cumulative += spawn_weights[npc_type]
		if random < cumulative:
			return npc_type
	
	return "survivor"

func _on_npc_died():
	current_npcs -= 1

func set_max_npcs(max: int):
	max_npcs = max

func set_spawn_interval(interval: float):
	spawn_interval = interval
