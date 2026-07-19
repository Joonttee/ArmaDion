extends Resource
class_name VehicleStorage

# VehicleStorage - сохранение и загрузка транспорта

const SAVE_PATH = "user://saves/vehicles.save"

func save_vehicles(vehicles: Array[Vehicle]):
	var data = []
	for vehicle in vehicles:
		data.append(vehicle.serialize())
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		print("[VehicleStorage] Saved %d vehicles" % vehicles.size())

func load_vehicles() -> Array:
	if not FileAccess.file_exists(SAVE_PATH):
		return []
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return []
	
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()
	
	if error != OK:
		return []
	
	return json.data

func clear_storage():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
