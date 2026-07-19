extends RefCounted
class_name DialogueBuilder

# DialogueBuilder - построитель диалогов
# Создаёт сложные диалоговые деревья

static func create_simple_dialogue(npc_name: String, lines: Array[String]) -> DialogueTree:
	var tree = DialogueTree.new()
	tree.start_node = "start"
	
	var current = DialogueNode.new()
	current.node_id = "start"
	current.speaker = npc_name
	current.text = lines[0]
	
	if lines.size() > 1:
		current.auto_next = "line_2"
	else:
		current.is_end = true
	
	tree.add_node(current)
	
	for i in range(1, lines.size()):
		var node = DialogueNode.new()
		node.node_id = "line_" + str(i + 1)
		node.speaker = npc_name
		node.text = lines[i]
		
		if i < lines.size() - 1:
			node.auto_next = "line_" + str(i + 2)
		else:
			node.is_end = true
		
		tree.add_node(node)
	
	return tree

static func create_quest_dialogue(npc_name: String, quest_title: String, quest_desc: String, quest_id: String) -> DialogueTree:
	var tree = DialogueTree.new()
	tree.start_node = "start"
	
	# Начало
	var start = DialogueNode.new()
	start.node_id = "start"
	start.speaker = npc_name
	start.text = "У меня есть для тебя задание."
	start.auto_next = "quest_offer"
	tree.add_node(start)
	
	# Описание квеста
	var offer = DialogueNode.new()
	offer.node_id = "quest_offer"
	offer.speaker = npc_name
	offer.text = quest_title + ": " + quest_desc
	offer.choices = [
		{"text": "Я согласен", "next_node": "accept", "effect": "start_quest:" + quest_id},
		{"text": "Мне нужно подумать", "next_node": "decline"},
		{"text": "Это слишком опасно", "next_node": "decline"}
	]
	tree.add_node(offer)
	
	# Принятие
	var accept = DialogueNode.new()
	accept.node_id = "accept"
	accept.speaker = npc_name
	accept.text = "Отлично! Удачи."
	accept.is_end = true
	tree.add_node(accept)
	
	# Отказ
	var decline = DialogueNode.new()
	decline.node_id = "decline"
	decline.speaker = npc_name
	decline.text = "Как знаешь. Если передумаешь - возвращайся."
	decline.is_end = true
	tree.add_node(decline)
	
	return tree

static func create_trade_dialogue(npc_name: String) -> DialogueTree:
	var tree = DialogueTree.new()
	tree.start_node = "start"
	
	var start = DialogueNode.new()
	start.node_id = "start"
	start.speaker = npc_name
	start.text = "Что тебе нужно?"
	start.choices = [
		{"text": "Показать товары", "next_node": "buy"},
		{"text": "У меня есть товары на продажу", "next_node": "sell"},
		{"text": "Есть информация?", "next_node": "info"},
		{"text": "До свидания", "next_node": "end"}
	]
	tree.add_node(start)
	
	var buy = DialogueNode.new()
	buy.node_id = "buy"
	buy.speaker = npc_name
	buy.text = "Вот что у меня есть..."
	buy.on_enter_effect = "open_trade"
	buy.auto_next = "after_trade"
	tree.add_node(buy)
	
	var sell = DialogueNode.new()
	sell.node_id = "sell"
	sell.speaker = npc_name
	sell.text = "Покажи что у тебя есть."
	sell.on_enter_effect = "open_sell"
	sell.auto_next = "after_trade"
	tree.add_node(sell)
	
	var after_trade = DialogueNode.new()
	after_trade.node_id = "after_trade"
	after_trade.speaker = npc_name
	after_trade.text = "Что-нибудь ещё?"
	after_trade.choices = [
		{"text": "Есть информация?", "next_node": "info"},
		{"text": "Нет, спасибо", "next_node": "end"}
	]
	tree.add_node(after_trade)
	
	var info = DialogueNode.new()
	info.node_id = "info"
	info.speaker = npc_name
	info.text = "Информация стоит денег."
	info.choices = [
		{"text": "Сколько?", "next_node": "info_price"},
		{"text": "Не интересно", "next_node": "end"}
	]
	tree.add_node(info)
	
	var info_price = DialogueNode.new()
	info_price.node_id = "info_price"
	info_price.speaker = npc_name
	info_price.text = "50 монет за полезные сведения."
	info_price.choices = [
		{"text": "Договорились", "next_node": "end", "effect": "give_info:general"},
		{"text": "Слишком дорого", "next_node": "end"}
	]
	tree.add_node(info_price)
	
	var end_node = DialogueNode.new()
	end_node.node_id = "end"
	end_node.speaker = npc_name
	end_node.text = "Было приятно поговорить."
	end_node.is_end = true
	tree.add_node(end_node)
	
	return tree

static func create_gossip_dialogue(npc_name: String, gossip_lines: Array[String]) -> DialogueTree:
	var tree = DialogueTree.new()
	tree.start_node = "start"
	
	var start = DialogueNode.new()
	start.node_id = "start"
	start.speaker = npc_name
	start.text = "Хочешь послушать сплетни?"
	start.choices = [
		{"text": "Да, рассказывай", "next_node": "gossip_1"},
		{"text": "Нет, спасибо", "next_node": "end"}
	]
	tree.add_node(start)
	
	for i in range(gossip_lines.size()):
		var node = DialogueNode.new()
		node.node_id = "gossip_" + str(i + 1)
		node.speaker = npc_name
		node.text = gossip_lines[i]
		
		if i < gossip_lines.size() - 1:
			node.choices = [
				{"text": "Ещё?", "next_node": "gossip_" + str(i + 2)},
				{"text": "Спасибо", "next_node": "end"}
			]
		else:
			node.is_end = true
		
		tree.add_node(node)
	
	var end_node = DialogueNode.new()
	end_node.node_id = "end"
	end_node.speaker = npc_name
	end_node.text = "Возвращайся если захочешь послушать ещё."
	end_node.is_end = true
	tree.add_node(end_node)
	
	return tree
