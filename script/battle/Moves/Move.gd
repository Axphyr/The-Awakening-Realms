extends Node

class_name Move

var display_name : String
var file_name : String
var initial_dmg : int
var initial_pp : int
var type : int
var current_pp : int
var mana_cost : int
var level_needed : int

func setup(display_name, file_name, initial_dmg, type, initial_pp, mana_cost, level_needed):
	self.display_name = display_name
	self.file_name = file_name
	self.initial_dmg = initial_dmg
	self.initial_pp = initial_pp
	self.type = type
	self.current_pp = initial_pp
	self.mana_cost = mana_cost
	self.level_needed = level_needed
	return self
