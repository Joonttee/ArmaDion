extends CharacterBody2D
class_name Zombie

# Zombie - оптимизированный ИИ зомби

signal died(zombie)
signal zombie_alerted(position)

enum State { IDLE, WANDER, CHASE, ATTACK, DEAD }
enum ZombieType { NORMAL, RUNNER, TANK, SPITTER, SCREAMER }

@export var zombie_type: ZombieType = ZombieType.NORMAL
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

# Модификаторы
var time_speed_modifier: float = 1.0
var time_detection_modifier: float = 1.0
var weather_speed_modifier: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $AttackArea
@onready var detection_area: Area2D = $DetectionArea

func _ready():
	_setup_zombie_type()
	health = max_health
	add_to_group("zombies")
	_change_state(State.IDLE)

func _setup_zombie_type():
	match zombie_type:
		ZombieType.NORMAL:
			pass  # Значения по умолчанию
		ZombieType.RUNNER:
			max_health = 30.0
			move_speed = 120.0
			chase_speed = 180.0
			modulate = Color(0.8, 0.9, 0.8)
		ZombieType.TANK:
			max_health = 150.0
			move_speed = 40.0
			chase_speed = 60.0
			attack_damage = 25.0
			attack_range = 50.0
			modulate = Color(0.6, 0.6, 0.6)
			scale = Vector2(1.3, 1.3)
		ZombieType.SPITTER:
			max_health = 40.0
			move_speed = 50.0
			chase_speed = 80.0
			attack_damage = 15.0
			attack_range = 120.0
			detection_range = 250.0
			modulate = Color(0.7, 1.0, 0.7)
		ZombieType.SCREAMER:
			max_health = 35.0
			move_speed = 70.0
			chase_speed = 110.0
			detection_range = 300.0
			modulate = Color(1.0, 0.7, 1.0)

func _physics_process(delta):
	if current_state == State.DEAD:
		return
	
	_update_state(delta)
	_execute_state(delta)
	move_and_slide()
	_update_animation()

func _update_state(delta):
	var player = GameManager.player
	if not player:
		_change_state(State.IDLE)
		return
	
	var distance = global_position.distance_to(player.global_position)
	var effective_detection = detection_range * time_detection_modifier
	
	match current_state:
		State.IDLE:
			if distance < effective_detection:
				_change_state(State.CHASE)
			else:
				wander_timer += delta
				if wander_timer > 3.0:
					_change_state(State.WANDER)
		
		State.WANDER:
			if distance < effective_detection:
				_change_state(State.CHASE)
			elif global_position.distance_to(wander_target) < 10.0:
				wander_timer = 0.0
				_change_state(State.IDLE)
		
		State.CHASE:
			if distance <= attack_range:
				_change_state(State.ATTACK)
			elif distance > effective_detection * 1.5:
				_change_state(State.IDLE)
		
		State.ATTACK:
			if distance > attack_range * 1.2:
				_change_state(State.CHASE)

func _execute_state(delta):
	var speed_mod = time_speed_modifier * weather_speed_modifier
	
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
		
		State.WANDER:
			if wander_target == Vector2.ZERO:
				_pick_wander_target()
			velocity = (wander_target - global_position).normalized() * (move_speed * 0.5 * speed_mod)
		
		State.CHASE:
			if target:
				velocity = (target.global_position - global_position).normalized() * chase_speed * speed_mod
			else:
				velocity = Vector2.ZERO
		
		State.ATTACK:
			velocity = Vector2.ZERO
			_try_attack()

func _pick_wander_target():
	wander_target = global_position + Vector2(randi() % 200 - 100, randi() % 200 - 100)

func _try_attack():
	if Time.get_time_dict_from_system().second - last_attack_time < attack_cooldown:
		return
	
	last_attack_time = Time.get_time_dict_from_system().second
	
	if animation_player:
		animation_player.play("attack")
	
	var player = GameManager.player
	if not player:
		return
	
	var distance = player.global_position.distance_to(global_position)
	
	match zombie_type:
		ZombieType.SPITTER:
			if distance <= attack_range:
				player._take_damage(attack_damage)
				EventManager.emit_signal("zombie_attacked", self, player)
		ZombieType.SCREAMER:
			_alert_nearby_zombies()
			if distance <= attack_range:
				player._take_damage(attack_damage)
		_:
			if distance <= attack_range:
				player._take_damage(attack_damage)
				EventManager.emit_signal("zombie_attacked", self, player)

func _alert_nearby_zombies():
	for zombie in get_tree().get_nodes_in_group("zombies"):
		if zombie != self and zombie.global_position.distance_to(global_position) < 200:
			if zombie.current_state in [State.IDLE, State.WANDER]:
				zombie._change_state(State.CHASE)

func _change_state(new_state: State):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match new_state:
		State.CHASE:
			target = GameManager.player
			emit_signal("zombie_alerted", global_position)
		State.WANDER:
			_pick_wander_target()
		State.IDLE:
			wander_target = Vector2.ZERO

func take_damage(amount: float):
	if current_state == State.DEAD:
		return
	
	health -= amount
	
	if current_state not in [State.CHASE, State.ATTACK]:
		_change_state(State.CHASE)
	
	if health <= 0:
		_die()

func _die():
	current_state = State.DEAD
	emit_signal("died", self)
	EventManager.emit_signal("zombie_died", self)
	
	if animation_player:
		animation_player.play("die")
		await animation_player.animation_finished
	
	queue_free()

func _update_animation():
	if not animation_player or current_state == State.DEAD:
		return
	
	match current_state:
		State.IDLE:
			animation_player.play("idle")
		State.WANDER, State.CHASE:
			animation_player.play("walk")

func update_time_modifiers(modifiers: Dictionary):
	time_speed_modifier = modifiers.get("speed", 1.0)
	time_detection_modifier = modifiers.get("detection", 1.0)

func update_weather_modifier(speed_mod: float):
	weather_speed_modifier = speed_mod

func get_type() -> ZombieType:
	return zombie_type
