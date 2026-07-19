extends CharacterBody2D
class_name NPC

# NPC - неигровой персонаж
# Может быть дружественным, нейтральным или враждебным

enum Type { FRIENDLY, NEUTRAL, HOSTILE }
enum State { IDLE, WANDER, TALKING, TRADING, FLEEING, ATTACKING }
enum Profession { NONE, TRADER, GUARD, DOCTOR, FARMER, MECHANIC }

signal npc_interacted(npc)
signal npc_attacked(npc)
signal npc_died(npc)

@export var npc_id: String = ""
@export var npc_name: String = "NPC"
@export var npc_type: Type = Type.NEUTRAL
@export var npc_profession: Profession = Profession.NONE
@export var faction_id: String = ""
@export var health: float = 100.0
@export var max_health: float = 100.0
@export var move_speed: float = 80.0
@export var attack_damage: float = 15.0
@export var attack_range: float = 40.0
@export var detection_range: float = 150.0
@export var dialogue_lines: Array[String] = []
@export var can_trade: bool = false

var current_state: State = State.IDLE
var target: Node2D = null
var wander_target: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
var is_dead: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_area: Area2D = $AttackArea

func _ready():
	add_to_group("npcs")
	_setup_npc()
	print("[NPC] NPC spawned: %s" % npc_name)

func _setup_npc():
	# Настройка по типу
	match npc_type:
		Type.FRIENDLY:
			modulate = Color(0.7, 1.0, 0.7)
		Type.NEUTRAL:
			modulate = Color(1.0, 1.0, 1.0)
		Type.HOSTILE:
			modulate = Color(1.0, 0.5, 0.5)
	
	# Настройка по профессии
	match npc_profession:
		Profession.TRADER:
			can_trade = true
		Profession.GUARD:
			attack_damage *= 1.5
			max_health *= 1.3
			health = max_health
		Profession.DOCTOR:
			can_trade = true

func _physics_process(delta):
	if is_dead:
		return
	
	_update_state(delta)
	_execute_state(delta)
	move_and_slide()

func _update_state(delta):
	var player = GameManager.player
	if not player:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	match current_state:
		State.IDLE:
			wander_timer += delta
			if wander_timer > 3.0:
				_change_state(State.WANDER)
			
			if distance_to_player < detection_range:
				if npc_type == Type.HOSTILE:
					_change_state(State.ATTACKING)
				elif npc_type == Type.FRIENDLY:
					_face_target(player.global_position)
		
		State.WANDER:
			if global_position.distance_to(wander_target) < 10.0:
				wander_timer = 0.0
				_change_state(State.IDLE)
			
			if distance_to_player < detection_range and npc_type == Type.HOSTILE:
				_change_state(State.ATTACKING)
		
		State.ATTACKING:
			if distance_to_player > detection_range * 1.5:
				_change_state(State.IDLE)
			elif distance_to_player <= attack_range:
				_try_attack()
		
		State.FLEEING:
			if distance_to_player > detection_range * 2.0:
				_change_state(State.IDLE)
		
		State.TALKING, State.TRADING:
			velocity = Vector2.ZERO
			if distance_to_player > 100.0:
				_change_state(State.IDLE)

func _execute_state(delta):
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
		
		State.WANDER:
			if wander_target == Vector2.ZERO:
				_pick_wander_target()
			var direction = (wander_target - global_position).normalized()
			velocity = direction * (move_speed * 0.5)
		
		State.ATTACKING:
			if target:
				var direction = (target.global_position - global_position).normalized()
				velocity = direction * move_speed
		
		State.FLEEING:
			if target:
				var direction = (global_position - target.global_position).normalized()
				velocity = direction * move_speed

func _pick_wander_target():
	var random_offset = Vector2(
		randi() % 200 - 100,
		randi() % 200 - 100
	)
	wander_target = global_position + random_offset

func _face_target(target_pos: Vector2):
	if sprite:
		if target_pos.x < global_position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

func _try_attack():
	var player = GameManager.player
	if not player:
		return
	
	if player.global_position.distance_to(global_position) <= attack_range:
		player._take_damage(attack_damage)
		EventManager.emit_signal("npc_attacked", self)
		print("[NPC] %s attacked player for %.1f damage" % [npc_name, attack_damage])

func _change_state(new_state: State):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match new_state:
		State.WANDER:
			_pick_wander_target()
		State.ATTACKING:
			target = GameManager.player
		State.IDLE:
			wander_target = Vector2.ZERO

func take_damage(amount: float):
	if is_dead:
		return
	
	health -= amount
	print("[NPC] %s took %.1f damage, health: %.1f" % [npc_name, amount, health])
	
	# Нейтральные и дружественные НПС становятся враждебными при атаке
	if npc_type != Type.HOSTILE and not is_dead:
		npc_type = Type.HOSTILE
		modulate = Color(1.0, 0.5, 0.5)
		_change_state(State.ATTACKING)
	
	if health <= 0:
		_die()

func _die():
	is_dead = true
	emit_signal("npc_died", self)
	print("[NPC] %s died" % npc_name)
	
	# Удаление после анимации
	await get_tree().create_timer(2.0).timeout
	queue_free()

func interact(player: Node2D):
	if is_dead:
		return
	
	emit_signal("npc_interacted", self)
	
	match npc_type:
		Type.FRIENDLY, Type.NEUTRAL:
			if can_trade:
				_change_state(State.TRADING)
				EventManager.emit_signal("open_npc_trade", self)
			else:
				_change_state(State.TALKING)
				_show_dialogue()
		Type.HOSTILE:
			_change_state(State.ATTACKING)

func _show_dialogue():
	if dialogue_lines.size() > 0:
		var line = dialogue_lines[randi() % dialogue_lines.size()]
		EventManager.emit_signal("show_npc_dialogue", self, line)
		print("[NPC] %s: %s" % [npc_name, line])

func get_dialogue_line() -> String:
	if dialogue_lines.size() > 0:
		return dialogue_lines[randi() % dialogue_lines.size()]
	return "..."

func get_faction() -> String:
	return faction_id

func update_faction_standing():
	# Обновляет поведение в зависимости от отношений фракции с игроком
	var faction = FactionManager.get_faction(faction_id)
	if faction:
		var relation = faction.get_relation()
		match relation:
			NPCFaction.Relation.HOSTILE:
				npc_type = Type.HOSTILE
				modulate = Color(1.0, 0.5, 0.5)
			NPCFaction.Relation.UNFRIENDLY:
				npc_type = Type.HOSTILE
				modulate = Color(1.0, 0.7, 0.7)
			NPCFaction.Relation.NEUTRAL:
				npc_type = Type.NEUTRAL
				modulate = Color(1.0, 1.0, 1.0)
			NPCFaction.Relation.FRIENDLY:
				npc_type = Type.FRIENDLY
				modulate = Color(0.7, 1.0, 0.7)
			NPCFaction.Relation.ALLIED:
				npc_type = Type.FRIENDLY
				modulate = Color(0.5, 1.0, 0.5)

func serialize() -> Dictionary:
	return {
		"npc_id": npc_id,
		"npc_name": npc_name,
		"npc_type": npc_type,
		"faction_id": faction_id,
		"health": health,
		"position": {"x": position.x, "y": position.y}
	}
