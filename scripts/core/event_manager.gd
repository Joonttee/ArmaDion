extends Node

# EventManager - шина событий для связи между системами
# Используется для декаплинга систем игры

# События игрока
signal player_damaged(amount)
signal player_healed(amount)
signal player_died
signal player_moved(position)

# События зомби
signal zombie_died(zombie)
signal zombie_attacked(zombie, target)
signal zombie_alerted(position)

# События предметов
signal item_picked_up(item)
signal item_dropped(item)
signal item_used(item)

# События мира
signal new_day(day_count)
signal weather_changed(weather_type)

# События крафта
signal item_crafted(item_id)

# События зданий
signal building_placed(building)
signal building_destroyed(building)
signal open_storage(storage)
signal toggle_building_menu()
signal build_piece_requested(piece_type)

# События фермерства
signal crop_planted(spot, crop_type)
signal crop_grown(spot)
signal crop_harvested(spot, drops)
signal crop_died(spot)
signal toggle_farming_menu()

func _ready():
	print("[EventManager] Initialized")
