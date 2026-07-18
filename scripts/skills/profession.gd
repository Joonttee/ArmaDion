extends Resource
class_name Profession

# Profession - профессия персонажа
# Даёт стартовые бонусы к навыкам и особые способности

@export var profession_id: String = ""
@export var name: String = "Безработный"
@export var description: String = ""
@export var starting_skills: Dictionary = {}  # skill_id: bonus_levels
@export var starting_traits: Array[String] = []
@export var starting_items: Dictionary = {}  # item_id: count
@export var special_ability: String = ""
@export var icon: Texture2D

# Определения профессий
const PROFESSIONS = {
	"unemployed": {
		"name": "Безработный",
		"description": "Ничего не умеете, но и не обременены обязательствами.",
		"starting_skills": {},
		"starting_traits": [],
		"starting_items": {"bread": 1, "water_bottle": 1},
		"special_ability": "",
		"points": 0
	},
	
	"soldier": {
		"name": "Солдат",
		"description": "Профессиональный военный. Мастер обращения с оружием и тактики.",
		"starting_skills": {
			"melee": 2,
			"ranged": 3,
			"dodge": 2,
			"athletics": 2,
			"defense": 2,
			"marksmanship": 2,
			"firearms": 1,
			"survival": 1
		},
		"starting_traits": ["tough", "fearless"],
		"starting_items": {"bat": 1, "bandage": 2, "canned_food": 2},
		"special_ability": "Боевой клич: временный бонус к урону в бою",
		"points": 0
	},
	
	"police_officer": {
		"name": "Полицейский",
		"description": "Страж порядка. Хорош в ближнем бою и допросах.",
		"starting_skills": {
			"melee": 2,
			"ranged": 2,
			"dodge": 1,
			"intimidation": 2,
			"law": 2,
			"athletics": 1,
			"marksmanship": 1
		},
		"starting_traits": ["pack_rat"],
		"starting_items": {"bat": 1, "bandage": 1, "water_bottle": 1},
		"special_ability": "Допрос: выведывание информации у NPC",
		"points": 0
	},
	
	"firefighter": {
		"name": "Пожарный",
		"description": "Спасатель и боец с огнём. Сила и выносливость.",
		"starting_skills": {
			"melee": 2,
			"athletics": 3,
			"bashing": 2,
			"survival": 2,
			"first_aid": 2,
			"climbing": 2,
			"swimming": 1
		},
		"starting_traits": ["tough", "strong"],
		"starting_items": {"axe": 1, "bandage": 3, "water_bottle": 2},
		"special_ability": "Спасение: быстрое извлечение из-под обломков",
		"points": 0
	},
	
	"doctor": {
		"name": "Врач",
		"description": "Медицинский работник. Лечение и знание тела.",
		"starting_skills": {
			"medicine": 4,
			"first_aid": 3,
			"biology": 3,
			"chemistry": 2,
			"psychology": 2,
			"cooking": 1,
			"speech": 1
		},
		"starting_traits": ["healer", "night_owl"],
		"starting_items": {"bandage": 5, "first_aid_kit": 2, "pills": 3},
		"special_ability": "Хирургия: сложные операции и лечение",
		"points": 0
	},
	
	"mechanic": {
		"name": "Механик",
		"description": "Мастер на все руки. Ремонт техники и механизмов.",
		"starting_skills": {
			"mechanics": 4,
			"electronics": 2,
			"metalwork": 2,
			"construction": 2,
			"crafting_advanced": 2,
			"engineering": 2,
			"scrap": 1
		},
		"starting_traits": ["tinkerer", "pack_mule"],
		"starting_items": {"hammer": 1, "screwdriver": 1, "metal": 3, "nails": 5},
		"special_ability": "Ремонт: починка любой техники",
		"points": 0
	},
	
	"chef": {
		"name": "Повар",
		"description": "Кулинарный мастер. Готовка и фермерство.",
		"starting_skills": {
			"cooking": 4,
			"cooking_advanced": 3,
			"farming": 2,
			"foraging": 2,
			"chemistry": 1,
			"survival": 1,
			"brewing": 1
		},
		"starting_traits": ["green_thumb", "pack_rat"],
		"starting_items": {"knife": 1, "canned_food": 3, "water_bottle": 2},
		"special_ability": "Мастер-шеф: создание блюд с особыми эффектами",
		"points": 0
	},
	
	"scientist": {
		"name": "Учёный",
		"description": "Исследователь. Знания и эксперименты.",
		"starting_skills": {
			"chemistry": 4,
			"biology": 3,
			"electronics": 3,
			"medicine": 2,
			"computer": 2,
			"physics": 2,
			"mathematics": 2
		},
		"starting_traits": ["bookworm", "technophobe"],
		"starting_items": {"pills": 5, "bandage": 2, "water_bottle": 1},
		"special_ability": "Исследование: создание уникальных лекарств",
		"points": 0
	},
	
	"thief": {
		"name": "Вор",
		"description": "Мастер скрытности и взлома. Кража и обман.",
		"starting_skills": {
			"stealth": 4,
			"lockpicking": 3,
			"pickpocket": 3,
			"disguise": 2,
			"deception": 2,
			"dodge": 2,
			"climbing": 2,
			"sneak_attack": 2
		},
		"starting_traits": ["light_step", "lucky"],
		"starting_items": {"knife": 1, "cloth": 2},
		"special_ability": "Теневая работа: невидимость в темноте",
		"points": 0
	},
	
	"hunter": {
		"name": "Охотник",
		"description": "Следопыт и стрелок. Выживание в дикой природе.",
		"starting_skills": {
			"archery": 4,
			"ranged": 2,
			"hunting": 3,
			"tracking": 3,
			"trapping": 3,
			"survival": 2,
			"foraging": 2,
			"fishing": 2,
			"camouflage": 2
		},
		"starting_traits": ["eagle_eye", "survivalist"],
		"starting_items": {"knife": 1, "bandage": 1, "water_bottle": 1},
		"special_ability": "Мастер-охотник: гарантированная добыча",
		"points": 0
	},
	
	"farmer": {
		"name": "Фермер",
		"description": "Земледелец и животновод. Еда и ресурсы.",
		"starting_skills": {
			"farming": 4,
			"cooking": 2,
			"fishing": 2,
			"foraging": 2,
			"survival": 2,
			"carpentry": 2,
			"brewing": 2,
			"cooking_advanced": 1
		},
		"starting_traits": ["green_thumb", "resilient", "early_bird"],
		"starting_items": {"carrot_seeds": 5, "potato_seeds": 5, "water_bottle": 2},
		"special_ability": "Урожайный сезон: двойной урожай",
		"points": 0
	},
	
	"engineer": {
		"name": "Инженер",
		"description": "Проектировщик и строитель. Сложные механизмы.",
		"starting_skills": {
			"construction": 4,
			"mechanics": 3,
			"electronics": 3,
			"engineering": 3,
			"physics": 2,
			"mathematics": 2,
			"metalwork": 2,
			"masonry": 2
		},
		"starting_traits": ["tinkerer", "photographic_memory"],
		"starting_items": {"hammer": 1, "screwdriver": 1, "metal": 5, "wood": 5},
		"special_ability": "Проектирование: доступ к чертежам",
		"points": 0
	},
	
	"athlete": {
		"name": "Спортсмен",
		"description": "Профессиональный атлет. Скорость и сила.",
		"starting_skills": {
			"athletics": 5,
			"dodge": 3,
			"swimming": 3,
			"climbing": 2,
			"grappling": 2,
			"melee": 1,
			"survival": 1
		},
		"starting_traits": ["quick", "fleet_footed", "iron_lungs"],
		"starting_items": {"water_bottle": 2, "bandage": 1},
		"special_ability": "Адреналин: временный бонус к скорости",
		"points": 0
	},
	
	"bookworm_prof": {
		"name": "Библиотекарь",
		"description": "Хранитель знаний. Чтение и обучение.",
		"starting_skills": {
			"literature": 4,
			"history": 3,
			"geography": 2,
			"computer": 2,
			"psychology": 2,
			"teaching": 2,
			"medicine": 1
		},
		"starting_traits": ["bookworm", "fast_learner"],
		"starting_items": {"bandage": 1, "water_bottle": 1},
		"special_ability": "Наставник: обучение других навыкам",
		"points": 0
	},
	
	"scout": {
		"name": "Разведчик",
		"description": "Наблюдатель и лазутчик. Скрытность и выживание.",
		"starting_skills": {
			"stealth": 3,
			"tracking": 3,
			"survival": 3,
			"dodge": 2,
			"athletics": 2,
			"navigation": 2,
			"camouflage": 2,
			"trap_spotting": 2
		},
		"starting_traits": ["light_step", "night_vision"],
		"starting_items": {"knife": 1, "bandage": 2, "water_bottle": 1},
		"special_ability": "Разведданные: обнаружение врагов заранее",
		"points": 0
	},
	
	"brawler": {
		"name": "Драчун",
		"description": "Уличный боец. Кулаки и выносливость.",
		"starting_skills": {
			"grappling": 4,
			"melee": 3,
			"dodge": 2,
			"athletics": 2,
			"bashing": 2,
			"intimidation": 2,
			"defense": 1
		},
		"starting_traits": ["strong", "pain_resistant"],
		"starting_items": {"bandage": 2, "water_bottle": 1},
		"special_ability": "Ярость: бонус к урону при низком здоровье",
		"points": 0
	},
	
	"occultist": {
		"name": "Оккультист",
		"description": "Изучатель тайного. Магия и ритуалы.",
		"starting_skills": {
			"occult": 4,
			"psychic": 2,
			"history": 2,
			"literature": 2,
			"chemistry": 1,
			"deception": 1,
			"psychology": 1
		},
		"starting_traits": ["night_vision", "paranoid"],
		"starting_items": {"bandage": 1, "pills": 2},
		"special_ability": "Ритуал: призыв и контроль существ",
		"points": 0
	},
	
	"survival_expert": {
		"name": "Эксперт выживания",
		"description": "Мастер выживания в любых условиях.",
		"starting_skills": {
			"survival": 4,
			"foraging": 3,
			"fishing": 2,
			"hunting": 2,
			"cooking": 2,
			"camping": 3,
			"weather_sense": 2,
			"navigation": 2
		},
		"starting_traits": ["resilient", "survivalist", "scavenger"],
		"starting_items": {"knife": 1, "bandage": 2, "water_bottle": 2, "canned_food": 2},
		"special_ability": "Мастер-выживальщик: бонус ко всем навыкам выживания",
		"points": 0
	}
}

func get_profession(id: String) -> Dictionary:
	if PROFESSIONS.has(id):
		return PROFESSIONS[id]
	return PROFESSIONS["unemployed"]

func get_all_professions() -> Array:
	return PROFESSIONS.keys()

func apply_profession(profession_id: String, skill_set: SkillSet, trait_set: TraitSet):
	var prof = get_profession(profession_id)
	
	# Применяем стартовые навыки
	for skill_id in prof["starting_skills"]:
		var bonus = prof["starting_skills"][skill_id]
		skill_set.add_xp(skill_id, skill_set._calculate_xp_for_level(bonus + 1) * 0.9)
	
	# Применяем стартовые черты
	for trait_id in prof["starting_traits"]:
		trait_set.add_trait(trait_id)
	
	print("[Profession] Applied profession: %s" % prof["name"])
