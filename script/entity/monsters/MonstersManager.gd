extends Node


enum Types {
	FIRE = 0,
	WATER = 1,
	EARTH = 2,
	WIND = 3,
	NORMAL = 4,
	DARK = 5
}

var monsters : Dictionary = {
	"Village": [
		Monster.new().setup("Wind Slime", "wind_slime", 10, 1, Types.WIND, 128, 1)
	],
	"Field": [
		Monster.new().setup("Wind Slime", "wind_slime", 10, 1, Types.WIND, 128, 4),
		Monster.new().setup("Fire Slime", "fire_slime", 12, 1, Types.FIRE, 186, 4),
		Monster.new().setup("Water Slime", "water_slime", 12, 1, Types.WATER, 209, 4),
		Monster.new().setup("Earth Slime", "earth_slime", 13, 1,Types.EARTH, 245, 4),
		Monster.new().setup("Dark Slime", "dark_slime", 21, 1, Types.DARK, 388 , 1),
	],
	"Ruins": [
		Monster.new().setup("Axel le déserteur", "hashashin", 23, 1, Types.EARTH, 516, 7),
		Monster.new().setup("Fire Wizard", "fire_wizard", 20, 1, Types.FIRE, 399, 10),
		Monster.new().setup("Reaper", "reaper", 50, 1, Types.DARK, 938, 1),
		Monster.new().setup("Monk", "monk", 26, 1, Types.EARTH, 542, 7),
		Monster.new().setup("Mauler", "mauler", 25, 1, Types.EARTH, 579, 7),
		Monster.new().setup("Water Priestess", "water_priestess", 23, 1, Types.WATER, 557, 8),
		Monster.new().setup("Fire Knight", "fire_knight", 27, 1, Types.FIRE, 643, 6),
		Monster.new().setup("Black Sorcerer", "black_sorcerer", 25, 1, Types.DARK, 583, 6),
		Monster.new().setup("King", "king", 30, 1, Types.FIRE, 629, 5),
	]
}





func get_monster() -> Monster:
	# monsters["wind_slime"] = 
	"""
	monsters["hashashin"] = [Monster.new().setup("Axel le déserteur", "hashashin", 23, 1, [], Types.EARTH, 516), 0.09]
	monsters["fire_wizard"] = [Monster.new().setup("Fire Wizard", "fire_wizard", 20, 1, [], Types.FIRE, 399), 0.1]
	monsters["reaper"] = [Monster.new().setup("Reaper", "reaper", 50, 1, [], Types.DARK, 938), 0.01]
	monsters["monk"] = [Monster.new().setup("Monk", "monk", 26, 1, [], Types.EARTH, 542), 0.1]
	monsters["mauler"] = [Monster.new().setup("Mauler", "mauler", 25, 1, [], Types.EARTH, 579), 0.1]
	monsters["water_priestess"] = [Monster.new().setup("Water Priestess", "water_priestess", 23, 1, [], Types.WATER, 557), 0.1]
	monsters["fire_knight"] = [Monster.new().setup("Fire Knight", "fire_knight", 27, 1, [], Types.FIRE, 643), 0.1]
	monsters["fire_slime"] = [Monster.new().setup("Fire Slime", "fire_slime", 12, 1, [], Types.FIRE, 186),0.40]
	monsters["water_slime"] = [Monster.new().setup("Water Slime", "water_slime", 12, 1, [], Types.WATER, 209),0.40]
	monsters["earth_slime"] = [Monster.new().setup("Earth Slime", "earth_slime", 13, 1, [], Types.EARTH, 245),0.40]
	monsters["dark_slime"] = [Monster.new().setup("Dark Slime", "dark_slime", 21, 1, [], Types.DARK, 388),0.40]
	monsters["black_sorcerer"] = [Monster.new().setup("Black Sorcerer", "black_sorcerer", 25, 1, [], Types.DARK, 583),0.08]
	monsters["king"] = [Monster.new().setup("King", "king", 30, 1, [], Types.FIRE, 629),0.07]
	"""
	print(simulateMonsterSelections())
	return get_random_monster()

func get_random_monster() -> Monster:
	var total_weight: float = 0.0;
	var current_area_mob_list = self.monsters[InteractionManager.current_zone_name];

	for monster in current_area_mob_list:
		total_weight += monster.weight;

	var random_value: float = randf() * total_weight;
	var cumulative_probability: float = 0.0;

	for monster in current_area_mob_list:
		cumulative_probability += monster.weight;
		if random_value <= cumulative_probability:
			return monster;
	
	return current_area_mob_list[0];

func simulateMonsterSelections() -> Dictionary:
	var results: Dictionary = {}

	for i in range(1000):
		var chosenMonster = get_random_monster()
		var monsterName = chosenMonster.file_name

		if not results.has(monsterName):
			results[monsterName] = {"count": 1, "probability": monsters[monsterName][1]}
		else:
			results[monsterName]["count"] += 1

	return results
