extends Node

# SaveManager - улучшенная система сохранения
# Сохраняет все системы игры

const SAVE_PATH = "user://saves/"
const SETTINGS_FILE = "settings.save"
const MAX_SAVE_SLOTS = 5

func _ready():
	DirAccess.make_dir_recursive_absolute(SAVE_PATH)
	print("[SaveManager] Initialized")

# Сохранить игру в слот
func save_game(slot: int = 0):
	if not GameManager.player:
		print("[SaveManager] No player to save")
		return
	
	var save_data = {
		"version": "0.2.0",
		"timestamp": Time.get_datetime_string_from_system(),
		"slot": slot,
		
		# Основные данные
		"player": _serialize_player(),
		"game_time": GameManager.game_time,
		"day_count": GameManager.day_count,
		
		# Системы
		"skills": GameManager.player.skill_set.serialize() if GameManager.player.has_method("skill_set") else {},
		"traits": GameManager.player.trait_set.serialize() if GameManager.player.has_method("trait_set") else {},
		"mutations": GameManager.player.get_mutation_system().serialize() if GameManager.player.has_method("get_mutation_system") else {},
		
		# Мир
		"day_night": DayNightCycle.serialize_data() if DayNightCycle else {},
		
		# НПС и фракции
		"npcs": NPCManager.serialize_data() if NPCManager else [],
		"factions": FactionManager.serialize_data() if FactionManager else {},
		
		# Отряд
		"squad": SquadManager.serialize_data() if SquadManager else {},
		
		# Квесты
		"quests": QuestManager.serialize_data() if QuestManager else {},
		
		# Фермерство
		"farming": FarmingManager.serialize_data() if FarmingManager else [],
		
		# Здания
		"buildings": BuildingManager.serialize_data() if BuildingManager else {}
	}
	
	var file = FileAccess.open(SAVE_PATH + "save_%d.save" % slot, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("[SaveManager] Game saved to slot %d" % slot)
	else:
		print("[SaveManager] Failed to save game")

# Загрузить игру из слота
func load_game(slot: int = 0) -> bool:
	var save_path = SAVE_PATH + "save_%d.save" % slot
	if not FileAccess.file_exists(save_path):
		print("[SaveManager] No save file found in slot %d" % slot)
		return false
	
	var file = FileAccess.open(save_path, FileAccess.READ)
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
	print("[SaveManager] Game loaded from slot %d" % slot)
	return true

# Проверить наличие сохранения в слоте
func has_save_in_slot(slot: int) -> bool:
	return FileAccess.file_exists(SAVE_PATH + "save_%d.save" % slot)

# Получить информацию о сохранении
func get_save_info(slot: int) -> Dictionary:
	var save_path = SAVE_PATH + "save_%d.save" % slot
	if not FileAccess.file_exists(save_path):
		return {}
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	if not file:
		return {}
	
	var json = JSON.new()
	json.parse(file.get_as_text())
	file.close()
	
	var data = json.data
	return {
		"version": data.get("version", ""),
		"timestamp": data.get("timestamp", ""),
		"day": data.get("day_count", 1)
	}

# Удалить сохранение
func delete_save(slot: int = 0):
	var save_path = SAVE_PATH + "save_%d.save" % slot
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print("[SaveManager] Save %d deleted" % slot)

# Проверить наличие любого сохранения
func has_save() -> bool:
	for i in range(MAX_SAVE_SLOTS):
		if has_save_in_slot(i):
			return true
	return false

# Применить сохранённые данные
func _apply_save_data(data: Dictionary):
	# Основные данные
	if data.has("game_time"):
		GameManager.game_time = data["game_time"]
	if data.has("day_count"):
		GameManager.day_count = data["day_count"]
	
	# Навыки и черты
	if data.has("skills") and GameManager.player.has_method("skill_set"):
		if GameManager.player.skill_set:
			GameManager.player.skill_set.deserialize(data["skills"])
	
	if data.has("traits") and GameManager.player.has_method("trait_set"):
		if GameManager.player.trait_set:
			GameManager.player.trait_set.deserialize(data["traits"])
	
	# Мутации
	if data.has("mutations") and GameManager.player.has_method("get_mutation_system"):
		var mut_system = GameManager.player.get_mutation_system()
		if mut_system:
			mut_system.deserialize(data["mutations"])
	
	# Время суток
	if data.has("day_night") and DayNightCycle:
		DayNightCycle.deserialize_data(data["day_night"])
	
	# Фракции
	if data.has("factions") and FactionManager:
		FactionManager.deserialize_data(data["factions"])
	
	# Отряд
	if data.has("squad") and SquadManager:
		SquadManager.deserialize_data(data["squad"])
	
	# Квесты
	if data.has("quests") and QuestManager:
		QuestManager.deserialize_data(data["quests"])
	
	# Здания
	if data.has("buildings") and BuildingManager:
		BuildingManager.deserialize_data(data["buildings"])

# Сохранить настройки
func save_settings():
	var settings = {
		"audio": AudioManager.serialize_data() if AudioManager else {},
		"graphics": {
			"fullscreen": DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		}
	}
	
	var file = FileAccess.open(SAVE_PATH + SETTINGS_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(settings, "\t"))
		file.close()

# Загрузить настройки
func load_settings() -> bool:
	if not FileAccess.file_exists(SAVE_PATH + SETTINGS_FILE):
		return false
	
	var file = FileAccess.open(SAVE_PATH + SETTINGS_FILE, FileAccess.READ)
	if not file:
		return false
	
	var json = JSON.new()
	json.parse(file.get_as_text())
	file.close()
	
	var settings = json.data
	
	if settings.has("audio") and AudioManager:
		AudioManager.deserialize_data(settings["audio"])
	
	return true

func _serialize_player() -> Dictionary:
	var player = GameManager.player
	return {
		"position": {"x": player.position.x, "y": player.position.y},
		"health": player.health,
		"stamina": player.stamina,
		"hunger": player.hunger,
		"thirst": player.thirst,
		"inventory": player.inventory.serialize() if "inventory" in player else []
	}
