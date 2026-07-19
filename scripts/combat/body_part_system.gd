extends Resource
class_name BodyPartSystem

# BodyPartSystem - система частей тела (как в CDDA)
# Отслеживает здоровье каждой части тела, раны и болевой порог

const BODY_PARTS = {
	"head": {"health": 30, "max_health": 30, "pain_multiplier": 3.0},
	"torso": {"health": 50, "max_health": 50, "pain_multiplier": 1.0},
	"left_arm": {"health": 25, "max_health": 25, "pain_multiplier": 1.5},
	"right_arm": {"health": 25, "max_health": 25, "pain_multiplier": 1.5},
	"left_leg": {"health": 30, "max_health": 30, "pain_multiplier": 2.0},
	"right_leg": {"health": 30, "max_health": 30, "pain_multiplier": 2.0}
}

var body_parts: Dictionary = {}
var wounds: Array[Dictionary] = []
var pain_level: float = 0.0
var is_bleeding: bool = false

func _init():
	_initialize_body_parts()

func _initialize_body_parts():
	for part_name in BODY_PARTS:
		var data = BODY_PARTS[part_name]
		body_parts[part_name] = {
			"health": data["health"],
			"max_health": data["max_health"],
			"pain_multiplier": data["pain_multiplier"],
			"is_broken": false,
			"is_bleeding": false,
			"has_infection": false
		}

func damage_part(part_name: String, amount: float) -> float:
	if not body_parts.has(part_name):
		return 0.0
	
	var part = body_parts[part_name]
	part["health"] -= amount
	
	# Добавляем рану
	wounds.append({
		"part": part_name,
		"severity": amount,
		"is_bleeding": amount > 10,
		"has_infection": false
	})
	
	# Проверяем перелом
	if part["health"] <= 0:
		part["is_broken"] = true
	
	# Обновляем боль
	_update_pain()
	
	return amount

func heal_part(part_name: String, amount: float):
	if body_parts.has(part_name):
		var part = body_parts[part_name]
		part["health"] = min(part["max_health"], part["health"] + amount)
		
		if part["health"] > 0:
			part["is_broken"] = false
		
		_update_pain()

func _update_pain():
	pain_level = 0.0
	is_bleeding = false
	
	for part_name in body_parts:
		var part = body_parts[part_name]
		var damage_percent = 1.0 - (part["health"] / part["max_health"])
		pain_level += damage_percent * part["pain_multiplier"] * 20
		
		if part["is_bleeding"]:
			is_bleeding = true
	
	pain_level = clamp(pain_level, 0, 100)

func get_pain_penalty() -> float:
	return pain_level * 0.3

func get_part_health(part_name: String) -> float:
	if body_parts.has(part_name):
		return body_parts[part_name]["health"]
	return 0.0

func is_part_broken(part_name: String) -> bool:
	if body_parts.has(part_name):
		return body_parts[part_name]["is_broken"]
	return false

func get_overall_health() -> float:
	var total_health = 0.0
	var total_max = 0.0
	
	for part_name in body_parts:
		total_health += body_parts[part_name]["health"]
		total_max += body_parts[part_name]["max_health"]
	
	return (total_health / total_max) * 100.0
