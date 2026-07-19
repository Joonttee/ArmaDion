extends Node

# QuestManager - менеджер квестов
# Управляет всеми квестами и их прогрессом

signal quest_offered(quest)
signal quest_accepted(quest)
signal quest_completed(quest, rewards)
signal quest_failed(quest)
signal quest_turned_in(quest)

var available_quests: Array[Quest] = []
var active_quests: Array[Quest] = []
var completed_quests: Array[String] = []
var failed_quests: Array[String] = []

# Шаблоны квестов
var quest_templates: Dictionary = {}

func _ready():
	_initialize_quest_templates()
	print("[QuestManager] Initialized")

func _process(delta):
	_update_quest_timers(delta)

func _update_quest_timers(delta):
	for quest in active_quests:
		quest.update_timer(delta)

func _initialize_quest_templates():
	# === КВЕСТЫ НА УБИЙСТВО ===
	_add_template("kill_zombies_5", {
		"title": "Очистка территории",
		"description": "Убейте 5 зомби в окрестностях.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "zombie",
		"target_count": 5,
		"reward_xp": 50,
		"reward_items": {"bandage": 2},
		"reward_money": 20,
		"reward_reputation": 10
	})
	
	_add_template("kill_runner", {
		"title": "Охота на бегуна",
		"description": "Уничтожьте зомби-бегуна, который терроризирует район.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "runner",
		"target_count": 1,
		"reward_xp": 100,
		"reward_items": {"bat": 1},
		"reward_money": 50,
		"reward_reputation": 20
	})
	
	_add_template("kill_boss", {
		"title": "Босс зомби",
		"description": "Найдите и уничтожьте огромного зомби-танка.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "tank",
		"target_count": 1,
		"reward_xp": 200,
		"reward_items": {"metal": 5},
		"reward_money": 100,
		"reward_reputation": 30,
		"required_level": 5
	})
	
	# === КВЕСТЫ НА СБОР ===
	_add_template("fetch_food", {
		"title": "Сбор припасов",
		"description": "Соберите 3 банки консервов для лагеря.",
		"type": Quest.Type.FETCH,
		"target_item_id": "canned_food",
		"target_count": 3,
		"reward_xp": 30,
		"reward_items": {"water_bottle": 2},
		"reward_money": 15,
		"reward_reputation": 5
	})
	
	_add_template("fetch_medicine", {
		"title": "Лекарства",
		"description": "Найдите 5 бинтов для раненых.",
		"type": Quest.Type.FETCH,
		"target_item_id": "bandage",
		"target_count": 5,
		"reward_xp": 60,
		"reward_items": {"first_aid_kit": 1},
		"reward_money": 30,
		"reward_reputation": 15
	})
	
	_add_template("fetch_materials", {
		"title": "Строительные материалы",
		"description": "Принесите 10 досок для укрепления лагеря.",
		"type": Quest.Type.FETCH,
		"target_item_id": "wood",
		"target_count": 10,
		"reward_xp": 40,
		"reward_items": {"nails": 20},
		"reward_money": 25,
		"reward_reputation": 10
	})
	
	_add_template("fetch_samples", {
		"title": "Образцы тканей",
		"description": "Принесите 3 образца тканей заражённых для исследований.",
		"type": Quest.Type.FETCH,
		"target_item_id": "cloth",
		"target_count": 3,
		"reward_xp": 80,
		"reward_items": {"pills": 5},
		"reward_money": 40,
		"reward_reputation": 15,
		"reward_faction_id": "scientists"
	})
	
	# === КВЕСТЫ НА ИССЛЕДОВАНИЕ ===
	_add_template("explore_hospital", {
		"title": "Разведка больницы",
		"description": "Исследуйте заброшенную больницу на севере.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(500, -300),
		"target_radius": 100.0,
		"reward_xp": 80,
		"reward_items": {"pills": 5},
		"reward_money": 40,
		"reward_reputation": 15
	})
	
	_add_template("explore_mall", {
		"title": "Торговый центр",
		"description": "Найдите торговый центр и обыщите его.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(-400, 600),
		"target_radius": 150.0,
		"reward_xp": 100,
		"reward_money": 75,
		"reward_reputation": 20,
		"required_level": 3
	})
	
	# === КВЕСТЫ НА КРАФТ ===
	_add_template("craft_weapon", {
		"title": "Оружие для ополчения",
		"description": "Скрафтите 2 биты для ополчения.",
		"type": Quest.Type.CRAFT,
		"target_item_id": "bat",
		"target_count": 2,
		"reward_xp": 60,
		"reward_items": {"metal": 5},
		"reward_money": 35,
		"reward_reputation": 15
	})
	
	# === КВЕСТЫ НА ЗАЩИТУ ===
	_add_template("defend_farm", {
		"title": "Защита фермы",
		"description": "Защитите ферму от зомби.",
		"type": Quest.Type.DEFEND,
		"target_enemy_type": "zombie",
		"target_count": 8,
		"reward_xp": 100,
		"reward_items": {"carrot": 5, "potato": 5},
		"reward_money": 50,
		"reward_reputation": 20
	})
	
	# === КВЕСТЫ НА ДОСТАВКУ ===
	_add_template("deliver_message", {
		"title": "Посылка",
		"description": "Доставьте сообщение торговцу на востоке.",
		"type": Quest.Type.DELIVER,
		"target_npc_id": "trader_east",
		"reward_xp": 40,
		"reward_money": 25,
		"reward_reputation": 10
	})
	
	# === КВЕСТЫ НА РАЗГОВОР ===
	_add_template("talk_to_survivors", {
		"title": "Переговоры",
		"description": "Поговорите с выжившими в лагере.",
		"type": Quest.Type.TALK,
		"target_dialogue": "survivor_leader",
		"reward_xp": 30,
		"reward_reputation": 10
	})
	
	# === ЦЕПОЧКИ КВЕСТОВ ===
	_add_template("kill_scout_leader", {
		"title": "Лидер разведчиков",
		"description": "Найдите и уничтожьте лидера разведчиков зомби.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "screamer",
		"target_count": 1,
		"reward_xp": 150,
		"reward_items": {"map": 1},
		"reward_money": 75,
		"reward_reputation": 25,
		"next_quest_id": "explore_base"
	})
	
	_add_template("explore_base", {
		"title": "Заброшенная база",
		"description": "Исследуйте заброшенную военную базу.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(800, -600),
		"target_radius": 200.0,
		"reward_xp": 200,
		"reward_items": {"weapon_parts": 3},
		"reward_money": 100,
		"reward_reputation": 30,
		"required_quests": ["kill_scout_leader"]
	})
	
	# === КВЕСТЫ С ТАЙМЕРОМ ===
	_add_template("rescue_timer", {
		"title": "Срочное спасение",
		"description": "Спасите выживших до прибытия зомби!",
		"type": Quest.Type.ESCORT,
		"target_npc_id": "refugee_group",
		"target_count": 3,
		"reward_xp": 120,
		"reward_items": {"food": 5},
		"reward_money": 60,
		"reward_reputation": 20,
		"has_time_limit": true,
		"time_limit": 300.0
	})
	
	# === СЛОЖНЫЕ КВЕСТЫ ===
	_add_template("clear_hospital", {
		"title": "Зачистка больницы",
		"description": "Очистите больницу от зомби и найдите медикаменты.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "zombie",
		"target_count": 15,
		"reward_xp": 200,
		"reward_items": {"first_aid_kit": 3, "pills": 10},
		"reward_money": 100,
		"reward_reputation": 30,
		"required_level": 5
	})
	
	_add_template("find_lab", {
		"title": "Секретная лаборатория",
		"description": "Найдите скрытую лабораторию учёных.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(-800, 400),
		"target_radius": 150.0,
		"reward_xp": 150,
		"reward_items": {"research_data": 1},
		"reward_money": 80,
		"reward_reputation": 25,
		"reward_faction_id": "scientists"
	})
	
	_add_template("escort_caravan", {
		"title": "Сопровождение каравана",
		"description": "Сопроводите торговый караван до безопасной зоны.",
		"type": Quest.Type.ESCORT,
		"target_npc_id": "caravan",
		"target_count": 1,
		"reward_xp": 180,
		"reward_items": {"metal": 10, "cloth": 10},
		"reward_money": 150,
		"reward_reputation": 35,
		"required_level": 4
	})
	
	_add_template("craft_armor", {
		"title": "Броня для ополчения",
		"description": "Создайте 3 комплекта брони для ополчения.",
		"type": Quest.Type.CRAFT,
		"target_item_id": "armor",
		"target_count": 3,
		"reward_xp": 100,
		"reward_items": {"metal": 15},
		"reward_money": 70,
		"reward_reputation": 20
	})
	
	_add_template("kill_spitter", {
		"title": "Опасный враг",
		"description": "Уничтожьте 5 плюющихся зомби.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "spitter",
		"target_count": 5,
		"reward_xp": 120,
		"reward_items": {"antidote": 3},
		"reward_money": 60,
		"reward_reputation": 15
	})
	
	_add_template("kill_screamer", {
		"title": "Тихая ночь",
		"description": "Уничтожьте 3 крикуна, привлекающих зомби.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "screamer",
		"target_count": 3,
		"reward_xp": 140,
		"reward_items": {"earplugs": 1},
		"reward_money": 70,
		"reward_reputation": 20
	})
	
	_add_template("deliver_supplies", {
		"title": "Поставка припасов",
		"description": "Доставьте припасы в отдалённый лагерь.",
		"type": Quest.Type.DELIVER,
		"target_npc_id": "camp_leader",
		"reward_xp": 60,
		"reward_money": 40,
		"reward_reputation": 15
	})
	
	_add_template("find_survivors", {
		"title": "Поиск выживших",
		"description": "Найдите группу выживших в заброшенном здании.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(300, -500),
		"target_radius": 100.0,
		"reward_xp": 90,
		"reward_items": {"food": 8},
		"reward_money": 45,
		"reward_reputation": 20
	})
	
	_add_template("defend_base", {
		"title": "Оборона базы",
		"description": "Защитите базу от волны зомби.",
		"type": Quest.Type.DEFEND,
		"target_enemy_type": "zombie",
		"target_count": 20,
		"reward_xp": 250,
		"reward_items": {"weapon_parts": 5},
		"reward_money": 120,
		"reward_reputation": 40,
		"required_level": 6
	})
	
	_add_template("talk_hermit", {
		"title": "Мудрость отшельника",
		"description": "Поговорите с отшельником о выживании.",
		"type": Quest.Type.TALK,
		"target_dialogue": "hermit_wisdom",
		"reward_xp": 50,
		"reward_items": {"map": 1},
		"reward_reputation": 10
	})
	
	_add_template("clear_warehouse", {
		"title": "Очистка склада",
		"description": "Очистите склад от зомби и соберите ресурсы.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "zombie",
		"target_count": 10,
		"reward_xp": 130,
		"reward_items": {"wood": 20, "metal": 15},
		"reward_money": 80,
		"reward_reputation": 25
	})
	
	# === НОВЫЕ КВЕСТЫ ===
	_add_template("find_water", {
		"title": "Поиск воды",
		"description": "Найдите источник чистой воды для лагеря.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(-200, -400),
		"target_radius": 80.0,
		"reward_xp": 70,
		"reward_items": {"water_bottle": 10},
		"reward_money": 35,
		"reward_reputation": 15
	})
	
	_add_template("kill_mutant", {
		"title": "Мутант",
		"description": "Уничтожьте опасного мутанта-зомби.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "tank",
		"target_count": 1,
		"reward_xp": 180,
		"reward_items": {"mutant_sample": 1},
		"reward_money": 90,
		"reward_reputation": 30,
		"required_level": 4
	})
	
	_add_template("collect_herbs", {
		"title": "Сбор трав",
		"description": "Соберите 5 целебных трав для врача.",
		"type": Quest.Type.FETCH,
		"target_item_id": "herbs",
		"target_count": 5,
		"reward_xp": 45,
		"reward_items": {"pills": 3},
		"reward_money": 20,
		"reward_reputation": 10
	})
	
	_add_template("rescue_hostage", {
		"title": "Спасение заложника",
		"description": "Спасите пленника из рук бандитов.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "bandit",
		"target_count": 3,
		"reward_xp": 160,
		"reward_items": {"weapon": 1},
		"reward_money": 80,
		"reward_reputation": 35,
		"reward_faction_id": "militia"
	})
	
	_add_template("deliver_medicine", {
		"title": "Доставка лекарств",
		"description": "Доставьте лекарства в больницу.",
		"type": Quest.Type.DELIVER,
		"target_npc_id": "hospital_doctor",
		"reward_xp": 55,
		"reward_money": 30,
		"reward_reputation": 15
	})
	
	_add_template("craft_tools", {
		"title": "Создание инструментов",
		"description": "Скрафтите 3 молотка для строительства.",
		"type": Quest.Type.CRAFT,
		"target_item_id": "hammer",
		"target_count": 3,
		"reward_xp": 70,
		"reward_items": {"metal": 10},
		"reward_money": 40,
		"reward_reputation": 12
	})
	
	_add_template("patrol_area", {
		"title": "Патрулирование",
		"description": "Патрулируйте территорию и уничтожьте 8 зомби.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "zombie",
		"target_count": 8,
		"reward_xp": 90,
		"reward_items": {"ammo": 20},
		"reward_money": 45,
		"reward_reputation": 20
	})
	
	_add_template("find_ammo", {
		"title": "Поиск боеприпасов",
		"description": "Найдите 10 коробок патронов.",
		"type": Quest.Type.FETCH,
		"target_item_id": "ammo",
		"target_count": 10,
		"reward_xp": 65,
		"reward_items": {"weapon": 1},
		"reward_money": 35,
		"reward_reputation": 15
	})
	
	_add_template("defend_convoy", {
		"title": "Защита конвоя",
		"description": "Защитите конвой от нападения зомби.",
		"type": Quest.Type.DEFEND,
		"target_enemy_type": "zombie",
		"target_count": 12,
		"reward_xp": 200,
		"reward_items": {"food": 10, "medicine": 5},
		"reward_money": 100,
		"reward_reputation": 40,
		"required_level": 5
	})
	
	_add_template("talk_elder", {
		"title": "Совет старейшины",
		"description": "Поговорите со старейшиной поселения.",
		"type": Quest.Type.TALK,
		"target_dialogue": "village_elder",
		"reward_xp": 40,
		"reward_reputation": 15
	})
	
	_add_template("explore_ruins", {
		"title": "Исследование руин",
		"description": "Исследуйте руины старого города.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(600, 800),
		"target_radius": 200.0,
		"reward_xp": 110,
		"reward_items": {"ancient_artifact": 1},
		"reward_money": 55,
		"reward_reputation": 25,
		"required_level": 3
	})
	
	_add_template("kill_pack", {
		"title": "Стая зомби",
		"description": "Уничтожьте стаю из 25 зомби.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "zombie",
		"target_count": 25,
		"reward_xp": 300,
		"reward_items": {"rare_weapon": 1},
		"reward_money": 150,
		"reward_reputation": 50,
		"required_level": 7
	})
	
	# === ДОПОЛНИТЕЛЬНЫЕ КВЕСТЫ ===
	_add_template("find_shelter", {
		"title": "Поиск укрытия",
		"description": "Найдите безопасное убежище для беженцев.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(-500, -700),
		"target_radius": 120.0,
		"reward_xp": 85,
		"reward_items": {"building_materials": 10},
		"reward_money": 45,
		"reward_reputation": 20
	})
	
	_add_template("kill_night_stalker", {
		"title": "Ночной охотник",
		"description": "Уничтожьте редкого ночного зомби.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "runner",
		"target_count": 3,
		"reward_xp": 170,
		"reward_items": {"night_vision": 1},
		"reward_money": 85,
		"reward_reputation": 30,
		"required_level": 5
	})
	
	_add_template("collect_food", {
		"title": "Сбор провизии",
		"description": "Соберите 15 единиц еды для лагеря.",
		"type": Quest.Type.FETCH,
		"target_item_id": "food",
		"target_count": 15,
		"reward_xp": 75,
		"reward_items": {"water": 10},
		"reward_money": 35,
		"reward_reputation": 15
	})
	
	_add_template("repair_generator", {
		"title": "Ремонт генератора",
		"description": "Найдите запчасти и почините генератор.",
		"type": Quest.Type.CRAFT,
		"target_item_id": "generator_parts",
		"target_count": 5,
		"reward_xp": 120,
		"reward_items": {"fuel": 5},
		"reward_money": 60,
		"reward_reputation": 25
	})
	
	_add_template("escort_scientist", {
		"title": "Сопровождение учёного",
		"description": "Сопроводите учёного до лаборатории.",
		"type": Quest.Type.ESCORT,
		"target_npc_id": "scientist_target",
		"reward_xp": 140,
		"reward_items": {"research_notes": 1},
		"reward_money": 70,
		"reward_reputation": 30,
		"required_level": 4
	})
	
	_add_template("clear_school", {
		"title": "Очистка школы",
		"description": "Очистите школу от зомби для детей.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "zombie",
		"target_count": 18,
		"reward_xp": 220,
		"reward_items": {"books": 5, "medicine": 10},
		"reward_money": 110,
		"reward_reputation": 45,
		"required_level": 6
	})
	
	_add_template("find_vehicle", {
		"title": "Поиск транспорта",
		"description": "Найдите работающий автомобиль.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(900, 200),
		"target_radius": 150.0,
		"reward_xp": 95,
		"reward_items": {"car_keys": 1, "fuel": 10},
		"reward_money": 50,
		"reward_reputation": 20
	})
	
	_add_template("defend_hospital", {
		"title": "Оборона больницы",
		"description": "Защитите больницу от атаки зомби.",
		"type": Quest.Type.DEFEND,
		"target_enemy_type": "zombie",
		"target_count": 30,
		"reward_xp": 280,
		"reward_items": {"medication": 20},
		"reward_money": 140,
		"reward_reputation": 50,
		"required_level": 7
	})
	
	_add_template("talk_prisoner", {
		"title": "Допрос заключённого",
		"description": "Допросите пленного бандита.",
		"type": Quest.Type.TALK,
		"target_dialogue": "bandit_prisoner",
		"reward_xp": 60,
		"reward_items": {"map": 1},
		"reward_reputation": 15
	})
	
	_add_template("craft_explosives", {
		"title": "Создание взрывчатки",
		"description": "Создайте 5 бомб для зачистки.",
		"type": Quest.Type.CRAFT,
		"target_item_id": "bomb",
		"target_count": 5,
		"reward_xp": 100,
		"reward_items": {"detonator": 5},
		"reward_money": 55,
		"reward_reputation": 20
	})
	
	_add_template("kill_alpha", {
		"title": "Альфа-зомби",
		"description": "Уничтожьте лидера стаи зомби.",
		"type": Quest.Type.KILL,
		"target_enemy_type": "tank",
		"target_count": 2,
		"reward_xp": 350,
		"reward_items": {"alpha_sample": 1, "rare_weapon": 1},
		"reward_money": 175,
		"reward_reputation": 60,
		"required_level": 8
	})
	
	_add_template("deliver_weapon", {
		"title": "Поставка оружия",
		"description": "Доставьте оружие в отряд ополчения.",
		"type": Quest.Type.DELIVER,
		"target_npc_id": "militia_leader",
		"reward_xp": 80,
		"reward_money": 50,
		"reward_reputation": 25
	})
	
	_add_template("explore_mine", {
		"title": "Исследование шахты",
		"description": "Исследуйте заброшенную шахту.",
		"type": Quest.Type.EXPLORE,
		"target_position": Vector2(-1000, -500),
		"target_radius": 200.0,
		"reward_xp": 130,
		"reward_items": {"gems": 5, "metal": 30},
		"reward_money": 65,
		"reward_reputation": 30,
		"required_level": 5
	})
	
	_add_template("collect_electronics", {
		"title": "Сбор электроники",
		"description": "Соберите 10 электронных компонентов.",
		"type": Quest.Type.FETCH,
		"target_item_id": "electronics",
		"target_count": 10,
		"reward_xp": 85,
		"reward_items": {"battery": 5},
		"reward_money": 45,
		"reward_reputation": 18
	})
	
	# === МАКСИМАЛЬНОЕ КОЛИЧЕСТВО КВЕСТОВ ===
	
	# Убийство (20 квестов)
	_add_template("kill_zombies_basic", {"title": "Базовая зачистка", "description": "Убейте 5 зомби.", "type": Quest.Type.KILL, "target_enemy_type": "zombie", "target_count": 5, "reward_xp": 50, "reward_money": 25})
	_add_template("kill_zombies_medium", {"title": "Средняя зачистка", "description": "Убейте 10 зомби.", "type": Quest.Type.KILL, "target_enemy_type": "zombie", "target_count": 10, "reward_xp": 100, "reward_money": 50, "required_level": 3})
	_add_template("kill_zombies_hard", {"title": "Тяжёлая зачистка", "description": "Убейте 20 зомби.", "type": Quest.Type.KILL, "target_enemy_type": "zombie", "target_count": 20, "reward_xp": 200, "reward_money": 100, "required_level": 5})
	_add_template("kill_zombies_extreme", {"title": "Экстремальная зачистка", "description": "Убейте 50 зомби.", "type": Quest.Type.KILL, "target_enemy_type": "zombie", "target_count": 50, "reward_xp": 500, "reward_money": 250, "required_level": 8})
	_add_template("kill_runners", {"title": "Охота на бегунов", "description": "Убейте 5 зомби-бегунов.", "type": Quest.Type.KILL, "target_enemy_type": "runner", "target_count": 5, "reward_xp": 150, "reward_money": 75, "required_level": 4})
	_add_template("kill_tanks", {"title": "Уничтожение танков", "description": "Убейте 3 зомби-танка.", "type": Quest.Type.KILL, "target_enemy_type": "tank", "target_count": 3, "reward_xp": 250, "reward_money": 125, "required_level": 6})
	_add_template("kill_spitters", {"title": "Опасные враги", "description": "Убейте 5 плюющихся зомби.", "type": Quest.Type.KILL, "target_enemy_type": "spitter", "target_count": 5, "reward_xp": 120, "reward_money": 60})
	_add_template("kill_screamers", {"title": "Тихая ночь", "description": "Убейте 3 крикуна.", "type": Quest.Type.KILL, "target_enemy_type": "screamer", "target_count": 3, "reward_xp": 140, "reward_money": 70})
	_add_template("kill_mutants", {"title": "Мутанты", "description": "Убейте 5 мутантов.", "type": Quest.Type.KILL, "target_enemy_type": "mutant", "target_count": 5, "reward_xp": 200, "reward_money": 100, "required_level": 5})
	_add_template("kill_alpha", {"title": "Альфа-зомби", "description": "Убейте лидера стаи.", "type": Quest.Type.KILL, "target_enemy_type": "alpha", "target_count": 1, "reward_xp": 350, "reward_money": 175, "required_level": 8})
	_add_template("kill_night_stalker", {"title": "Ночной охотник", "description": "Убейте ночного сталкера.", "type": Quest.Type.KILL, "target_enemy_type": "night_stalker", "target_count": 1, "reward_xp": 180, "reward_money": 90, "required_level": 5})
	_add_template("kill_pack_leader", {"title": "Лидер стаи", "description": "Убейте лидера стаи зомби.", "type": Quest.Type.KILL, "target_enemy_type": "pack_leader", "target_count": 1, "reward_xp": 220, "reward_money": 110, "required_level": 6})
	_add_template("kill_boss", {"title": "Босс", "description": "Убейте босса зомби.", "type": Quest.Type.KILL, "target_enemy_type": "boss", "target_count": 1, "reward_xp": 500, "reward_money": 250, "required_level": 10})
	_add_template("clear_infestation", {"title": "Очистка гнезда", "description": "Очистите гнездо зомби.", "type": Quest.Type.KILL, "target_enemy_type": "zombie", "target_count": 30, "reward_xp": 300, "reward_money": 150, "required_level": 7})
	_add_template("kill_horde", {"title": "Орда", "description": "Уничтожьте орду зомби.", "type": Quest.Type.KILL, "target_enemy_type": "zombie", "target_count": 100, "reward_xp": 1000, "reward_money": 500, "required_level": 12})
	_add_template("kill_elite", {"title": "Элита", "description": "Убейте элитного зомби.", "type": Quest.Type.KILL, "target_enemy_type": "elite", "target_count": 3, "reward_xp": 400, "reward_money": 200, "required_level": 9})
	_add_template("kill_ghost", {"title": "Призрак", "description": "Убейте призрачного зомби.", "type": Quest.Type.KILL, "target_enemy_type": "ghost", "target_count": 1, "reward_xp": 280, "reward_money": 140, "required_level": 7})
	_add_template("kill_toxic", {"title": "Токсичный", "description": "Убейте токсичного зомби.", "type": Quest.Type.KILL, "target_enemy_type": "toxic", "target_count": 5, "reward_xp": 160, "reward_money": 80, "required_level": 4})
	_add_template("kill_exploder", {"title": "Взрыватель", "description": "Убейте взрывающегося зомби.", "type": Quest.Type.KILL, "target_enemy_type": "exploder", "target_count": 3, "reward_xp": 190, "reward_money": 95, "required_level": 5})
	_add_template("kill_necromancer", {"title": "Некромант", "description": "Убейте некроманта.", "type": Quest.Type.KILL, "target_enemy_type": "necromancer", "target_count": 1, "reward_xp": 450, "reward_money": 225, "required_level": 10})
	
	# Сбор (15 квестов)
	_add_template("collect_wood", {"title": "Сбор дерева", "description": "Соберите 20 дерева.", "type": Quest.Type.FETCH, "target_item_id": "wood", "target_count": 20, "reward_xp": 40, "reward_money": 20})
	_add_template("collect_metal", {"title": "Сбор металла", "description": "Соберите 15 металла.", "type": Quest.Type.FETCH, "target_item_id": "metal", "target_count": 15, "reward_xp": 60, "reward_money": 30})
	_add_template("collect_cloth", {"title": "Сбор ткани", "description": "Соберите 10 ткани.", "type": Quest.Type.FETCH, "target_item_id": "cloth", "target_count": 10, "reward_xp": 35, "reward_money": 15})
	_add_template("collect_food", {"title": "Сбор еды", "description": "Соберите 15 еды.", "type": Quest.Type.FETCH, "target_item_id": "food", "target_count": 15, "reward_xp": 50, "reward_money": 25})
	_add_template("collect_medicine", {"title": "Сбор медикаментов", "description": "Соберите 10 медикаментов.", "type": Quest.Type.FETCH, "target_item_id": "medicine", "target_count": 10, "reward_xp": 70, "reward_money": 35})
	_add_template("collect_ammo", {"title": "Сбор боеприпасов", "description": "Соберите 50 патронов.", "type": Quest.Type.FETCH, "target_item_id": "ammo", "target_count": 50, "reward_xp": 80, "reward_money": 40})
	_add_template("collect_herbs", {"title": "Сбор трав", "description": "Соберите 10 целебных трав.", "type": Quest.Type.FETCH, "target_item_id": "herbs", "target_count": 10, "reward_xp": 45, "reward_money": 20})
	_add_template("collect_electronics", {"title": "Сбор электроники", "description": "Соберите 8 электронных компонентов.", "type": Quest.Type.FETCH, "target_item_id": "electronics", "target_count": 8, "reward_xp": 85, "reward_money": 45})
	_add_template("collect_fuel", {"title": "Сбор топлива", "description": "Соберите 10 топлива.", "type": Quest.Type.FETCH, "target_item_id": "fuel", "target_count": 10, "reward_xp": 60, "reward_money": 30})
	_add_template("collect_glass", {"title": "Сбор стекла", "description": "Соберите 10 стекла.", "type": Quest.Type.FETCH, "target_item_id": "glass", "target_count": 10, "reward_xp": 40, "reward_money": 20})
	_add_template("collect_plastic", {"title": "Сбор пластика", "description": "Соберите 15 пластика.", "type": Quest.Type.FETCH, "target_item_id": "plastic", "target_count": 15, "reward_xp": 50, "reward_money": 25})
	_add_template("collect_rubber", {"title": "Сбор резины", "description": "Соберите 10 резины.", "type": Quest.Type.FETCH, "target_item_id": "rubber", "target_count": 10, "reward_xp": 45, "reward_money": 20})
	_add_template("collect_chemicals", {"title": "Сбор химикатов", "description": "Соберите 5 химикатов.", "type": Quest.Type.FETCH, "target_item_id": "chemicals", "target_count": 5, "reward_xp": 75, "reward_money": 40})
	_add_template("collect_batteries", {"title": "Сбор батарей", "description": "Соберите 5 батарей.", "type": Quest.Type.FETCH, "target_item_id": "batteries", "target_count": 5, "reward_xp": 55, "reward_money": 30})
	_add_template("collect_rare", {"title": "Редкие материалы", "description": "Соберите 3 редких материала.", "type": Quest.Type.FETCH, "target_item_id": "rare_materials", "target_count": 3, "reward_xp": 100, "reward_money": 50, "required_level": 5})
	
	# Исследование (10 квестов)
	_add_template("explore_hospital", {"title": "Разведка больницы", "description": "Исследуйте больницу.", "type": Quest.Type.EXPLORE, "target_position": Vector2(500, -300), "target_radius": 100.0, "reward_xp": 80, "reward_money": 40})
	_add_template("explore_mall", {"title": "Торговый центр", "description": "Исследуйте торговый центр.", "type": Quest.Type.EXPLORE, "target_position": Vector2(-400, 600), "target_radius": 150.0, "reward_xp": 100, "reward_money": 50, "required_level": 3})
	_add_template("explore_school", {"title": "Школа", "description": "Исследуйте школу.", "type": Quest.Type.EXPLORE, "target_position": Vector2(300, -500), "target_radius": 120.0, "reward_xp": 90, "reward_money": 45})
	_add_template("explore_police", {"title": "Полицейский участок", "description": "Исследуйте полицейский участок.", "type": Quest.Type.EXPLORE, "target_position": Vector2(-600, 200), "target_radius": 100.0, "reward_xp": 110, "reward_money": 55})
	_add_template("explore_fire_station", {"title": "Пожарная станция", "description": "Исследуйте пожарную станцию.", "type": Quest.Type.EXPLORE, "target_position": Vector2(700, 400), "target_radius": 100.0, "reward_xp": 85, "reward_money": 40})
	_add_template("explore_military", {"title": "Военная база", "description": "Исследуйте военную базу.", "type": Quest.Type.EXPLORE, "target_position": Vector2(-800, -600), "target_radius": 200.0, "reward_xp": 200, "reward_money": 100, "required_level": 6})
	_add_template("explore_lab", {"title": "Лаборатория", "description": "Исследуйте секретную лабораторию.", "type": Quest.Type.EXPLORE, "target_position": Vector2(-200, -800), "target_radius": 150.0, "reward_xp": 180, "reward_money": 90, "required_level": 5})
	_add_template("explore_subway", {"title": "Метро", "description": "Исследуйте метро.", "type": Quest.Type.EXPLORE, "target_position": Vector2(0, 1000), "target_radius": 250.0, "reward_xp": 150, "reward_money": 75, "required_level": 4})
	_add_template("explore_church", {"title": "Церковь", "description": "Исследуйте церковь.", "type": Quest.Type.EXPLORE, "target_position": Vector2(-300, 300), "target_radius": 80.0, "reward_xp": 70, "reward_money": 35})
	_add_template("explore_ruins", {"title": "Руины", "description": "Исследуйте руины старого города.", "type": Quest.Type.EXPLORE, "target_position": Vector2(1000, 1000), "target_radius": 300.0, "reward_xp": 250, "reward_money": 125, "required_level": 7})
	
	# Крафт (8 квестов)
	_add_template("craft_weapons", {"title": "Создание оружия", "description": "Создайте 3 единицы оружия.", "type": Quest.Type.CRAFT, "target_item_id": "weapon", "target_count": 3, "reward_xp": 100, "reward_money": 50})
	_add_template("craft_tools", {"title": "Создание инструментов", "description": "Создайте 5 инструментов.", "type": Quest.Type.CRAFT, "target_item_id": "tools", "target_count": 5, "reward_xp": 80, "reward_money": 40})
	_add_template("craft_medicine", {"title": "Создание лекарств", "description": "Создайте 5 лекарств.", "type": Quest.Type.CRAFT, "target_item_id": "medicine", "target_count": 5, "reward_xp": 90, "reward_money": 45})
	_add_template("craft_armor", {"title": "Создание брони", "description": "Создайте 3 брони.", "type": Quest.Type.CRAFT, "target_item_id": "armor", "target_count": 3, "reward_xp": 120, "reward_money": 60, "required_level": 4})
	_add_template("craft_explosives", {"title": "Создание взрывчатки", "description": "Создайте 5 бомб.", "type": Quest.Type.CRAFT, "target_item_id": "explosives", "target_count": 5, "reward_xp": 110, "reward_money": 55, "required_level": 3})
	_add_template("craft_food", {"title": "Приготовление еды", "description": "Приготовьте 10 блюд.", "type": Quest.Type.CRAFT, "target_item_id": "cooked_food", "target_count": 10, "reward_xp": 60, "reward_money": 30})
	_add_template("craft_electronics", {"title": "Создание электроники", "description": "Создайте 3 электронных устройства.", "type": Quest.Type.CRAFT, "target_item_id": "electronics", "target_count": 3, "reward_xp": 130, "reward_money": 65, "required_level": 5})
	_add_template("craft_fuel", {"title": "Создание топлива", "description": "Создайте 10 топлива.", "type": Quest.Type.CRAFT, "target_item_id": "fuel", "target_count": 10, "reward_xp": 70, "reward_money": 35})
	
	# Защита (8 квестов)
	_add_template("defend_camp", {"title": "Оборона лагеря", "description": "Защитите лагерь от зомби.", "type": Quest.Type.DEFEND, "target_enemy_type": "zombie", "target_count": 15, "reward_xp": 150, "reward_money": 75})
	_add_template("defend_hospital", {"title": "Оборона больницы", "description": "Защитите больницу.", "type": Quest.Type.DEFEND, "target_enemy_type": "zombie", "target_count": 20, "reward_xp": 200, "reward_money": 100, "required_level": 4})
	_add_template("defend_school", {"title": "Оборона школы", "description": "Защитите школу для детей.", "type": Quest.Type.DEFEND, "target_enemy_type": "zombie", "target_count": 18, "reward_xp": 180, "reward_money": 90, "required_level": 5})
	_add_template("defend_warehouse", {"title": "Оборона склада", "description": "Защитите склад с припасами.", "type": Quest.Type.DEFEND, "target_enemy_type": "zombie", "target_count": 25, "reward_xp": 220, "reward_money": 110, "required_level": 6})
	_add_template("defend_convoy", {"title": "Защита конвоя", "description": "Защитите конвой.", "type": Quest.Type.DEFEND, "target_enemy_type": "zombie", "target_count": 12, "reward_xp": 160, "reward_money": 80, "required_level": 4})
	_add_template("defend_refugees", {"title": "Защита беженцев", "description": "Защитите беженцев.", "type": Quest.Type.DEFEND, "target_enemy_type": "zombie", "target_count": 10, "reward_xp": 140, "reward_money": 70})
	_add_template("defend_base_night", {"title": "Ночная оборона", "description": "Защитите базу ночью.", "type": Quest.Type.DEFEND, "target_enemy_type": "zombie", "target_count": 30, "reward_xp": 280, "reward_money": 140, "required_level": 7})
	_add_template("defend_final", {"title": "Финальная оборона", "description": "Защитите базу от огромной орды.", "type": Quest.Type.DEFEND, "target_enemy_type": "zombie", "target_count": 50, "reward_xp": 500, "reward_money": 250, "required_level": 10})
	
	# Доставка (6 квестов)
	_add_template("deliver_food", {"title": "Доставка еды", "description": "Доставьте еду в лагерь.", "type": Quest.Type.DELIVER, "target_npc_id": "camp_leader", "reward_xp": 50, "reward_money": 25})
	_add_template("deliver_medicine", {"title": "Доставка лекарств", "description": "Доставьте лекарства в больницу.", "type": Quest.Type.DELIVER, "target_npc_id": "hospital", "reward_xp": 60, "reward_money": 30})
	_add_template("deliver_weapons", {"title": "Доставка оружия", "description": "Доставьте оружие ополчению.", "type": Quest.Type.DELIVER, "target_npc_id": "militia", "reward_xp": 80, "reward_money": 40, "required_level": 3})
	_add_template("deliver_parts", {"title": "Доставка запчастей", "description": "Доставьте запчасти механику.", "type": Quest.Type.DELIVER, "target_npc_id": "mechanic", "reward_xp": 55, "reward_money": 30})
	_add_template("deliver_message", {"title": "Доставка сообщения", "description": "Доставьте сообщение.", "type": Quest.Type.DELIVER, "target_npc_id": "radio_operator", "reward_xp": 45, "reward_money": 20})
	_add_template("deliver_supplies", {"title": "Доставка припасов", "description": "Доставьте припасы на аванпост.", "type": Quest.Type.DELIVER, "target_npc_id": "outpost", "reward_xp": 70, "reward_money": 35, "required_level": 2})
	
	# Разговор (6 квестов)
	_add_template("talk_elder", {"title": "Совет старейшины", "description": "Поговорите со старейшиной.", "type": Quest.Type.TALK, "target_dialogue": "elder", "reward_xp": 40, "reward_reputation": 15})
	_add_template("talk_hermit", {"title": "Мудрость отшельника", "description": "Поговорите с отшельником.", "type": Quest.Type.TALK, "target_dialogue": "hermit", "reward_xp": 50, "reward_reputation": 10})
	_add_template("talk_priest", {"title": "Духовный совет", "description": "Поговорите со священником.", "type": Quest.Type.TALK, "target_dialogue": "priest", "reward_xp": 35, "reward_reputation": 10})
	_add_template("talk_scientist", {"title": "Консультация учёного", "description": "Поговорите с учёным.", "type": Quest.Type.TALK, "target_dialogue": "scientist", "reward_xp": 45, "reward_reputation": 12})
	_add_template("talk_veteran", {"title": "Совет ветерана", "description": "Поговорите с ветераном.", "type": Quest.Type.TALK, "target_dialogue": "veteran", "reward_xp": 40, "reward_reputation": 10})
	_add_template("talk_survivors", {"title": "Переговоры с выжившими", "description": "Поговорите с группой выживших.", "type": Quest.Type.TALK, "target_dialogue": "survivors", "reward_xp": 55, "reward_reputation": 20})
	
	# Сопровождение (5 квестов)
	_add_template("escort_refugees", {"title": "Сопровождение беженцев", "description": "Сопроводите беженцев до лагеря.", "type": Quest.Type.ESCORT, "target_npc_id": "refugees", "reward_xp": 100, "reward_money": 50})
	_add_template("escort_scientist", {"title": "Сопровождение учёного", "description": "Сопроводите учёного до лаборатории.", "type": Quest.Type.ESCORT, "target_npc_id": "scientist", "reward_xp": 140, "reward_money": 70, "required_level": 4})
	_add_template("escort_merchant", {"title": "Сопровождение торговца", "description": "Сопроводите торговца.", "type": Quest.Type.ESCORT, "target_npc_id": "merchant", "reward_xp": 120, "reward_money": 60, "required_level": 3})
	_add_template("escort_child", {"title": "Сопровождение ребёнка", "description": "Сопроводите ребёнка до родителей.", "type": Quest.Type.ESCORT, "target_npc_id": "child", "reward_xp": 80, "reward_money": 40})
	_add_template("escort_wounded", {"title": "Сопровождение раненого", "description": "Сопроводите раненого до врача.", "type": Quest.Type.ESCORT, "target_npc_id": "wounded", "reward_xp": 90, "reward_money": 45})

