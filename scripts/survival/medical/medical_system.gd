extends Node
class_name MedicalSystem

# MedicalSystem - продвинутая медицинская система (как в CDDA)
# Хирургия, перевязки, дезинфекция, лечение

enum WoundType { CUT, BRUISE, BURN, BITE, BULLET, STAB, FRACTURE, INFECTION }
enum TreatmentType { BANDAGE, DISINFECT, SUTURE, SPLINT, SURGERY, MEDICATION, REST }

const WOUND_EFFECTS = {
	WoundType.CUT: {"bleeding": 10, "pain": 15, "infection_risk": 30},
	WoundType.BRUISE: {"bleeding": 0, "pain": 10, "infection_risk": 5},
	WoundType.BURN: {"bleeding": 0, "pain": 30, "infection_risk": 40},
	WoundType.BITE: {"bleeding": 15, "pain": 25, "infection_risk": 60},
	WoundType.BULLET: {"bleeding": 25, "pain": 35, "infection_risk": 50},
	WoundType.STAB: {"bleeding": 20, "pain": 30, "infection_risk": 45},
	WoundType.FRACTURE: {"bleeding": 5, "pain": 40, "infection_risk": 10},
	WoundType.INFECTION: {"bleeding": 0, "pain": 20, "infection_risk": 100}
}

const TREATMENT_REQUIREMENTS = {
	TreatmentType.BANDAGE: {"bandage": 1},
	TreatmentType.DISINFECT: {"alcohol": 1, "antiseptic": 1},
	TreatmentType.SUTURE: {"needle": 1, "thread": 1, "anesthetic": 1},
	TreatmentType.SPLINT: {"wood_stick": 2, "cloth": 1},
	TreatmentType.SURGERY: {"scalpel": 1, "anesthetic": 2, "thread": 2, "forceps": 1},
	TreatmentType.MEDICATION: {"pills": 1, "antibiotics": 1},
	TreatmentType.REST: {}
}

var active_wounds: Array[Dictionary] = []
var diseases: Array[String] = []
var addictions: Array[String] = []

func treat_wound(wound_index: int, treatment: TreatmentType, inventory: Inventory) -> bool:
	if wound_index >= active_wounds.size():
		return false
	
	var wound = active_wounds[wound_index]
	var requirements = TREATMENT_REQUIREMENTS[treatment]
	
	# Проверяем наличие материалов
	for item_id in requirements:
		if inventory.get_item_count(item_id) < requirements[item_id]:
			return false
	
	# Расходуем материалы
	for item_id in requirements:
		var count = requirements[item_id]
		for i in range(count):
			var item = inventory.get_item_by_id(item_id)
			if item:
				inventory.remove_item(item)
	
	# Применяем лечение
	match treatment:
		TreatmentType.BANDAGE:
			wound["bleeding"] = max(0, wound["bleeding"] - 10)
		TreatmentType.DISINFECT:
			wound["infection_risk"] = max(0, wound["infection_risk"] - 50)
		TreatmentType.SUTURE:
			wound["bleeding"] = 0
			wound["healing_progress"] += 30
		TreatmentType.SPLINT:
			if wound["type"] == WoundType.FRACTURE:
				wound["healing_progress"] += 40
		TreatmentType.SURGERY:
			wound["healing_progress"] += 60
			wound["infection_risk"] = max(0, wound["infection_risk"] - 30)
		TreatmentType.MEDICATION:
			wound["pain"] = max(0, wound["pain"] - 20)
			wound["infection_risk"] = max(0, wound["infection_risk"] - 20)
	
	# Проверяем полное заживление
	if wound["healing_progress"] >= 100:
		active_wounds.remove_at(wound_index)
	
	return true

func add_wound(wound_type: WoundType, body_part: String):
	var effects = WOUND_EFFECTS[wound_type]
	active_wounds.append({
		"type": wound_type,
		"part": body_part,
		"bleeding": effects["bleeding"],
		"pain": effects["pain"],
		"infection_risk": effects["infection_risk"],
		"healing_progress": 0,
		"is_infected": false,
		"time_since_wound": 0.0
	})

func _process(delta):
	_update_wounds(delta)

func _update_wounds(delta):
	for wound in active_wounds:
		wound["time_since_wound"] += delta
		
		# Кровотечение
		if wound["bleeding"] > 0:
			wound["healing_progress"] = max(0, wound["healing_progress"] - delta * 0.5)
		
		# Инфекция
		if wound["infection_risk"] > 50 and not wound["is_infected"]:
			if randf() < 0.01 * delta:
				wound["is_infected"] = true
		
		# Естественное заживление
		if wound["bleeding"] == 0 and not wound["is_infected"]:
			wound["healing_progress"] += delta * 0.2

func get_total_pain() -> float:
	var total = 0.0
	for wound in active_wounds:
		total += wound["pain"]
	return total

func get_total_bleeding() -> float:
	var total = 0.0
	for wound in active_wounds:
		total += wound["bleeding"]
	return total

func has_infection() -> bool:
	for wound in active_wounds:
		if wound["is_infected"]:
			return true
	return false
