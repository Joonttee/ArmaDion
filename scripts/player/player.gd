extends CharacterBody2D
class_name Player

# Player - оптимизированный контроллер игрока

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

# Системы
var skill_set: SkillSet
var trait_set: TraitSet
var mutation_system: Mutation
var equipment_manager: EquipmentManager = null

# Эффективные характеристики (кэширование)
var effective_max_health: float
var effective_max_stamina: float
var effective_move_speed: float
var effective_sprint_speed: float
var effective_attack_damage: float

# Кэш для производительности
var _cached_trait_effects: Dictionary = {}
var _effects_dirty: bool = true

@onready var inventory: Inventory = $Inventory
@onready var attack_area: Area2D = $AttackArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	_initialize_systems()
	_update_effective_stats()
	
	# Get equipment manager from scene
	if has_node("EquipmentManager"):
		equipment_manager = get_node("EquipmentManager")
	
	GameManager.player = self
	print("[Player] Ready")

func _initialize_systems():
	health = max_health
	stamina = max_stamina
	skill_set = SkillSet.new()
	trait_set = TraitSet.new()
	mutation_system = Mutation.new()
	
	effective_max_health = max_health
	effective_max_stamina = max_stamina
	effective_move_speed = move_speed
	effective_sprint_speed = sprint_speed
	effective_attack_damage = attack_damage

func _physics_process(delta):
	if not GameManager.is_playing():
		return
	
	_handle_input(delta)
	_handle_survival_stats(delta)
	_handle_attack_cooldown()
	move_and_slide()
	_update_animation()

func _handle_input(delta):
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_up", "move_down")
	input_dir = input_dir.normalized()
	
	is_sprinting = Input.is_action_pressed("run") and stamina > 0 and input_dir != Vector2.ZERO
	velocity = input_dir * (sprint_speed if is_sprinting else move_speed)
	
	if input_dir != Vector2.ZERO:
		facing_direction = input_dir
	
	# Обработка действий
	if Input.is_action_just_pressed("attack"):
		_try_attack()
	elif Input.is_action_just_pressed("interact"):
		_try_interact()
	elif Input.is_action_just_pressed("inventory"):
		EventManager.emit_signal("toggle_inventory")
	elif Input.is_action_just_pressed("craft"):
		EventManager.emit_signal("toggle_crafting")
	elif Input.is_action_just_pressed("build"):
		EventManager.emit_signal("toggle_building_menu")
	elif Input.is_action_just_pressed("farm"):
		EventManager.emit_signal("toggle_farming_menu")
	elif Input.is_action_just_pressed("skills"):
		EventManager.emit_signal("toggle_skills_display")
	elif Input.is_action_just_pressed("mutations"):
		EventManager.emit_signal("toggle_mutation_display")
	elif Input.is_action_just_pressed("map"):
		EventManager.emit_signal("toggle_world_map")
	elif Input.is_action_just_pressed("squad"):
		EventManager.emit_signal("toggle_squad_ui")

func _handle_survival_stats(delta):
	# Стамина
	if is_sprinting:
		stamina = max(0, stamina - sprint_stamina_drain * delta)
	elif stamina < effective_max_stamina:
		stamina = min(effective_max_stamina, stamina + 10.0 * delta)
	
	# Голод и жажда
	hunger = max(0, hunger - 0.5 * delta)
	thirst = max(0, thirst - 0.8 * delta)
	
	# Урон от голода
	if hunger <= 0:
		_take_damage(2.0 * delta)
	if thirst <= 0:
		_take_damage(3.0 * delta)

func _handle_attack_cooldown():
	if is_attacking and Time.get_time_dict_from_system().second - last_attack_time > attack_cooldown:
		is_attacking = false

func _try_attack():
	if is_attacking:
		return
	
	is_attacking = true
	last_attack_time = Time.get_time_dict_from_system().second
	
	if animation_player.has_animation("attack"):
		animation_player.play("attack")
	
	gain_skill_xp("melee", 5.0)
	gain_skill_xp("athletics", 1.0)
	
	# Атака зомби
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("zombies"):
			var damage = effective_attack_damage * (1.0 + get_skill_bonus("melee"))
			body.take_damage(damage)
			break

