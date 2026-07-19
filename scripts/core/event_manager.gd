extends Node

# EventManager - оптимизированная шина событий

# Игрок
signal player_damaged(amount)
signal player_healed(amount)
signal player_died
signal player_moved(position)
signal player_level_up(new_level)

# Зомби
signal zombie_died(zombie)
signal zombie_attacked(zombie, target)
signal zombie_alerted(position)

# Предметы
signal item_picked_up(item)
signal item_dropped(item)
signal item_used(item)
signal item_crafted(item_id)

# Мир
signal new_day(day_count)
signal weather_changed(weather_type)
signal time_period_changed(period)

# Здания
signal building_placed(building)
signal building_destroyed(building)
signal open_storage(storage)

# Крафт и строительство
signal toggle_crafting()
signal toggle_building_menu()
signal toggle_farming_menu()
signal build_piece_requested(piece_type)

# НПС
signal open_npc_dialogue(npc)
signal open_npc_trade(npc)
signal show_npc_dialogue(npc, text)
signal npc_spawned(npc)
signal npc_died(npc)

# Мутации
signal toggle_mutation_display()
signal mutation_gained(mutation_id)
signal mutation_lost(mutation_id)
signal radiation_changed(level)

# Карта
signal toggle_world_map()
signal minimap_updated()

# Отряд
signal toggle_squad_ui()
signal member_recruited(member)
signal member_left(member)
signal mission_started(member, mission)
signal mission_completed(member, mission, success)

# Система
signal game_state_changed(new_state)
signal save_requested()
signal load_requested()

func _ready():
	print("[EventManager] Initialized")
