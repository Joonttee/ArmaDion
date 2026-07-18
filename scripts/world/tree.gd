extends StaticBody2D
class_name Tree

# Tree - дерево в мире
# Можно срубить для получения дерева

@export var health: float = 30.0
@export var wood_drop_count: int = 3

signal tree_cut(tree)

func _ready():
	print("[Tree] Tree ready")

func take_damage(amount: float):
	health -= amount
	print("[Tree] Tree took %.1f damage, health: %.1f" % [amount, health])
	
	if health <= 0:
		_cut_down()

func _cut_down():
	print("[Tree] Tree cut down!")
	emit_signal("tree_cut", self)
	
	# Создаём древесину
	for i in range(wood_drop_count):
		var wood = Item.new()
		wood.item_id = "wood"
		wood.item_name = "Дерево"
		# В реальном проекте создаём объект на земле
	
	queue_free()

func interact(player: Node2D):
	# Взаимодействие с деревом (рубка)
	print("[Tree] Interacting with tree")
	take_damage(player.attack_damage if "attack_damage" in player else 10.0)
