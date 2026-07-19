extends Resource
class_name ButcheringDatabase

# ButcheringDatabase - расширенная база разделки (20+ существ)

const CREATURES = {
	# === ЗОМБИ (5 типов) ===
	"zombie": {
		"name": "Зомби",
		"tools": ["knife"],
		"time": 300,
		"skill": {"survival": 1},
		"results": [
			{"id": "zombie_flesh", "count": 2, "chance": 0.8},
			{"id": "zombie_bone", "count": 1, "chance": 0.5},
			{"id": "zombie_eye", "count": 1, "chance": 0.2},
			{"id": "zombie_brain", "count": 1, "chance": 0.3},
			{"id": "rotten_flesh", "count": 3, "chance": 0.9},
			{"id": "zombie_blood", "count": 1, "chance": 0.6}
		]
	},
	"zombie_runner": {
		"name": "Зомби-бегун",
		"tools": ["knife"],
		"time": 250,
		"skill": {"survival": 1},
		"results": [
			{"id": "zombie_flesh", "count": 2, "chance": 0.7},
			{"id": "zombie_bone", "count": 1, "chance": 0.4},
			{"id": "zombie_brain", "count": 1, "chance": 0.4},
			{"id": "rotten_flesh", "count": 2, "chance": 0.8}
		]
	},
	"zombie_tank": {
		"name": "Зомби-танк",
		"tools": ["knife", "saw"],
		"time": 600,
		"skill": {"survival": 3},
		"results": [
			{"id": "zombie_flesh", "count": 5, "chance": 0.9},
			{"id": "zombie_bone", "count": 3, "chance": 0.7},
			{"id": "zombie_brain", "count": 1, "chance": 0.5},
			{"id": "thick_zombie_skin", "count": 1, "chance": 0.4},
			{"id": "zombie_blood", "count": 3, "chance": 0.8}
		]
	},
	"zombie_spitter": {
		"name": "Плюющийся зомби",
		"tools": ["knife"],
		"time": 280,
		"skill": {"survival": 2},
		"results": [
			{"id": "zombie_flesh", "count": 2, "chance": 0.7},
			{"id": "acid_gland", "count": 1, "chance": 0.6},
			{"id": "zombie_bone", "count": 1, "chance": 0.4},
			{"id": "zombie_brain", "count": 1, "chance": 0.3}
		]
	},
	"zombie_screamer": {
		"name": "Крикун",
		"tools": ["knife"],
		"time": 260,
		"skill": {"survival": 2},
		"results": [
			{"id": "zombie_flesh", "count": 2, "chance": 0.7},
			{"id": "vocal_cords", "count": 1, "chance": 0.5},
			{"id": "zombie_bone", "count": 1, "chance": 0.4},
			{"id": "zombie_brain", "count": 1, "chance": 0.4}
		]
	},
	
	# === ЖИВОТНЫЕ (10 типов) ===
	"deer": {
		"Олень",
		"tools": ["knife"],
		"time": 600,
		"skill": {"survival": 2},
		"results": [
			{"id": "raw_meat", "count": 5, "chance": 1.0},
			{"id": "animal_hide", "count": 1, "chance": 0.8},
			{"id": "bone", "count": 3, "chance": 1.0},
			{"id": "sinew", "count": 2, "chance": 0.6},
			{"id": "fat", "count": 2, "chance": 0.7},
			{"id": "antler", "count": 1, "chance": 0.3}
		]
	},
	"rabbit": {
		"name": "Кролик",
		"tools": ["knife"],
		"time": 200,
		"skill": {"survival": 1},
		"results": [
			{"id": "raw_meat", "count": 2, "chance": 1.0},
			{"id": "small_hide", "count": 1, "chance": 0.7},
			{"id": "bone", "count": 1, "chance": 1.0},
			{"id": "rabbit_foot", "count": 1, "chance": 0.1}
		]
	},
	"boar": {
		"name": "Кабан",
		"tools": ["knife", "saw"],
		"time": 900,
		"skill": {"survival": 3},
		"results": [
			{"id": "raw_meat", "count": 8, "chance": 1.0},
			{"id": "animal_hide", "count": 2, "chance": 0.9},
			{"id": "bone", "count": 4, "chance": 1.0},
			{"id": "tusk", "count": 2, "chance": 0.5},
			{"id": "fat", "count": 3, "chance": 0.8},
			{"id": "sinew", "count": 3, "chance": 0.7}
		]
	},
	"cow": {
		"name": "Корова",
		"tools": ["knife", "saw"],
		"time": 1200,
		"skill": {"survival": 4},
		"results": [
			{"id": "raw_meat", "count": 15, "chance": 1.0},
			{"id": "leather_hide", "count": 3, "chance": 0.9},
			{"id": "bone", "count": 6, "chance": 1.0},
			{"id": "horn", "count": 2, "chance": 0.4},
			{"id": "fat", "count": 5, "chance": 0.8},
			{"id": "milk", "count": 2, "chance": 0.6},
			{"id": "sinew", "count": 4, "chance": 0.7}
		]
	},
	"chicken": {
		"name": "Курица",
		"tools": ["knife"],
		"time": 150,
		"skill": {"survival": 1},
		"results": [
			{"id": "raw_meat", "count": 1, "chance": 1.0},
			{"id": "feathers", "count": 5, "chance": 0.9},
			{"id": "bone", "count": 1, "chance": 0.8},
			{"id": "egg", "count": 1, "chance": 0.3}
		]
	},
	"pig": {
		"name": "Свинья",
		"tools": ["knife", "saw"],
		"time": 800,
		"skill": {"survival": 3},
		"results": [
			{"id": "raw_meat", "count": 10, "chance": 1.0},
			{"id": "animal_hide", "count": 2, "chance": 0.9},
			{"id": "bone", "count": 4, "chance": 1.0},
			{"id": "fat", "count": 6, "chance": 0.9},
			{"id": "tusk", "count": 2, "chance": 0.4}
		]
	},
	"sheep": {
		"name": "Овца",
		"tools": ["knife"],
		"time": 700,
		"skill": {"survival": 2},
		"results": [
			{"id": "raw_meat", "count": 6, "chance": 1.0},
			{"id": "wool", "count": 3, "chance": 0.9},
			{"id": "animal_hide", "count": 1, "chance": 0.8},
			{"id": "bone", "count": 3, "chance": 1.0},
			{"id": "fat", "count": 2, "chance": 0.7}
		]
	},
	"horse": {
		"name": "Лошадь",
		"tools": ["knife", "saw"],
		"time": 1500,
		"skill": {"survival": 4},
		"results": [
			{"id": "raw_meat", "count": 20, "chance": 1.0},
			{"id": "leather_hide", "count": 4, "chance": 0.9},
			{"id": "bone", "count": 8, "chance": 1.0},
			{"id": "mane_hair", "count": 1, "chance": 0.5},
			{"id": "fat", "count": 6, "chance": 0.8}
		]
	},
	"bear": {
		"name": "Медведь",
		"tools": ["knife", "saw"],
		"time": 1800,
		"skill": {"survival": 5},
		"results": [
			{"id": "raw_meat", "count": 25, "chance": 1.0},
			{"id": "thick_hide", "count": 3, "chance": 0.9},
			{"id": "bone", "count": 10, "chance": 1.0},
			{"id": "claw", "count": 4, "chance": 0.7},
			{"id": "fat", "count": 8, "chance": 0.9},
			{"id": "bear_gall", "count": 1, "chance": 0.3}
		]
	},
	"wolf": {
		"name": "Волк",
		"tools": ["knife"],
		"time": 500,
		"skill": {"survival": 2},
		"results": [
			{"id": "raw_meat", "count": 4, "chance": 1.0},
			{"id": "animal_hide", "count": 1, "chance": 0.8},
			{"id": "bone", "count": 2, "chance": 1.0},
			{"id": "fang", "count": 2, "chance": 0.6},
			{"id": "fat", "count": 1, "chance": 0.5}
		]
	},
	
	# === МУТАНТЫ (5 типов) ===
	"mutant_hound": {
		"name": "Мутант-гончая",
		"tools": ["knife"],
		"time": 400,
		"skill": {"survival": 2},
		"results": [
			{"id": "mutant_flesh", "count": 3, "chance": 0.7},
			{"id": "mutant_hide", "count": 1, "chance": 0.6},
			{"id": "mutant_bone", "count": 2, "chance": 0.5},
			{"id": "mutant_sample", "count": 1, "chance": 0.3}
		]
	},
	"mutant_brute": {
		"name": "Мутант-громила",
		"tools": ["knife", "saw"],
		"time": 800,
		"skill": {"survival": 4},
		"results": [
			{"id": "mutant_flesh", "count": 6, "chance": 0.8},
			{"id": "mutant_hide", "count": 2, "chance": 0.7},
			{"id": "mutant_bone", "count": 4, "chance": 0.6},
			{"id": "mutant_tissue", "count": 2, "chance": 0.4},
			{"id": "mutant_sample", "count": 1, "chance": 0.4}
		]
	},
	"mutant_spitter": {
		"name": "Мутант-плюющийся",
		"tools": ["knife"],
		"time": 350,
		"skill": {"survival": 3},
		"results": [
			{"id": "mutant_flesh", "count": 2, "chance": 0.6},
			{"id": "mutant_acid_gland", "count": 1, "chance": 0.7},
			{"id": "mutant_bone", "count": 1, "chance": 0.4},
			{"id": "mutant_sample", "count": 1, "chance": 0.3}
		]
	},
	"mutant_stalker": {
		"name": "Мутант-сталкер",
		"tools": ["knife"],
		"time": 450,
		"skill": {"survival": 3},
		"results": [
			{"id": "mutant_flesh", "count": 3, "chance": 0.7},
			{"id": "mutant_hide", "count": 1, "chance": 0.6},
			{"id": "mutant_eye", "count": 1, "chance": 0.5},
			{"id": "mutant_sample", "count": 1, "chance": 0.4}
		]
	},
	"mutant_chimera": {
		"name": "Мутант-химера",
		"tools": ["knife", "saw"],
		"time": 1000,
		"skill": {"survival": 5},
		"results": [
			{"id": "mutant_flesh", "count": 8, "chance": 0.8},
			{"id": "mutant_hide", "count": 3, "chance": 0.7},
			{"id": "mutant_bone", "count": 5, "chance": 0.6},
			{"id": "mutant_tissue", "count": 3, "chance": 0.5},
			{"id": "mutant_sample", "count": 2, "chance": 0.5},
			{"id": "mutant_heart", "count": 1, "chance": 0.2}
		]
	}
}

static func get_creature(creature_id: String) -> Dictionary:
	return CREATURES.get(creature_id, {})

static func get_all_creatures() -> Array:
	return CREATURES.keys()

static func get_creatures_by_type(type: String) -> Array:
	var result = []
	for id in CREATURES:
		if id.begins_with(type):
			result.append(id)
	return result
