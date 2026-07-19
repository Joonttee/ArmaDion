extends Node
class_name DiseaseSystem

# DiseaseSystem - система болезней (как в CDDA)
# Отслеживает инфекции, болезни и их лечение

signal disease_contracted(disease_id)
signal disease_cured(disease_id)
signal disease_worsened(disease_id)

enum DiseaseSeverity { INCUBATING, MILD, MODERATE, SEVERE, CRITICAL, FATAL }

# Активные болезни
var diseases: Dictionary = {}  # disease_id: {severity: float, stage: int, time: float}

# Иммунитет
var immunity: float = 50.0
var is_immune_compromised: bool = false

func _process(delta):
	_update_diseases(delta)

func _update_diseases(delta):
	for disease_id in diseases:
		var data = diseases[disease_id]
		data["time"] += delta
		
		# Болезнь прогрессирует
		var progression_rate = _get_progression_rate(disease_id)
		data["severity"] += progression_rate * delta
		
		# Проверяем ухудшение
		if data["severity"] > 75 and data["stage"] < 3:
			data["stage"] += 1
			emit_signal("disease_worsened", disease_id)
		
		# Проверяем излечение
		if data["severity"] <= 0:
			_cure_disease(disease_id)

func contract_disease(disease_id: String, initial_severity: float = 10.0):
	if diseases.has(disease_id):
		# Усиливаем существующую болезнь
		diseases[disease_id]["severity"] += initial_severity
		return
	
	diseases[disease_id] = {
		"severity": initial_severity,
		"stage": 0,
		"time": 0.0
	}
	
	emit_signal("disease_contracted", disease_id)
	print("[Disease] Contracted: %s" % disease_id)

func treat_disease(disease_id: String, amount: float):
	if diseases.has(disease_id):
		diseases[disease_id]["severity"] -= amount
		if diseases[disease_id]["severity"] <= 0:
			_cure_disease(disease_id)

func _cure_disease(disease_id: String):
	diseases.erase(disease_id)
	emit_signal("disease_cured", disease_id)
	print("[Disease] Cured: %s" % disease_id)

func _get_progression_rate(disease_id: String) -> float:
	var base_rate = 0.1
	
	# Ослабленный иммунитет ускоряет болезнь
	if is_immune_compromised:
		base_rate *= 2.0
	
	return base_rate

func get_disease_severity(disease_id: String) -> DiseaseSeverity:
	if not diseases.has(disease_id):
		return DiseaseSeverity.INCUBATING
	
	var severity = diseases[disease_id]["severity"]
	if severity < 20:
		return DiseaseSeverity.INCUBATING
	elif severity < 40:
		return DiseaseSeverity.MILD
	elif severity < 60:
		return DiseaseSeverity.MODERATE
	elif severity < 80:
		return DiseaseSeverity.SEVERE
	elif severity < 95:
		return DiseaseSeverity.CRITICAL
	else:
		return DiseaseSeverity.FATAL

func get_disease_effects(disease_id: String) -> Dictionary:
	if not diseases.has(disease_id):
		return {}
	
	var severity = diseases[disease_id]["severity"]
	return {
		"health_drain": severity * 0.1,
		"stamina_penalty": severity * 0.2,
		"speed_penalty": severity * 0.15,
		"morale_penalty": severity * 0.3
	}

func get_all_diseases() -> Array:
	return diseases.keys()

func is_sick() -> bool:
	return diseases.size() > 0
