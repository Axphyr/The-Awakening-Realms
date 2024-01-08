extends Node

var list_player = {};
var players_positions = {};
var is_solo = false;

func get_names() -> Array:
	var names = []
	for player in list_player:
		names.append(list_player[player].name)
	return names

func get_player_from_name(name : String):
	for player in list_player:
		if list_player[player].name == name:
			return player
	return -1
