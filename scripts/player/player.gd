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

# Система навыков и черт
var skill_set: SkillSet
var trait_set: TraitSet
var mutation_system: Mutation
var effective_max_health: float
var effective_max_stamina: float
var effective_move_speed: float
var effective_sprint_speed: float
var effective_attack_damage: float

@onready var inventory: Inventory = $Inventory
@onready var attack_area: Area2D = $AttackArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mutation_visuals: MutationVisualManager = $MutationVisualManager

func _ready():
	health = max_health
	stamina = max_stamina
	
	# Инициализация навыков и черт
	skill_set = SkillSet.new()
	trait_set = TraitSet.new()
	_apply_trait_effects()
	
	# Инициализация системы мутаций
	mutation_system = Mutation.new()
	_apply_mutation_effects()
	
	# Инициализация визуального менеджера мутаций
	if mutation_visuals:
		mutation_visuals.set_target_sprite(sprite)
		mutation_visuals.set_mutation_system(mutation_system)
	
	# Установка эффективных характеристик
	effective_max_health = max_health
	effective_max_stamina = max_stamina
	effective_move_speed = move_speed
	effective_sprint_speed = sprint_speed
	effective_attack_damage = attack_damage
	
	health = effective_max_health
	stamina = effective_max_stamina
	
	GameManager.player = self
	print("[Player] Player ready")
	print("[Player] Traits: %d positive, %d negative" % [trait_set.positive_traits.size(), trait_set.negative_traits.size()])

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
	
	# Строительство
	if Input.is_action_just_pressed("build"):
		EventManager.emit_signal("toggle_building_menu")
	
	# Фермерство
	if Input.is_action_just_pressed("farm"):
		EventManager.emit_signal("toggle_farming_menu")
	
	# Навыки и черты
	if Input.is_action_just_pressed("skills"):
		EventManager.emit_signal("toggle_skills_display")
	
	# Мутации
	if Input.is_action_just_pressed("mutations"):
		EventManager.emit_signal("toggle_mutation_display")

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
	
	# Прокачка навыка ближнего боя
	gain_skill_xp("melee", 5.0)
	gain_skill_xp("athletics", 1.0)
	
	# Поиск зомби в зоне атаки
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("zombies"):
			# Применяем бонус урона от навыка
			var damage = effective_attack_damage * (1.0 + get_skill_bonus("melee"))
			body.take_damage(damage)
			print("[Player] Hit zombie for %.1f damage" % damage)
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

# === СИСТЕМА НАВЫКОВ И ЧЕРТ ===

# Применить эффекты черт к характеристикам
func _apply_trait_effects():
	if not trait_set:
		return
	
	var effects = trait_set.get_combined_effects()
	
	# Здоровье
	if effects.has("max_health_bonus"):
		effective_max_health = max_health + effects["max_health_bonus"]
	
	# Стамина
	if effects.has("stamina_bonus"):
		effective_max_stamina = max_stamina + effects["stamina_bonus"]
	
	# Скорость
	if effects.has("move_speed_bonus"):
		var bonus = 1.0 + effects["move_speed_bonus"]
		effective_move_speed = move_speed * bonus
		effective_sprint_speed = sprint_speed * bonus
	
	# Урон
	if effects.has("melee_damage_bonus"):
		var bonus = 1.0 + effects["melee_damage_bonus"]
		effective_attack_damage = attack_damage * bonus
	
	# Слот инвентаря
	if effects.has("inventory_slots_bonus") and inventory:
		inventory.max_slots += effects["inventory_slots_bonus"]
	
	print("[Player] Trait effects applied. HP: %.0f, Speed: %.0f, Damage: %.1f" % [effective_max_health, effective_move_speed, effective_attack_damage])

# Добавить опыт навыку
func gain_skill_xp(skill_id: String, amount: float):
	if not skill_set:
		return
	
	# Применяем множитель опыта от черт
	var final_amount = amount
	if trait_set:
		var effects = trait_set.get_combined_effects()
		if effects.has("xp_multiplier"):
			final_amount *= effects["xp_multiplier"]
	
	skill_set.add_xp(skill_id, final_amount)

# Получить бонус от навыка
func get_skill_bonus(skill_id: String) -> float:
	if skill_set:
		return skill_set.get_level_bonus(skill_id)
	return 0.0

# Инициализировать навыки и черты (при создании персонажа)
func set_skill_trait_sets(skills: SkillSet, traits: TraitSet):
	skill_set = skills
	trait_set = traits
	_apply_trait_effects()
	print("[Player] Skills and traits set from character creation")

# === СИСТЕМА МУТАЦИЙ ===

# Применить эффекты мутаций к характеристикам
func _apply_mutation_effects():
	if not mutation_system:
		return
	
	var effects = mutation_system.get_combined_effects()
	
	# Здоровье
	if effects.has("max_health_bonus"):
		effective_max_health += effects["max_health_bonus"]
	
	# Стамина
	if effects.has("stamina_bonus"):
		effective_max_stamina += effects["stamina_bonus"]
	
	# Скорость
	if effects.has("move_speed_bonus"):
		effective_move_speed += move_speed * effects["move_speed_bonus"]
		effective_sprint_speed += sprint_speed * effects["move_speed_bonus"]
	
	# Урон
	if effects.has("melee_damage_bonus"):
		effective_attack_damage += attack_damage * effects["melee_damage_bonus"]
	
	# Защита
	if effects.has("armor_bonus"):
		# Применяется при получении урона
		pass
	
	print("[Player] Mutation effects applied")

# Получить мутацию
func gain_mutation(mutation_id: String, source: int = 0) -> bool:
	if mutation_system:
		var result = mutation_system.gain_mutation(mutation_id, source)
		if result:
			_apply_mutation_effects()
		return result
	return false

# Добавить радиацию
func add_radiation(amount: float):
	if mutation_system:
		mutation_system.add_radiation(amount)

# Обработать укус зомби
func process_bite():
	if mutation_system:
		mutation_system.process_bite()

# Получить систему мутаций
func get_mutation_system() -> Mutation:
	return mutation_system

# Проверить наличие мутации
func has_mutation(mutation_id: String) -> bool:
	if mutation_system:
		return mutation_system.has_mutation(mutation_id)
	return false