func _add_template(id: String, data: Dictionary):
	quest_templates[id] = data

# Создать квест из шаблона
func create_quest(template_id: String) -> Quest:
	if not quest_templates.has(template_id):
		return null
	
	var template = quest_templates[template_id]
	var quest = Quest.new()
	
	quest.quest_id = template_id
	quest.title = template["title"]
	quest.description = template["description"]
	quest.quest_type = template["type"]
	quest.target_count = template.get("target_count", 1)
	quest.target_item_id = template.get("target_item_id", "")
	quest.target_enemy_type = template.get("target_enemy_type", "")
	quest.target_position = template.get("target_position", Vector2.ZERO)
	quest.target_radius = template.get("target_radius", 100.0)
	quest.target_npc_id = template.get("target_npc_id", "")
	quest.target_dialogue = template.get("target_dialogue", "")
	quest.reward_xp = template.get("reward_xp", 50)
	quest.reward_items = template.get("reward_items", {})
	quest.reward_money = template.get("reward_money", 0)
	quest.reward_reputation = template.get("reward_reputation", 10)
	quest.reward_faction_id = template.get("reward_faction_id", "")
	quest.required_level = template.get("required_level", 0)
	
	return quest

# Принять квест
func accept_quest(quest: Quest):
	if not active_quests.has(quest):
		quest.accept()
		active_quests.append(quest)
		emit_signal("quest_accepted", quest)

