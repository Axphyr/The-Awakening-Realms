extends Node

class_name BattlePlayer

var display_name : String
var file_name : String
var hp : int
var current_hp : int
var level : int
var mana : int
var current_mana : int
var moves : Array

func setup(display_name, file_name, hp, level, mana, moves):
	self.display_name = display_name
	self.file_name = file_name
	self.hp = hp
	self.level = level
	self.mana = mana
	self.moves = moves
	self.current_hp = hp
	self.current_mana = mana
	return self
