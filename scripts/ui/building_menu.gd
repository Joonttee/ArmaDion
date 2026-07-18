extends Control
class_name BuildingMenu

# BuildingMenu - меню строительства
# Позволяет выбирать и размещать строительные объекты

signal closed
signal build_requested(piece_type)

@onready var build_grid: GridContainer = $Panel/ScrollContainer/BuildGrid
@onready var info_label: Label = $Panel/InfoLabel

var building_manager: BuildingManager
var is_open: bool = false

# Категории построек
var categories = {
	"foundation": {
		"name": "Фундамент",
		"items": [
			{"id": "foundation", "name": "Фундамент", "cost": {"wood": 4, "nails": 2}}
		]
	},
	"walls": {
		"name": "Стены",
		"items": [
			{"id": "wall_wood", "name": "Дерев. стена", "cost": {"wood": 3, "nails": 2}},
			{"id": "wall_metal", "name": "Металл. стена", "cost": {"metal": 3, "nails": 1}},
			{"id": "wall_brick", "name": "Кирпич. стена", "cost": {"wood": 1, "metal": 1}}
		]
	},
	"structures": {
		"name": "Строения",
		"items": [
			{"id": "door", "name": "Дверь", "cost": {"wood": 2, "nails": 1, "metal": 1}},
			{"id": "storage", "name": "Сундук", "cost": {"wood": 3, "nails": 1}}
		]
	}
}

func _ready():
	visible = false
	print("[BuildingMenu] Initialized")

func open(building_mgr: BuildingManager):
	building_manager = building_mgr
	visible = true
	is_open = true
	_populate_menu()
	get_tree().paused = true

func close():
	visible = false
	is_open = false
	get_tree().paused = false
	emit_signal("closed")

func _populate_menu():
	# Очищаем сетку
	for child in build_grid.get_children():
		child.queue_free()
	
	# Добавляем категории и предметы
	for category_id in categories:
		var category = categories[category_id]
		
		# Заголовок категории
		var label = Label.new()
		label.text = "=== " + category["name"] + " ==="
		label.add_theme_font_size_override("font_size", 18)
		build_grid.add_child(label)
		
		# Предметы категории
		for item_data in category["items"]:
			var btn = Button.new()
			btn.text = item_data["name"]
			btn.custom_minimum_size = Vector2(120, 40)
			
			# Формируем текст стоимости
			var cost_text = ""
			for mat in item_data["cost"]:
				cost_text += "%s: %d " % [mat, item_data["cost"][mat]]
			
			btn.tooltip_text = "Стоимость: " + cost_text
			btn.connect("pressed", func(): _on_build_item_pressed(item_data["id"]))
			
			# Проверяем наличие материалов
			btn.disabled = not _can_afford(item_data["cost"])
			
			build_grid.add_child(btn)

func _can_afford(cost: Dictionary) -> bool:
	if not GameManager.player or not GameManager.player.inventory:
		return false
	
	for item_id in cost:
		var required = cost[item_id]
		if GameManager.player.inventory.get_item_count(item_id) < required:
			return false
	return true

func _on_build_item_pressed(piece_type: String):
	emit_signal("build_requested", piece_type)
	close()

func _input(event):
	if not is_open:
		return
	
	if event.is_action_pressed("ui_cancel"):
		close()