# Обновить прогресс квеста
func update_quest_progress(type: Quest.Type, target_id: String = "", amount: int = 1):
	for quest in active_quests:
		if quest.quest_type == type:
			match type:
				Quest.Type.KILL:
					if quest.target_enemy_type == target_id:
						quest.update_progress(amount)
				Quest.Type.FETCH:
					if quest.target_item_id == target_id:
						quest.update_progress(amount)
				Quest.Type.CRAFT:
					if quest.target_item_id == target_id:
						quest.update_progress(amount)
				Quest.Type.DEFEND:
					if quest.target_enemy_type == target_id:
						quest.update_progress(amount)

# Сдать квест
func turn_in_quest(quest: Quest):
	if active_quests.has(quest):
		quest.turn_in()
		active_quests.erase(quest)
		completed_quests.append(quest.quest_id)
		emit_signal("quest_turned_in", quest)

# Получить активные квесты
func get_active_quests() -> Array[Quest]:
	return active_quests

# Получить завершённые квесты
func get_completed_quests() -> Array[String]:
	return completed_quests

# Получить доступные квесты для NPC
func get_available_quests_for_npc(npc_id: String) -> Array[Quest]:
	var result: Array[Quest]
	for template_id in quest_templates:
		if completed_quests.has(template_id):
			continue
		var quest = create_quest(template_id)
		if quest:
			result.append(quest)
	return result

# Сериализация
func serialize_data() -> Dictionary:
	return {
		"active": _serialize_quests(active_quests),
		"completed": completed_quests,
		"failed": failed_quests
	}

func _serialize_quests(quests: Array[Quest]) -> Array:
	var data = []
	for quest in quests:
		data.append(quest.serialize())
	return data

# Десериализация
func deserialize_data(data: Dictionary):
	completed_quests = data.get("completed", [])
	failed_quests = data.get("failed", [])
