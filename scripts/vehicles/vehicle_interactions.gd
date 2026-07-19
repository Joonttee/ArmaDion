extends Node
class_name VehicleInteractions

# VehicleInteractions - взаимодействие с транспортом
# Заправка, ремонт, взлом, буксировка

enum InteractionType { ENTER, EXIT, TRUNK, REPAIR, REFUEL, LOCK, UNLOCK, TOW, ATTACH_TRAILER, DETACH_TRAILER, PUSH, HOTWIRE }

static func can_interact(player: Node2D, vehicle: Vehicle, interaction: InteractionType) -> bool:
	match interaction:
		InteractionType.ENTER:
			return not vehicle.is_locked and vehicle.driver == null
		InteractionType.EXIT:
			return vehicle.driver == player
		InteractionType.TRUNK:
			return true
		InteractionType.REPAIR:
			return vehicle.health < vehicle.max_health
		InteractionType.REFUEL:
			return vehicle.fuel < vehicle.max_fuel and vehicle.fuel_type != Vehicle.FuelType.NONE
		InteractionType.LOCK:
			return not vehicle.is_locked
		InteractionType.UNLOCK:
			return vehicle.is_locked
		InteractionType.TOW:
			return true
		InteractionType.ATTACH_TRAILER:
			return vehicle.has_trailer_hitch and vehicle.attached_trailer == null
		InteractionType.DETACH_TRAILER:
			return vehicle.attached_trailer != null
		InteractionType.PUSH:
			return vehicle.health <= 0 or vehicle.fuel <= 0
		InteractionType.HOTWIRE:
			return vehicle.is_locked
	return false

static func interact(player: Node2D, vehicle: Vehicle, interaction: InteractionType) -> bool:
	if not can_interact(player, vehicle, interaction):
		return false
	
	match interaction:
		InteractionType.ENTER:
			vehicle.enter_as_driver(player)
		InteractionType.EXIT:
			vehicle.exit_vehicle()
		InteractionType.TRUNK:
			vehicle.open_trunk()
		InteractionType.REPAIR:
			_repair_vehicle(player, vehicle)
		InteractionType.REFUEL:
			_refuel_vehicle(player, vehicle)
		InteractionType.LOCK:
			vehicle.toggle_lock()
		InteractionType.UNLOCK:
			vehicle.toggle_lock()
		InteractionType.TOW:
			_tow_vehicle(player, vehicle)
		InteractionType.ATTACH_TRAILER:
			_attach_trailer(player, vehicle)
		InteractionType.DETACH_TRAILER:
			vehicle.detach_trailer()
		InteractionType.PUSH:
			_push_vehicle(player, vehicle)
		InteractionType.HOTWIRE:
			_hotwire_vehicle(player, vehicle)
	
	return true

static func _repair_vehicle(player: Node2D, vehicle: Vehicle):
	var inventory = player.inventory if player.has_method("inventory") else null
	if not inventory:
		return
	
	# Ищем ремкомплект в инвентаре
	for kit_type in VehicleRepair.get_repairs_kits():
		var kit = VehicleRepair.REPAIR_KIT[kit_type]
		if _has_materials(inventory, kit["cost"]):
			_consume_materials(inventory, kit["cost"])
			vehicle.repair(kit["repair"])
			print("[VehicleInteractions] Repaired vehicle with %s kit" % kit_type)
			return

static func _refuel_vehicle(player: Node2D, vehicle: Vehicle):
	var inventory = player.inventory if player.has_method("inventory") else null
	if not inventory:
		return
	
	# Ищем топливо в инвентаре
	var fuel_item = inventory.get_item_by_id("fuel")
	if fuel_item:
		inventory.remove_item(fuel_item)
		vehicle.add_fuel(25.0)
		print("[VehicleInteractions] Refueled vehicle")

static func _tow_vehicle(player: Node2D, vehicle: Vehicle):
	# Буксировка - медленное перемещение
	print("[VehicleInteractions] Towing vehicle")

static func _attach_trailer(player: Node2D, vehicle: Vehicle):
	# Ищем ближайший прицеп
	var trailers = get_tree().get_nodes_in_group("trailers")
	for trailer in trailers:
		if vehicle.global_position.distance_to(trailer.global_position) < 100:
			vehicle.attach_trailer(trailer)
			return

static func _push_vehicle(player: Node2D, vehicle: Vehicle):
	# Толкание транспорта
	print("[VehicleInteractions] Pushing vehicle")

static func _hotwire_vehicle(player: Node2D, vehicle: Vehicle):
	# Взлом замка
	var success_chance = 0.5
	if player.has_method("get_skill_level"):
		var lockpicking = player.get_skill_level("lockpicking")
		success_chance += lockpicking * 0.1
	
	if randf() < success_chance:
		vehicle.is_locked = false
		print("[VehicleInteractions] Vehicle hotwired successfully")
	else:
		print("[VehicleInteractions] Hotwire failed")

static func _has_materials(inventory: Inventory, materials: Dictionary) -> bool:
	for item_id in materials:
		if inventory.get_item_count(item_id) < materials[item_id]:
			return false
	return true

static func _consume_materials(inventory: Inventory, materials: Dictionary):
	for item_id in materials:
		var count = materials[item_id]
		for i in range(count):
			var item = inventory.get_item_by_id(item_id)
			if item:
				inventory.remove_item(item)

static func get_available_interactions(player: Node2D, vehicle: Vehicle) -> Array[InteractionType]:
	var interactions: Array[InteractionType] = []
	
	for interaction in InteractionType.values():
		if can_interact(player, vehicle, interaction):
			interactions.append(interaction)
	
	return interactions

static func get_interaction_name(interaction: InteractionType) -> String:
	match interaction:
		InteractionType.ENTER: return "Сесть"
		InteractionType.EXIT: return "Выйти"
		InteractionType.TRUNK: return "Багажник"
		InteractionType.REPAIR: return "Ремонт"
		InteractionType.REFUEL: return "Заправка"
		InteractionType.LOCK: return "Заблокировать"
		InteractionType.UNLOCK: return "Разблокировать"
		InteractionType.TOW: return "Буксировать"
		InteractionType.ATTACH_TRAILER: return "Прицепить"
		InteractionType.DETACH_TRAILER: return "Отцепить"
		InteractionType.PUSH: return "Толкать"
		InteractionType.HOTWIRE: return "Взломать"
	return "Неизвестно"
