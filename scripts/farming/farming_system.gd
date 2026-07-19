extends Node
class_name FarmingSystem

# FarmingSystem - система фермерства (как в CDDA)
# Сезоны, рост растений, урожай

signal crop_grown(crop_id, plot)
signal crop_harvested(crop_id, plot, yield)
signal season_changed(new_season)

enum Season { SPRING, SUMMER, AUTUMN, WINTER }
enum CropStage { SEED, SPROUT, GROWING, MATURE, WITHERED }

var current_season: Season = Season.SUMMER
var day_count: int = 1

# Каталог растений
const CROPS = {
	"carrot": {
		"name": "Морковь",
		"growth_time": 7200,  # 2 часа
		"yield": {"carrot": 3},
		"seasons": [Season.SPRING, Season.SUMMER, Season.AUTUMN],
		"water_needs": 30,
		"sun_needs": 50
	},
	"potato": {
		"name": "Картофель",
		"growth_time": 10800,  # 3 часа
		"yield": {"potato": 4},
		"seasons": [Season.SPRING, Season.SUMMER],
		"water_needs": 40,
		"sun_needs": 40
	},
	"tomato": {
		"name": "Помидор",
		"growth_time": 9000,  # 2.5 часа
		"yield": {"tomato": 3},
		"seasons": [Season.SUMMER],
		"water_needs": 50,
		"sun_needs": 70
	},
	"corn": {
		"name": "Кукуруза",
		"growth_time": 14400,  # 4 часа
		"yield": {"corn": 3},
		"seasons": [Season.SUMMER, Season.AUTUMN],
		"water_needs": 45,
		"sun_needs": 60
	},
	"wheat": {
		"name": "Пшеница",
		"growth_time": 12600,  # 3.5 часа
		"yield": {"wheat": 4},
		"seasons": [Season.SPRING, Season.SUMMER],
		"water_needs": 35,
		"sun_needs": 50
	},
	"pumpkin": {
		"name": "Тыква",
		"growth_time": 18000,  # 5 часов
		"yield": {"pumpkin": 2},
		"seasons": [Season.SUMMER, Season.AUTUMN],
		"water_needs": 55,
		"sun_needs": 65
	},
	"strawberry": {
		"name": "Клубника",
		"growth_time": 5400,  # 1.5 часа
		"yield": {"strawberry": 5},
		"seasons": [Season.SPRING, Season.SUMMER],
		"water_needs": 40,
		"sun_needs": 55
	},
	"blueberry": {
		"name": "Черника",
		"growth_time": 7200,  # 2 часа
		"yield": {"blueberry": 4},
		"seasons": [Season.SUMMER],
		"water_needs": 45,
		"sun_needs": 50
	},
	"apple_tree": {
		"name": "Яблоня",
		"growth_time": 28800,  # 8 часов
		"yield": {"apple": 6},
		"seasons": [Season.AUTUMN],
		"water_needs": 30,
		"sun_needs": 45,
		"is_tree": true
	},
	"herbs": {
		"name": "Травы",
		"growth_time": 3600,  # 1 час
		"yield": {"herbs": 3},
		"seasons": [Season.SPRING, Season.SUMMER, Season.AUTUMN],
		"water_needs": 25,
		"sun_needs": 40
	}
}

# Активные грядки
var active_plots: Array[Dictionary] = []

func _process(delta):
	_update_crops(delta)
	_check_season_change(delta)

func _update_crops(delta):
	for plot in active_plots:
		if plot["stage"] == CropStage.MATURE or plot["stage"] == CropStage.WITHERED:
			continue
		
		var crop_data = CROPS.get(plot["crop_id"], {})
		if crop_data.is_empty():
			continue
		
		# Проверяем сезон
		if not crop_data["seasons"].has(current_season):
			plot["stage"] = CropStage.WITHERED
			continue
		
		# Обновляем прогресс
		plot["growth_progress"] += delta
		
		// Проверяем полив
		plot["water_level"] -= delta * 0.5
		if plot["water_level"] <= 0:
			plot["stage"] = CropStage.WITHERED
			continue
		
		// Обновляем стадию
		var progress_percent = plot["growth_progress"] / crop_data["growth_time"]
		if progress_percent >= 1.0:
			plot["stage"] = CropStage.MATURE
			emit_signal("crop_grown", plot["crop_id"], plot)
		elif progress_percent >= 0.6:
			plot["stage"] = CropStage.GROWING
		elif progress_percent >= 0.2:
			plot["stage"] = CropStage.SPROUT

func _check_season_change(delta):
	day_count += delta
	if day_count >= 86400:  # 24 часа = 1 день
		day_count = 0
		_change_season()

func _change_season():
	current_season = (current_season + 1) % 4
	emit_signal("season_changed", current_season)
	print("[Farming] Season changed to: %d" % current_season)

func plant_crop(crop_id: String, position: Vector2) -> bool:
	if not CROPS.has(crop_id):
		return false
	
	active_plots.append({
		"crop_id": crop_id,
		"position": position,
		"stage": CropStage.SEED,
		"growth_progress": 0.0,
		"water_level": 50.0,
		"planted_time": 0.0
	})
	
	return true

func harvest_crop(plot_index: int) -> Dictionary:
	if plot_index >= active_plots.size():
		return {}
	
	var plot = active_plots[plot_index]
	if plot["stage"] != CropStage.MATURE:
		return {}
	
	var crop_data = CROPS.get(plot["crop_id"], {})
	var yield_items = crop_data.get("yield", {})
	
	emit_signal("crop_harvested", plot["crop_id"], plot, yield_items)
	active_plots.remove_at(plot_index)
	
	return yield_items

func water_crop(plot_index: int, amount: float = 30.0):
	if plot_index < active_plots.size():
		active_plots[plot_index]["water_level"] = min(100, active_plots[plot_index]["water_level"] + amount)

func get_crop_status(plot_index: int) -> String:
	if plot_index >= active_plots.size():
		return "Нет грядки"
	
	var plot = active_plots[plot_index]
	match plot["stage"]:
		CropStage.SEED: return "Семя"
		CropStage.SPROUT: return "Росток"
		CropStage.GROWING: return "Растёт"
		CropStage.MATURE: return "Готов к сбору"
		CropStage.WITHERED: return "Увял"
	return "Неизвестно"

func get_season_name() -> String:
	match current_season:
		Season.SPRING: return "Весна"
		Season.SUMMER: return "Лето"
		Season.AUTUMN: return "Осень"
		Season.WINTER: return "Зима"
	return "Неизвестно"
