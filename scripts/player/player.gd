extends CharacterBody2D
class_name Player

# Player - контроллер игрока
# Управляет перемещением, здоровьем, инвентарём, выживанием

signal health_changed(new_health, max_health)
signal stamina_changed(new_stamina, max_stamina)
signal hunger_changed(new_hunger)
signal thirst_changed(new_thirst)
signal died

@export var max_health: float = 100.0
@export var max_stamina: float = 100.0
@export var move_speed: float = 150.0
@export var sprint_speed: float = 250.0
@export var sprint_stamina_drain: float = 15.0
@export var attack_damage: float = 25.0
@export var attack_range: float = 50.0
@export var attack_cooldown: float = 0.5

var health: float
var stamina: float
var hunger: float = 100.0
var thirst: float = 100.0
var is_sprinting: bool = false
var is_attacking: bool = false
var last_attack_time: float = 0.0
var facing_direction: Vector2 = Vector2.DOWN

@onready var inventory: Inventory = $Inventory
@onready var attack_area: Area2D = $AttackArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	health = max_health
	stamina = max_stamina
	GameManager.player = self
	print("[Player] Player ready")

func _physics_process(delta):
	if not GameManager.is_playing():
		return
	
	_handle_input(delta)
	_handle_survival_stats(delta)
	_handle_attack_cooldown()
	move_and_slide()
	_update_animation()
	EventManager.emit_signal("player_moved", global_position)

func _handle_input(delta):
	var input_dir = Vector2.ZERO
	
	# Ввод движения
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_up", "move_down")
	input_dir = input_dir.normalized()
	
	# Спринт
	is_sprinting = Input.is_action_pressed("run") and stamina > 0 and input_dir != Vector2.ZERO
	
	# Установка скорости
	var speed = sprint_speed if is_sprinting else move_speed
	velocity = input_dir * speed
	
	# Направление взгляда (для атаки)
	if input_dir != Vector2.ZERO:
		facing_direction = input_dir
	
	# Атака
	if Input.is_action_just_pressed("attack"):
		_try_attack()
	
	# Взаимодействие
	if Input.is_action_just_pressed("interact"):
		_try_interact()
	
	# Инвентарь
	if Input.is_action_just_pressed("inventory"):
		EventManager.emit_signal("toggle_inventory")
	
	# Крафт
	if Input.is_action_just_pressed("craft"):
		EventManager.emit_signal("toggle_crafting")

func _handle_survival_stats(delta):
	# Расход стамины при спринте
	if is_sprinting:
		stamina = max(0, stamina - sprint_stamina_drain * delta)
		emit_signal("stamina_changed", stamina, max_stamina)
	
	# Восстановление стамины
	elif stamina < max_stamina:
		stamina = min(max_stamina, stamina + 10.0 * delta)
		emit_signal("stamina_changed", stamina, max_stamina)
	
	# Голод (уменьшается со временем)
	hunger = max(0, hunger - 0.5 * delta)
	emit_signal("hunger_changed", hunger)
	
	# Жажда (уменьшается быстрее)
	thirst = max(0, thirst - 0.8 * delta)
	emit_signal("thirst_changed", thirst)
	
	# Урон от голода/жажды
	if hunger <= 0:
		_take_damage(2.0 * delta)
	if thirst <= 0:
		_take_damage(3.0 * delta)

func _handle_attack_cooldown():
	if is_attacking:
		if Time.get_time_dict_from_system().second - last_attack_time > attack_cooldown:
			is_attacking = false

func _try_attack():
	if is_attacking:
		return
	
	is_attacking = true
	last_attack_time = Time.get_time_dict_from_system().second
	
	# Анимация атаки
	if animation_player.has_animation("attack"):
		animation_player.play("attack")
	
	# Поиск зомби в зоне атаки
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("zombies"):
			body.take_damage(attack_damage)
			print("[Player] Hit zombie for %.1f damage" % attack_damage)
			break

func _try_interact():
	# Поиск объектов для взаимодействия
	var areas = get_tree().get_nodes_in_group("interactables")
	for area in areas:
		if area.global_position.distance_to(global_position) < 60.0:
			if area.has_method("interact"):
				area.interact(self)
				break

func _take_damage(amount: float):
	health = max(0, health - amount)
	emit_signal("health_changed", health, max_health)
	
	if health <= 0:
		_die()

func heal(amount: float):
	health = min(max_health, health + amount)
	emit_signal("health_changed", health, max_health)

func feed(amount: float):
	hunger = min(100.0, hunger + amount)
	emit_signal("hunger_changed", hunger)

func drink(amount: float):
	thirst = min(100.0, thirst + amount)
	emit_signal("thirst_changed", thirst)

func _die():
	print("[Player] Player died!")
	emit_signal("died")
	EventManager.emit_signal("player_died")
	GameManager.end_game()

func _update_animation():
	if animation_player == null:
		return
	
	if is_attacking:
		return  # Анимация атаки уже играет
	
	if velocity.length() > 10.0:
		# Определяем направление для анимации
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animation_player.play("walk_right")
			else:
				animation_player.play("walk_left")
		else:
			if velocity.y > 0:
				animation_player.play("walk_down")
			else:
				animation_player.play("walk_up")
		# Ускоряем анимацию при спринте
		if is_sprinting:
			animation_player.speed_scale = 1.5
		else:
			animation_player.speed_scale = 1.0
	else:
		animation_player.play("idle")

func get_state() -> Dictionary:
	return {
		"health": health,
		"stamina": stamina,
		"hunger": hunger,
		"thirst": thirst,
		"position": {"x": position.x, "y": position.y}
	}
