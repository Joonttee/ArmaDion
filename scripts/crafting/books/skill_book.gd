extends Resource
class_name SkillBook

# SkillBook - книга навыков (как в CDDA)
# Чтение книг для изучения навыков

enum BookLevel { BEGINNER, INTERMEDIATE, ADVANCED, EXPERT, MASTER }

@export var book_id: String = ""
@export var book_name: String = ""
@export var skill_id: String = ""
@export var level: BookLevel = BookLevel.BEGINNER
@export var read_time: float = 3600.0  # Время чтения в секундах

var is_read: bool = false
var read_progress: float = 0.0

func read(delta: float) -> bool:
	if is_read:
		return false
	
	read_progress += delta
	if read_progress >= read_time:
		is_read = true
		return true
	
	return false

func get_progress_percent() -> float:
	return (read_progress / read_time) * 100.0

func get_xp_reward() -> float:
	match level:
		BookLevel.BEGINNER: return 50.0
		BookLevel.INTERMEDIATE: return 100.0
		BookLevel.ADVANCED: return 200.0
		BookLevel.EXPERT: return 400.0
		BookLevel.MASTER: return 800.0
	return 50.0
