extends Resource
class_name VehicleRepair

# VehicleRepair - система ремонта и улучшения транспорта

const REPAIR_KIT = {
	"small": {"name": "Малый ремкомплект", "repair": 50, "cost": {"metal": 2, "cloth": 1}},
	"medium": {"name": "Средний ремкомплект", "repair": 100, "cost": {"metal": 4, "cloth": 2, "parts": 1}},
	"large": {"name": "Большой ремкомплект", "repair": 200, "cost": {"metal": 8, "cloth": 4, "parts": 2}}
}

const UPGRADES = {
	"armor": {"name": "Бронирование", "cost": {"metal": 10, "parts": 2}, "effect": "+100 HP"},
	"engine": {"name": "Улучшенный двигатель", "cost": {"parts": 5, "metal": 4}, "effect": "+50 скорость"},
	"trunk_ext": {"name": "Расширенный багажник", "cost": {"metal": 4, "parts": 1}, "effect": "+20 мест"},
	"fuel_tank": {"name": "Дополнительный бак", "cost": {"metal": 6}, "effect": "+50 топлива"},
	"turbo": {"name": "Турбонаддув", "cost": {"parts": 8, "metal": 6}, "effect": "+100 скорость"},
	"offroad": {"name": "Внедорожник", "cost": {"parts": 4, "metal": 4}, "effect": "+управляемость"},
	"nitrous": {"name": "Нитро", "cost": {"chemicals": 4, "parts": 2}, "effect": "+150 скорость"},
	"reinforced": {"name": "Укрепление", "cost": {"metal": 12, "parts": 3}, "effect": "+200 HP"},
	"bulletproof": {"name": "Бронирование стёкол", "cost": {"metal": 8, "glass": 4}, "effect": "+150 HP"},
	"exhaust": {"name": "Выхлоп", "cost": {"metal": 3, "parts": 1}, "effect": "+скорость"},
	"tires": {"name": "Улучшенные шины", "cost": {"rubber": 4, "metal": 2}, "effect": "+сцепление"},
	"lights": {"name": "Дополнительный свет", "cost": {"wire": 2, "glass": 2, "battery": 1}, "effect": "ночное видение"},
	"radio": {"name": "Радио", "cost": {"wire": 2, "parts": 1, "electronics": 1}, "effect": "связь"},
	"alarm": {"name": "Сигнализация", "cost": {"wire": 2, "electronics": 1, "battery": 1}, "effect": "защита от угона"},
	"ram": {"name": "Ледоруб", "cost": {"metal": 6}, "effect": "+урон тараном"},
	"camo": {"name": "Камуфляж", "cost": {"cloth": 4, "paint": 2}, "effect": "скрытность"},
	"paint": {"name": "Покраска", "cost": {"paint": 2}, "effect": "внешний вид"},
	"neon": {"name": "Неон", "cost": {"wire": 2, "glass": 1, "battery": 1}, "effect": "подсветка"},
	"spoiler": {"name": "Спойлер", "cost": {"metal": 3, "plastic": 2}, "effect": "+аэродинамика"},
	"hood_scoop": {"name": "Воздухозаборник", "cost": {"metal": 4}, "effect": "+охлаждение"}
}

static func repair_vehicle(vehicle: Vehicle, kit_type: String) -> bool:
	if not REPAIR_KIT.has(kit_type):
		return false
	
	var kit = REPAIR_KIT[kit_type]
	vehicle.repair(kit["repair"])
	return true

static func can_install_upgrade(vehicle: Vehicle, upgrade_id: String) -> bool:
	if not UPGRADES.has(upgrade_id):
		return false
	if vehicle.upgrades.has(upgrade_id):
		return false
	return true

static func install_upgrade(vehicle: Vehicle, upgrade_id: String) -> bool:
	if not can_install_upgrade(vehicle, upgrade_id):
		return false
	
	vehicle.install_upgrade(upgrade_id)
	return true

static func get_upgrade_cost(upgrade_id: String) -> Dictionary:
	if UPGRADES.has(upgrade_id):
		return UPGRADES[upgrade_id].get("cost", {})
	return {}

static func get_all_upgrades() -> Array[String]:
	return UPGRADES.keys()

static func get_repairs_kits() -> Array[String]:
	return REPAIR_KIT.keys()
