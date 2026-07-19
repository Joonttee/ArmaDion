extends Resource
class_name BookDatabase

# BookDatabase - база данных книг (30+ книг)

const BOOKS = {
	# === БОЕВЫЕ НАВЫКИ ===
	"melee_beginner": {
		"name": "Основы ближнего боя",
		"skill": "melee",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы владения холодным оружием"
	},
	"melee_intermediate": {
		"name": "Техника боя",
		"skill": "melee",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Продвинутые техники ближнего боя"
	},
	"melee_advanced": {
		"name": "Мастер клинка",
		"skill": "melee",
		"level": SkillBook.BookLevel.ADVANCED,
		"time": 7200,
		"description": "Высшие техники владения мечом"
	},
	"ranged_beginner": {
		"name": "Основы стрельбы",
		"skill": "ranged",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы стрельбы из огнестрельного оружия"
	},
	"ranged_intermediate": {
		"name": "Стрелковая подготовка",
		"skill": "ranged",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Продвинутая стрельба"
	},
	"dodge_beginner": {
		"name": "Основы уклонения",
		"skill": "dodge",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Как уворачиваться от атак"
	},
	"athletics_beginner": {
		"name": "Атлетика для начинающих",
		"skill": "athletics",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы физической подготовки"
	},
	
	# === ВЫЖИВАНИЕ ===
	"survival_beginner": {
		"name": "Выживание в дикой природе",
		"skill": "survival",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы выживания"
	},
	"survival_intermediate": {
		"name": "Охота и собирательство",
		"skill": "survival",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Продвинутое выживание"
	},
	"foraging_beginner": {
		"name": "Собирательство",
		"skill": "foraging",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Поиск дикорастущих растений"
	},
	"fishing_beginner": {
		"name": "Рыбалка для начинающих",
		"skill": "fishing",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы рыбной ловли"
	},
	"cooking_beginner": {
		"name": "Кулинария для начинающих",
		"skill": "cooking",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы приготовления пищи"
	},
	"cooking_intermediate": {
		"name": "Продвинутая кулинария",
		"skill": "cooking",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Сложные рецепты"
	},
	"cooking_advanced": {
		"name": "Кулинарный мастер",
		"skill": "cooking",
		"level": SkillBook.BookLevel.ADVANCED,
		"time": 7200,
		"description": "Высшее кулинарное искусство"
	},
	
	# === РЕМЕСЛО ===
	"mechanics_beginner": {
		"name": "Основы механики",
		"skill": "mechanics",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы ремонта и обслуживания"
	},
	"mechanics_intermediate": {
		"name": "Автомеханик",
		"skill": "mechanics",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Ремонт транспорта"
	},
	"electronics_beginner": {
		"name": "Основы электроники",
		"skill": "electronics",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы работы с электроникой"
	},
	"electronics_intermediate": {
		"name": "Схемотехника",
		"skill": "electronics",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Создание электронных устройств"
	},
	"construction_beginner": {
		"name": "Основы строительства",
		"skill": "construction",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы строительства"
	},
	"construction_intermediate": {
		"name": "Продвинутое строительство",
		"skill": "construction",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Сложные строительные проекты"
	},
	"tailoring_beginner": {
		"name": "Шитьё для начинающих",
		"skill": "tailoring",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы создания одежды"
	},
	"metalwork_beginner": {
		"name": "Основы металлообработки",
		"skill": "metalwork",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Работа с металлом"
	},
	"carpentry_beginner": {
		"name": "Плотничество",
		"skill": "carpentry",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Работа с деревом"
	},
	"masonry_beginner": {
		"name": "Каменная кладка",
		"skill": "masonry",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Работа с камнем"
	},
	
	# === ИНТЕЛЛЕКТУАЛЬНЫЕ ===
	"medicine_beginner": {
		"name": "Первая помощь",
		"skill": "medicine",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы оказания первой помощи"
	},
	"medicine_intermediate": {
		"name": "Полевая медицина",
		"skill": "medicine",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Продвинутая медицина"
	},
	"medicine_advanced": {
		"name": "Хирургия",
		"skill": "medicine",
		"level": SkillBook.BookLevel.ADVANCED,
		"time": 7200,
		"description": "Хирургические операции"
	},
	"computer_beginner": {
		"name": "Основы программирования",
		"skill": "computer",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы работы с компьютерами"
	},
	"fabrication_beginner": {
		"name": "Производство",
		"skill": "fabrication",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы производства"
	},
	"fabrication_intermediate": {
		"name": "Продвинутое производство",
		"skill": "fabrication",
		"level": SkillBook.BookLevel.INTERMEDIATE,
		"time": 3600,
		"description": "Сложное производство"
	},
	"speech_beginner": {
		"name": "Искусство убеждения",
		"skill": "speech",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы общения и убеждения"
	},
	"barter_beginner": {
		"name": "Искусство торговли",
		"skill": "barter",
		"level": SkillBook.BookLevel.BEGINNER,
		"time": 1800,
		"description": "Основы торговли"
	}
}

static func get_book(book_id: String) -> Dictionary:
	return BOOKS.get(book_id, {})

static func get_all_books() -> Array:
	return BOOKS.keys()

static func get_books_by_skill(skill_id: String) -> Array:
	var result = []
	for id in BOOKS:
		if BOOKS[id]["skill"] == skill_id:
			result.append(id)
	return result
