extends Node

# SaveManager - система сохранения и загрузки игры

const SAVE_PATH = "user://saves/"
const SAVE_FILE = "savegame.save"

func _ready():
	# Создаём директорию для сохранений если не существует
	DirAccess.make_dir_recursive_absolute(SAVE_PATH)
	print("[SaveManager] Initialized")

func save_game():
	if not GameManager.player:
		print("[SaveManager] No player to save")
		return
	
	var save_data = {
		"player": _serialize_player(),
		"game_time": GameManager.game_time,
		"day_count": GameManager.day_count,
		"timestamp": Time.get_datetime_string_from_system()
	}
	
	var file = FileAccess.open(SAVE_PATH + SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("[SaveManager] Game saved successfully")
	else:
		print("[SaveManager] Failed to save game")

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH + SAVE_FILE):
		print("[SaveManager] No save file found")
		return false
	
	var file = FileAccess.open(SAVE_PATH + SAVE_FILE, FileAccess.READ)
	if not file:
		return false
	
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()
	
	if error != OK:
		print("[SaveManager] Failed to parse save file")
		return false
	
	var save_data = json.data
	_apply_save_data(save_data)
	print("[SaveManager] Game loaded successfully")
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH + SAVE_FILE)

func delete_save():
	if FileAccess.file_exists(SAVE_PATH + SAVE_FILE):
		DirAccess.remove_absolute(SAVE_PATH + SAVE_FILE)
		print("[SaveManager] Save deleted")

func _serialize_player() -> Dictionary:
	var player = GameManager.player
	return {
		"position": {"x": player.position.x, "y": player.position.y},
		"health": player.health if "health" in player else 100,
		"stamina": player.stamina if "stamina" in player else 100,
		"hunger": player.hunger if "hunger" in player else 100,
		"thirst": player.thirst if "thirst" in player else 100,
		"inventory": player.inventory.serialize() if "inventory" in player else []
	}

func _apply_save_data(data: Dictionary):
	if "game_time" in data:
		GameManager.game_time = data["game_time"]
	if "day_count" in data:
		GameManager.day_count = data["day_count"]
	# Применение данных игрока будет вызываться после спавна
