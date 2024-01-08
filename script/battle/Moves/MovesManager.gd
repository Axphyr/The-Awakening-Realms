extends Node

class_name MovesManager

var moves : Array

enum Types {
	FIRE = 0,
	WATER = 1,
	EARTH = 2,
	WIND = 3,
	NORMAL = 4,
	DARK = 5
}

func set_up():
	# Add a move :                 Display Name       File Name      DMG    Type       PP  MN Cost  Lvl Needed
	moves.append(Move.new().setup("Implosion",     "dark_implosion", 10, Types.DARK,   10,    5,       5))
	moves.append(Move.new().setup("Ghost",         "ghost",           8, Types.DARK,   12,    4,       4))
	moves.append(Move.new().setup("Earth Bump",    "earth_bump",      5, Types.EARTH,  25,    2,       2))
	moves.append(Move.new().setup("Earth Impact",  "earth_impact",    8, Types.EARTH,  15,    4,       4))
	moves.append(Move.new().setup("Earth Wall",    "earth_wall",     10, Types.EARTH,  10,    5,       8))
	moves.append(Move.new().setup("Irregular rock","irregular_rock", 15, Types.EARTH,   5,    8,       10))
	moves.append(Move.new().setup("Fire Breath",   "fire_breath",    10, Types.FIRE,   10,    5,       8))
	moves.append(Move.new().setup("Fire Dome",     "fire_dome",      15, Types.FIRE,    5,    7,       10))
	moves.append(Move.new().setup("Fire Impact",   "fire_impact",     7, Types.FIRE,   15,    4,       2))
	moves.append(Move.new().setup("Slash",         "slash",           4, Types.NORMAL, 25,    0,       0))
	moves.append(Move.new().setup("Sting",         "sting",           6, Types.NORMAL, 20,    0,       0))
	moves.append(Move.new().setup("Water Blast",   "water_blast",    15, Types.WATER,   5,    7,       10))
	moves.append(Move.new().setup("Water Impact",  "water_impact",    8, Types.WATER,  15,    4,       4))
	moves.append(Move.new().setup("Water Spike",   "water_spike",    10, Types.WATER,  10,    5,       8))
	moves.append(Move.new().setup("Water Splash",  "water_splash",    6, Types.WATER,  20,    3,       2))
	moves.append(Move.new().setup("Air Burst",     "air_burst",       8, Types.WIND,   15,    4,       4))
	moves.append(Move.new().setup("Air Explosion", "air_explosion",  10, Types.WIND,   10,    5,       8))
	moves.append(Move.new().setup("Pull In",       "pull_in",         5, Types.WIND,   25,    2,       2))
	moves.append(Move.new().setup("Wind Breath",   "wind_breath",    15, Types.WIND,    5,    8,       10))

func get_moves(entity = false) -> Array:
	var moves_array : Array = []

	# si monstre : moves random
	if(entity): # Vérifie si entity est un monstre (car donné)
		entity.moves.clear();
		set_up()
		var m_array = moves
		m_array.shuffle()
		var enemy_moves = []
		for move in m_array:
			if (move.type == entity.type or move.type == Types.NORMAL) and entity.level >= move.level_needed:
				enemy_moves.append(move)
		return [enemy_moves[0], enemy_moves[1]]
	# sinon, moves pris du fichier de conf
	else:
		set_up()
		moves_array = moves
		moves_array.shuffle()
		return [moves_array[0], moves_array[1], moves_array[2], moves_array[3]]

func get_base_move():
	return Move.new().setup("Slash", "slash", 6, Types.NORMAL, 25, 0, 0)

func get_moves_by_level(player_level : int):
	set_up()
	var res = []
	for move in moves:
		if(player_level >= move.level_needed):
			res.append(move)
	return res