func _try_interact():
	var npc = NPCManager.get_nearest_npc(global_position, 60.0)
	if npc:
		npc.interact(self)
		return
	
	for area in get_tree().get_nodes_in_group("interactables"):
		if area.global_position.distance_to(global_position) < 60.0:
			if area.has_method("interact"):
				area.interact(self)
				break

func _take_damage(amount: float):
	health = max(0, health - amount)
	emit_signal("health_changed", health, effective_max_health)
	if health <= 0:
		_die()

func _die():
	emit_signal("died")
	EventManager.emit_signal("player_died")
	GameManager.end_game()

func _update_animation():
	if not animation_player or is_attacking:
		return
	
	if velocity.length() > 10.0:
		var anim = "walk_" + ("right" if velocity.x > 0 else "left") if abs(velocity.x) > abs(velocity.y) else "walk_" + ("down" if velocity.y > 0 else "up")
		animation_player.play(anim)
		animation_player.speed_scale = 1.5 if is_sprinting else 1.0
	else:
		animation_player.play("idle")

# === СИСТЕМА НАВЫКОВ ===

func _update_effective_stats():
	if _effects_dirty:
		_cached_trait_effects = trait_set.get_combined_effects() if trait_set else {}
		_effects_dirty = false
	
	var effects = _cached_trait_effects
	var equipment_bonus = equipment_manager.get_equipment_bonuses() if equipment_manager else {}
	
	effective_max_health = max_health + effects.get("max_health_bonus", 0.0) + equipment_bonus.get("defense", 0.0) * 2.0
	effective_max_stamina = max_stamina + effects.get("stamina_bonus", 0.0)
	
	var speed_mult = 1.0 + effects.get("move_speed_bonus", 0.0)
	effective_move_speed = move_speed * speed_mult - equipment_bonus.get("weight", 0.0) * 2.0
	effective_sprint_speed = sprint_speed * speed_mult - equipment_bonus.get("weight", 0.0) * 3.0
	
	effective_attack_damage = attack_damage * (1.0 + effects.get("melee_damage_bonus", 0.0))

func gain_skill_xp(skill_id: String, amount: float):
	if not skill_set:
		return
	
	var final_amount = amount * _cached_trait_effects.get("xp_multiplier", 1.0)
	skill_set.add_xp(skill_id, final_amount)

func get_skill_bonus(skill_id: String) -> float:
	return skill_set.get_level_bonus(skill_id) if skill_set else 0.0

# === СИСТЕМА МУТАЦИЙ ===

func gain_mutation(mutation_id: String, source: int = 0) -> bool:
	if mutation_system and mutation_system.gain_mutation(mutation_id, source):
		return true
	return false

func add_radiation(amount: float):
	if mutation_system:
		mutation_system.add_radiation(amount)

func process_bite():
	if mutation_system:
		mutation_system.process_bite()

func get_mutation_system() -> Mutation:
	return mutation_system

func has_mutation(mutation_id: String) -> bool:
	return mutation_system.has_mutation(mutation_id) if mutation_system else false

# === СИСТЕМА ЭКИПИРОВКИ ===

func equip_item(item: Item) -> bool:
	if equipment_manager:
		return equipment_manager.equip_item(item)
	return false

func unequip_slot(slot: Equipment.Slot):
	if equipment_manager:
		equipment_manager.unequip_slot(slot)
		_update_effective_stats()

func get_equipped_item(slot: Equipment.Slot) -> Item:
	if equipment_manager:
		return equipment_manager.get_equipped_item(slot)
	return null

func get_equipment_defense() -> float:
	if equipment_manager:
		return equipment_manager.get_total_defense()
	return 0.0

func get_equipment_warmth() -> float:
	if equipment_manager:
		return equipment_manager.get_total_warmth()
	return 0.0

# === УТИЛИТЫ ===

func heal(amount: float):
	health = min(effective_max_health, health + amount)
	emit_signal("health_changed", health, effective_max_health)

func feed(amount: float):
	hunger = min(100.0, hunger + amount)
	emit_signal("hunger_changed", hunger)

func drink(amount: float):
	thirst = min(100.0, thirst + amount)
	emit_signal("thirst_changed", thirst)

func get_state() -> Dictionary:
	return {
		"health": health,
		"stamina": stamina,
		"hunger": hunger,
		"thirst": thirst,
		"position": {"x": position.x, "y": position.y}
	}
