extends CharacterBody2D
class_name Zombie

# Zombie - искусственный интеллект зомби
# Поведение: патрулирование, преследование игрока, атака

enum State { IDLE, WANDER, CHASE, ATTACK, DEAD }

signal died(zombie)

@export var max_health: float = 50.0
@export var move_speed: float = 60.0
@export var chase_speed: float = 100.0
@export var attack_damage: float = 10.0
@export var attack_range: float = 40.0
@export var detection_range: float = 200.0
@export var attack_cooldown: float = 1.0

var health: float
var current_state: State = State.IDLE
var target: Node2D = null
var wander_target: Vector2 = Vector2.ZERO
var last_attack_time: float = 0.0
var wander_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $AttackArea
@onready var detection_area: Area2D = $DetectionArea

func _ready():
	health = max_health
	add_to_group("zombies")
	_change_state(State.IDLE)
	print("[Zombie] Zombie spawned")

func _physics_process(delta):
	if current_state == State.DEAD:
		return
	
	_update_state(delta)
	_execute_state(delta)
	move_and_slide()
	_update_animation()

func _update_state(delta):
	var player = GameManager.player
	if player == null:
		_change_state(State.IDLE)
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	match current_state:
		State.IDLE:
			if distance_to_player < detection_range:
				_change_state(State.CHASE)
			else:
				wander_timer += delta
				if wander_timer > 3.0:
					_change_state(State.WANDER)
		
		State.WANDER:
			if distance_to_player < detection_range:
				_change_state(State.CHASE)
			elif global_position.distance_to(wander_target) < 10.0:
				wander_timer = 0.0
				_change_state(State.IDLE)
		
		State.CHASE:
			if distance_to_player <= attack_range:
				_change_state(State.ATTACK)
			elif distance_to_player > detection_range * 1.5:
				_change_state(State.IDLE)
		
		State.ATTACK:
			if distance_to_player > attack_range * 1.2:
				_change_state(State.CHASE)

func _execute_state(delta):
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
		
		State.WANDER:
			if wander_target == Vector2.ZERO:
				_pick_wander_target()
			var direction = (wander_target - global_position).normalized()
			velocity = direction * (move_speed * 0.5)
		
		State.CHASE:
			if target:
				var direction = (target.global_position - global_position).normalized()
				velocity = direction * chase_speed
			else:
				velocity = Vector2.ZERO
		
		State.ATTACK:
			velocity = Vector2.ZERO
			_try_attack()

func _pick_wander_target():
	var random_offset = Vector2(
		randi() % 200 - 100,
		randi() % 200 - 100
	)
	wander_target = global_position + random_offset

func _try_attack():
	var current_time = Time.get_time_dict_from_system().second
	if current_time - last_attack_time < attack_cooldown:
		return
	
	last_attack_time = current_time
	
	# Анимация атаки
	if animation_player and animation_player.has_animation("attack"):
		animation_player.play("attack")
	
	# Нанесение урона игроку
	var player = GameManager.player
	if player and player.global_position.distance_to(global_position) <= attack_range:
		player._take_damage(attack_damage)
		EventManager.emit_signal("zombie_attacked", self, player)
		print("[Zombie] Hit player for %.1f damage" % attack_damage)

func _change_state(new_state: State):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match new_state:
		State.CHASE:
			target = GameManager.player
			EventManager.emit_signal("zombie_alerted", global_position)
		State.WANDER:
			_pick_wander_target()
		State.IDLE:
			wander_target = Vector2.ZERO
		State.ATTACK:
			pass

func take_damage(amount: float):
	if current_state == State.DEAD:
		return
	
	health -= amount
	print("[Zombie] Took %.1f damage, health: %.1f" % [amount, health])
	
	# Зомби всегда переходит в состояние преследования при получении урона
	if current_state != State.CHASE and current_state != State.ATTACK:
		_change_state(State.CHASE)
	
	if health <= 0:
		_die()

func _die():
	_change_state(State.DEAD)
	emit_signal("died", self)
	EventManager.emit_signal("zombie_died", self)
	print("[Zombie] Zombie died")
	
	# Удаление после анимации
	if animation_player and animation_player.has_animation("die"):
		animation_player.play("die")
		await animation_player.animation_finished
	
	queue_free()

func _update_animation():
	if animation_player == null or current_state == State.DEAD:
		return
	
	match current_state:
		State.IDLE:
			animation_player.play("idle")
		State.WANDER, State.CHASE:
			animation_player.play("walk")
		State.ATTACK:
			pass  # Анимация атаки вызывается отдельно
