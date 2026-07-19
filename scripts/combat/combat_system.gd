extends Node
class_name CombatSystem

# CombatSystem - продвинутая система боя (как в CDDA)
# Поддержка прицеливания, разных типов атак, стамины

signal attack_performed(attack_type, damage)
signal attack_missed(target)
signal critical_hit(target, damage)

enum AttackType { QUICK, HEAVY, PRECISE, FEINT, GRAB, THROW }
enum BodyPart { HEAD, TORSO, LEFT_ARM, RIGHT_ARM, LEFT_LEG, RIGHT_LEG }

var stamina: float = 100.0
var max_stamina: float = 100.0

# Шансы попадания по частям тела
const HIT_CHANCES = {
	BodyPart.HEAD: 0.3,
	BodyPart.TORSO: 0.8,
	BodyPart.LEFT_ARM: 0.5,
	BodyPart.RIGHT_ARM: 0.5,
	BodyPart.LEFT_LEG: 0.4,
	BodyPart.RIGHT_LEG: 0.4
}

# Множители урона
const DAMAGE_MULTIPLIERS = {
	BodyPart.HEAD: 3.0,
	BodyPart.TORSO: 1.0,
	BodyPart.LEFT_ARM: 0.7,
	BodyPart.RIGHT_ARM: 0.7,
	BodyPart.LEFT_LEG: 0.6,
	BodyPart.RIGHT_LEG: 0.6
}

# Стоимость стамины
const STAMINA_COSTS = {
	AttackType.QUICK: 10.0,
	AttackType.HEAVY: 25.0,
	AttackType.PRECISE: 15.0,
	AttackType.FEINT: 5.0,
	AttackType.GRAB: 20.0,
	AttackType.THROW: 15.0
}

func perform_attack(target: Node2D, attack_type: AttackType, weapon: Item = null) -> float:
	# Проверяем стамину
	var stamina_cost = STAMINA_COSTS[attack_type]
	if stamina < stamina_cost:
		return 0.0
	
	stamina -= stamina_cost
	
	# Рассчитываем шанс попадания
	var hit_chance = _calculate_hit_chance(target, attack_type)
	
	if randf() > hit_chance:
		emit_signal("attack_missed", target)
		return 0.0
	
	# Выбираем часть тела
	var body_part = _select_body_part(attack_type)
	
	# Рассчитываем урон
	var damage = _calculate_damage(attack_type, weapon, body_part)
	
	# Критический удар
	if randf() < 0.1:
		damage *= 2.0
		emit_signal("critical_hit", target, damage)
	
	emit_signal("attack_performed", attack_type, damage)
	return damage

func _calculate_hit_chance(target: Node2D, attack_type: AttackType) -> float:
	var base_chance = 0.7
	
	match attack_type:
		AttackType.QUICK:
			base_chance = 0.8
		AttackType.HEAVY:
			base_chance = 0.6
		AttackType.PRECISE:
			base_chance = 0.95
		AttackType.FEINT:
			base_chance = 0.9
	
	return base_chance

func _select_body_part(attack_type: AttackType) -> BodyPart:
	var roll = randf()
	
	match attack_type:
		AttackType.PRECISE:
			return BodyPart.HEAD if roll < 0.5 else BodyPart.TORSO
		AttackType.HEAVY:
			return BodyPart.TORSO
		_:
			var parts = BodyPart.values()
			return parts[randi() % parts.size()]

func _calculate_damage(attack_type: AttackType, weapon: Item, body_part: BodyPart) -> float:
	var base_damage = 10.0
	
	# Урон от оружия
	if weapon and weapon.has_method("get_damage"):
		base_damage = weapon.get_damage()
	
	# Множитель типа атаки
	match attack_type:
		AttackType.QUICK:
			base_damage *= 0.7
		AttackType.HEAVY:
			base_damage *= 1.5
		AttackType.PRECISE:
			base_damage *= 1.2
	
	# Множитель части тела
	base_damage *= DAMAGE_MULTIPLIERS[body_part]
	
	return base_damage

func regenerate_stamina(amount: float):
	stamina = min(max_stamina, stamina + amount)

func get_stamina_percent() -> float:
	return (stamina / max_stamina) * 100.0
