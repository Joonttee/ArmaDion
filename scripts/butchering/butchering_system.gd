extends Node
class_name ButcheringSystem

# ButcheringSystem - система разделки (как в CDDA)
# Разделка трупов на части и материалы

enum CreatureType { ZOMBIE, ANIMAL, HUMAN, MUTANT }

const BUTCHERING_RESULTS = {
	"zombie": {
		"items": [
			{"id": "zombie_flesh", "count": 2, "chance": 0.8},
			{"id": "zombie_bone", "count": 1, "chance": 0.5},
			{"id": "zombie_eye", "count": 1, "chance": 0.2},
			{"id": "zombie_brain", "count": 1, "chance": 0.3},
			{"id": "rotten_flesh", "count": 3, "chance": 0.9}
		],
		"tools": ["knife"],
		"time": 300,
		"skill": {"survival": 1}
	},
	"deer": {
		"items": [
			{"id": "raw_meat", "count": 5, "chance": 1.0},
			{"id": "animal_hide", "count": 1, "chance": 0.8},
			{"id": "bone", "count": 3, "chance": 1.0},
			{"id": "sinew", "count": 2, "chance": 0.6},
			{"id": "fat", "count": 2, "chance": 0.7}
		],
		"tools": ["knife"],
		"time": 600,
		"skill": {"survival": 2}
	},
	"rabbit": {
		"items": [
			{"id": "raw_meat", "count": 2, "chance": 1.0},
			{"id": "small_hide", "count": 1, "chance": 0.7},
			{"id": "bone", "count": 1, "chance": 1.0}
		],
		"tools": ["knife"],
		"time": 200,
		"skill": {"survival": 1}
	},
	"boar": {
		"items": [
			{"id": "raw_meat", "count": 8, "chance": 1.0},
			{"id": "animal_hide", "count": 2, "chance": 0.9},
			{"id": "bone", "count": 4, "chance": 1.0},
			{"id": "tusk", "count": 2, "chance": 0.5},
			{"id": "fat", "count": 3, "chance": 0.8}
		],
		"tools": ["knife", "saw"],
		"time": 900,
		"skill": {"survival": 3}
	},
	"cow": {
		"items": [
			{"id": "raw_meat", "count": 15, "chance": 1.0},
			{"id": "leather_hide", "count": 3, "chance": 0.9},
			{"id": "bone", "count": 6, "chance": 1.0},
			{"id": "horn", "count": 2, "chance": 0.4},
			{"id": "fat", "count": 5, "chance": 0.8}
		],
		"tools": ["knife", "saw"],
		"time": 1200,
		"skill": {"survival": 4}
	},
	"mutant": {
		"items": [
			{"id": "mutant_flesh", "count": 3, "chance": 0.7},
			{"id": "mutant_bone", "count": 2, "chance": 0.5},
			{"id": "mutant_tissue", "count": 1, "chance": 0.3},
			{"id": "mutant_sample", "count": 1, "chance": 0.2}
		],
		"tools": ["knife"],
		"time": 400,
		"skill": {"survival": 2}
	}
}

static func can_butcher(creature_type: String, inventory: Inventory) -> bool:
	if not BUTCHERING_RESULTS.has(creature_type):
		return false
	
	var data = BUTCHERING_RESULTS[creature_type]
	for tool in data["tools"]:
		if not inventory.has_item(tool):
			return false
	
	return true

static func butcher(creature_type: String, inventory: Inventory) -> Dictionary:
	if not can_butcher(creature_type, inventory):
		return {}
	
	var data = BUTCHERING_RESULTS[creature_type]
	var results = {}
	
	for item_data in data["items"]:
		if randf() < item_data["chance"]:
			var item_id = item_data["id"]
			var count = item_data["count"]
			results[item_id] = results.get(item_id, 0) + count
	
	return results

static func get_butchering_time(creature_type: String) -> float:
	if BUTCHERING_RESULTS.has(creature_type):
		return BUTCHERING_RESULTS[creature_type]["time"]
	return 300.0

static func get_required_tools(creature_type: String) -> Array:
	if BUTCHERING_RESULTS.has(creature_type):
		return BUTCHERING_RESULTS[creature_type]["tools"]
	return ["knife"]
