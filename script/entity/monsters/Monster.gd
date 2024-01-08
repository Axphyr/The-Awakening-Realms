extends Node

class_name Monster

var display_name : String
var file_name : String
var initial_hp : int
var current_hp : int
var level : int
var moves : Array
var type : int
var base_xp_gain : int;
var weight: int;

func setup(display_name, file_name, initial_hp, level, type, base_xp_gain, weight:int, moves: Array = []):
	self.display_name = display_name
	self.file_name = file_name
	self.initial_hp = initial_hp
	self.current_hp = initial_hp
	self.level = level
	self.moves = moves
	self.type = type
	self.base_xp_gain = base_xp_gain;
	self.weight = weight;
	return self
