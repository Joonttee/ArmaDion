extends Node
class_name MiningSystem

# MiningSystem - система добычи и копания (как в CDDA)

enum TileType { ROCK, DIRT, SAND, CLAY, ORE_COAL, ORE_IRON, ORE_COPPER, ORE_GOLD, ORE_DIAMOND }

const MINING_RESULTS = {
	TileType.ROCK: {"stone": 3, "gravel": 2},
	TileType.DIRT: {"dirt": 5, "clay": 1},
	TileType.SAND: {"sand": 5, "clay": 1},
	TileType.CLAY: {"clay": 5},
	TileType.ORE_COAL: {"coal": 3, "stone": 2},
	TileType.ORE_IRON: {"iron_ore": 2, "stone": 3},
	TileType.ORE_COPPER: {"copper_ore": 2, "stone": 3},
	TileType.ORE_GOLD: {"gold_ore": 1, "stone": 4},
	TileType.ORE_DIAMOND: {"diamond": 1, "stone": 5}
}

const MINING_TOOLS = {
	"hands": {"speed": 0.5, "can_mine": [TileType.DIRT, TileType.SAND, TileType.CLAY]},
	"shovel": {"speed": 1.0, "can_mine": [TileType.DIRT, TileType.SAND, TileType.CLAY]},
	"pickaxe": {"speed": 1.0, "can_mine": [TileType.ROCK, TileType.ORE_COAL, TileType.ORE_IRON]},
	"heavy_pickaxe": {"speed": 1.5, "can_mine": [TileType.ROCK, TileType.ORE_COAL, TileType.ORE_IRON, TileType.ORE_COPPER]},
	"jackhammer": {"speed": 3.0, "can_mine": [TileType.ROCK, TileType.ORE_COAL, TileType.ORE_IRON, TileType.ORE_COPPER, TileType.ORE_GOLD, TileType.ORE_DIAMOND]}
}

static func can_mine(tile_type: TileType, tool_id: String) -> bool:
	if not MINING_TOOLS.has(tool_id):
		return false
	
	return tile_type in MINING_TOOLS[tool_id]["can_mine"]

static func get_mining_time(tile_type: TileType, tool_id: String) -> float:
	var base_time = 10.0
	if MINING_TOOLS.has(tool_id):
		var speed = MINING_TOOLS[tool_id]["speed"]
		if speed > 0:
			base_time /= speed
	
	return base_time

static func get_mining_results(tile_type: TileType) -> Dictionary:
	return MINING_RESULTS.get(tile_type, {})

static func mine_tile(tile_type: TileType, tool_id: String) -> Dictionary:
	if not can_mine(tile_type, tool_id):
		return {}
	
	return get_mining_results(tile_type)
