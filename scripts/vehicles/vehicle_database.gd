extends Resource
class_name VehicleDatabase

# VehicleDatabase - база данных транспорта (30+ типов)

const VEHICLES = {
	# === АВТОМОБИЛИ (8 типов) ===
	"sedan": {
		"name": "Седан",
		"type": Vehicle.VehicleType.CAR,
		"health": 200,
		"fuel": 100,
		"speed": 180,
		"trunk": 20,
		"seats": 4,
		"sprite": "res://assets/sprites/vehicles/sedan.png"
	},
	"suv": {
		"name": "Внедорожник",
		"type": Vehicle.VehicleType.CAR,
		"health": 300,
		"fuel": 150,
		"speed": 150,
		"trunk": 35,
		"seats": 5,
		"sprite": "res://assets/sprites/vehicles/suv.png"
	},
	"sports_car": {
		"name": "Спорткар",
		"type": Vehicle.VehicleType.CAR,
		"health": 150,
		"fuel": 80,
		"speed": 300,
		"trunk": 10,
		"seats": 2,
		"sprite": "res://assets/sprites/vehicles/sports_car.png"
	},
	"pickup": {
		"name": "Пикап",
		"type": Vehicle.VehicleType.CAR,
		"health": 250,
		"fuel": 120,
		"speed": 160,
		"trunk": 30,
		"seats": 3,
		"trailer": true,
		"sprite": "res://assets/sprites/vehicles/pickup.png"
	},
	"hatchback": {
		"name": "Хэтчбек",
		"type": Vehicle.VehicleType.CAR,
		"health": 180,
		"fuel": 80,
		"speed": 170,
		"trunk": 18,
		"seats": 4,
		"sprite": "res://assets/sprites/vehicles/hatchback.png"
	},
	"minivan": {
		"name": "Минивэн",
		"type": Vehicle.VehicleType.CAR,
		"health": 220,
		"fuel": 100,
		"speed": 140,
		"trunk": 40,
		"seats": 7,
		"sprite": "res://assets/sprites/vehicles/minivan.png"
	},
	"coupe": {
		"name": "Купе",
		"type": Vehicle.VehicleType.CAR,
		"health": 160,
		"fuel": 90,
		"speed": 220,
		"trunk": 12,
		"seats": 2,
		"sprite": "res://assets/sprites/vehicles/coupe.png"
	},
	"convertible": {
		"name": "Кабриолет",
		"type": Vehicle.VehicleType.CAR,
		"health": 140,
		"fuel": 85,
		"speed": 200,
		"trunk": 10,
		"seats": 2,
		"sprite": "res://assets/sprites/vehicles/convertible.png"
	},
	
	# === ГРУЗОВИКИ (6 типов) ===
	"pickup_truck": {
		"name": "Пикап-грузовик",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 400,
		"fuel": 200,
		"speed": 140,
		"trunk": 50,
		"seats": 3,
		"trailer": true,
		"sprite": "res://assets/sprites/vehicles/pickup_truck.png"
	},
	"box_truck": {
		"name": "Фургон",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 500,
		"fuel": 250,
		"speed": 120,
		"trunk": 80,
		"seats": 2,
		"trailer": true,
		"sprite": "res://assets/sprites/vehicles/box_truck.png"
	},
	"flatbed": {
		"name": "Бортовой",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 450,
		"fuel": 220,
		"speed": 130,
		"trunk": 60,
		"seats": 3,
		"trailer": true,
		"sprite": "res://assets/sprites/vehicles/flatbed.png"
	},
	"tanker": {
		"name": "Цистерна",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 600,
		"fuel": 300,
		"speed": 100,
		"trunk": 100,
		"seats": 2,
		"trailer": true,
		"sprite": "res://assets/sprites/vehicles/tanker.png"
	},
	"dump_truck": {
		"name": "Самосвал",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 700,
		"fuel": 350,
		"speed": 90,
		"trunk": 120,
		"seats": 2,
		"sprite": "res://assets/sprites/vehicles/dump_truck.png"
	},
	"military_truck": {
		"name": "Военный грузовик",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 800,
		"fuel": 400,
		"speed": 110,
		"trunk": 80,
		"seats": 6,
		"trailer": true,
		"sprite": "res://assets/sprites/vehicles/military_truck.png"
	},
	
	# === АВТОБУСЫ (3 типа) ===
	"bus": {
		"name": "Автобус",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 600,
		"fuel": 300,
		"speed": 100,
		"trunk": 60,
		"seats": 20,
		"sprite": "res://assets/sprites/vehicles/bus.png"
	},
	"school_bus": {
		"name": "Школьный автобус",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 550,
		"fuel": 280,
		"speed": 90,
		"trunk": 50,
		"seats": 30,
		"sprite": "res://assets/sprites/vehicles/school_bus.png"
	},
	"rv": {
		"name": "Автодом",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 450,
		"fuel": 200,
		"speed": 110,
		"trunk": 70,
		"seats": 4,
		"trailer": true,
		"sprite": "res://assets/sprites/vehicles/rv.png"
	},
	
	# === СПЕЦТЕХНИКА (5 типов) ===
	"ambulance": {
		"name": "Скорая помощь",
		"type": Vehicle.VehicleType.CAR,
		"health": 350,
		"fuel": 150,
		"speed": 160,
		"trunk": 40,
		"seats": 4,
		"sprite": "res://assets/sprites/vehicles/ambulance.png"
	},
	"fire_truck": {
		"name": "Пожарная машина",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 700,
		"fuel": 300,
		"speed": 120,
		"trunk": 100,
		"seats": 4,
		"sprite": "res://assets/sprites/vehicles/fire_truck.png"
	},
	"police_car": {
		"name": "Полицейская машина",
		"type": Vehicle.VehicleType.CAR,
		"health": 300,
		"fuel": 120,
		"speed": 220,
		"trunk": 15,
		"seats": 4,
		"sprite": "res://assets/sprites/vehicles/police_car.png"
	},
	"tow_truck": {
		"name": "Эвакуатор",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 500,
		"fuel": 200,
		"speed": 130,
		"trunk": 30,
		"seats": 2,
		"trailer": true,
		"sprite": "res://assets/sprites/vehicles/tow_truck.png"
	},
	"bulldozer": {
		"name": "Бульдозер",
		"type": Vehicle.VehicleType.TRUCK,
		"health": 1000,
		"fuel": 400,
		"speed": 40,
		"trunk": 20,
		"seats": 1,
		"sprite": "res://assets/sprites/vehicles/bulldozer.png"
	},
	
	# === МОТОЦИКЛЫ (4 типа) ===
	"motorcycle": {
		"name": "Мотоцикл",
		"type": Vehicle.VehicleType.MOTORCYCLE,
		"health": 80,
		"fuel": 30,
		"speed": 250,
		"trunk": 5,
		"seats": 1,
		"sprite": "res://assets/sprites/vehicles/motorcycle.png"
	},
	"sport_bike": {
		"name": "Спортбайк",
		"type": Vehicle.VehicleType.MOTORCYCLE,
		"health": 60,
		"fuel": 25,
		"speed": 320,
		"trunk": 3,
		"seats": 1,
		"sprite": "res://assets/sprites/vehicles/sport_bike.png"
	},
	"chopper": {
		"name": "Чоппер",
		"type": Vehicle.VehicleType.MOTORCYCLE,
		"health": 100,
		"fuel": 40,
		"speed": 180,
		"trunk": 8,
		"seats": 1,
		"sprite": "res://assets/sprites/vehicles/chopper.png"
	},
	"scooter": {
		"name": "Скутер",
		"type": Vehicle.VehicleType.MOTORCYCLE,
		"health": 40,
		"fuel": 15,
		"speed": 80,
		"trunk": 4,
		"seats": 1,
		"sprite": "res://assets/sprites/vehicles/scooter.png"
	},
	
	# === ВЕЛОСИПЕДЫ (3 типа) ===
	"bicycle": {
		"name": "Велосипед",
		"type": Vehicle.VehicleType.BICYCLE,
		"health": 30,
		"fuel": 0,
		"fuel_type": Vehicle.FuelType.NONE,
		"speed": 50,
		"trunk": 2,
		"seats": 1,
		"sprite": "res://assets/sprites/vehicles/bicycle.png"
	},
	"mountain_bike": {
		"name": "Горный велосипед",
		"type": Vehicle.VehicleType.BICYCLE,
		"health": 40,
		"fuel": 0,
		"fuel_type": Vehicle.FuelType.NONE,
		"speed": 60,
		"trunk": 3,
		"seats": 1,
		"sprite": "res://assets/sprites/vehicles/mountain_bike.png"
	},
	"electric_bike": {
		"name": "Электровелосипед",
		"type": Vehicle.VehicleType.BICYCLE,
		"health": 50,
		"fuel": 20,
		"fuel_type": Vehicle.FuelType.ELECTRIC,
		"speed": 70,
		"trunk": 4,
		"seats": 1,
		"sprite": "res://assets/sprites/vehicles/electric_bike.png"
	},
	
	# === ATV (2 типа) ===
	"atv": {
		"name": "Квадроцикл",
		"type": Vehicle.VehicleType.ATV,
		"health": 150,
		"fuel": 50,
		"speed": 120,
		"trunk": 10,
		"seats": 2,
		"sprite": "res://assets/sprites/vehicles/atv.png"
	},
	"utv": {
		"name": "UTV",
		"type": Vehicle.VehicleType.ATV,
		"health": 200,
		"fuel": 60,
		"speed": 100,
		"trunk": 25,
		"seats": 4,
		"sprite": "res://assets/sprites/vehicles/utv.png"
	},
	
	# === ВЕРТОЛЁТЫ (3 типа) ===
	"helicopter": {
		"name": "Вертолёт",
		"type": Vehicle.VehicleType.HELICOPTER,
		"health": 300,
		"fuel": 150,
		"speed": 300,
		"trunk": 15,
		"seats": 4,
		"sprite": "res://assets/sprites/vehicles/helicopter.png"
	},
	"cargo_heli": {
		"name": "Грузовой вертолёт",
		"type": Vehicle.VehicleType.HELICOPTER,
		"health": 500,
		"fuel": 250,
		"speed": 200,
		"trunk": 50,
		"seats": 2,
		"sprite": "res://assets/sprites/vehicles/cargo_heli.png"
	},
	"attack_heli": {
		"name": "Ударный вертолёт",
		"type": Vehicle.VehicleType.HELICOPTER,
		"health": 600,
		"fuel": 200,
		"speed": 350,
		"trunk": 10,
		"seats": 2,
		"sprite": "res://assets/sprites/vehicles/attack_heli.png"
	},
	
	# === ЛОДКИ (4 типа) ===
	"motorboat": {
		"name": "Моторная лодка",
		"type": Vehicle.VehicleType.BOAT,
		"health": 150,
		"fuel": 60,
		"speed": 80,
		"trunk": 20,
		"seats": 4,
		"sprite": "res://assets/sprites/vehicles/motorboat.png"
	},
	"speedboat": {
		"name": "Скоростная лодка",
		"type": Vehicle.VehicleType.BOAT,
		"health": 120,
		"fuel": 80,
		"speed": 150,
		"trunk": 10,
		"seats": 3,
		"sprite": "res://assets/sprites/vehicles/speedboat.png"
	},
	"yacht": {
		"name": "Яхта",
		"type": Vehicle.VehicleType.BOAT,
		"health": 400,
		"fuel": 200,
		"speed": 100,
		"trunk": 80,
		"seats": 10,
		"sprite": "res://assets/sprites/vehicles/yacht.png"
	},
	"inflatable": {
		"name": "Надувная лодка",
		"type": Vehicle.VehicleType.BOAT,
		"health": 50,
		"fuel": 20,
		"speed": 40,
		"trunk": 15,
		"seats": 3,
		"sprite": "res://assets/sprites/vehicles/inflatable.png"
	},
	
	# === ПРИЦЕПЫ (5 типов) ===
	"small_trailer": {
		"name": "Малый прицеп",
		"type": Vehicle.VehicleType.TRAILER,
		"health": 100,
		"fuel": 0,
		"fuel_type": Vehicle.FuelType.NONE,
		"speed": 0,
		"trunk": 50,
		"seats": 0,
		"sprite": "res://assets/sprites/vehicles/small_trailer.png"
	},
	"large_trailer": {
		"name": "Большой прицеп",
		"type": Vehicle.VehicleType.TRAILER,
		"health": 200,
		"fuel": 0,
		"fuel_type": Vehicle.FuelType.NONE,
		"speed": 0,
		"trunk": 150,
		"seats": 0,
		"sprite": "res://assets/sprites/vehicles/large_trailer.png"
	},
	"fuel_trailer": {
		"name": "Цистерна-прицеп",
		"type": Vehicle.VehicleType.TRAILER,
		"health": 250,
		"fuel": 0,
		"fuel_type": Vehicle.FuelType.NONE,
		"speed": 0,
		"trunk": 200,
		"seats": 0,
		"sprite": "res://assets/sprites/vehicles/fuel_trailer.png"
	},
	"car_carrier": {
		"name": "Автовоз",
		"type": Vehicle.VehicleType.TRAILER,
		"health": 300,
		"fuel": 0,
		"fuel_type": Vehicle.FuelType.NONE,
		"speed": 0,
		"trunk": 100,
		"seats": 0,
		"sprite": "res://assets/sprites/vehicles/car_carrier.png"
	},
	"mobile_home": {
		"name": "Передвижной дом",
		"type": Vehicle.VehicleType.TRAILER,
		"health": 350,
		"fuel": 0,
		"fuel_type": Vehicle.FuelType.NONE,
		"speed": 0,
		"trunk": 80,
		"seats": 0,
		"sprite": "res://assets/sprites/vehicles/mobile_home.png"
	}
}

static func get_vehicle_data(vehicle_id: String) -> Dictionary:
	return VEHICLES.get(vehicle_id, {})

static func get_all_vehicle_ids() -> Array:
	return VEHICLES.keys()

static func get_vehicles_by_type(type: Vehicle.VehicleType) -> Array:
	var result = []
	for id in VEHICLES:
		if VEHICLES[id]["type"] == type:
			result.append(id)
	return result

static func get_vehicles_with_trailer() -> Array:
	var result = []
	for id in VEHICLES:
		if VEHICLES[id].get("trailer", false):
			result.append(id)
	return result
