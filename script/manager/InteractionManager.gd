extends Node2D

@onready var player;
@onready var label = $Label;

const base_text = '[↵] to ';

var active_areas = [];
var can_interact = true;

var current_zone_name: String;

func registerArea(area: InteractionArea):
	self.active_areas.push_back(area);
	return
	
func unregisterArea(area: InteractionArea):
	var index = self.active_areas.find(area);
	if index != -1:
		self.active_areas.remove_at(index);

		
func _process(_delta):
	if self.active_areas.size() && self.can_interact:
		
		self.active_areas.sort_custom(_sort_areas)
		self.label.text = self.base_text + self.active_areas[0].action_name;
		self.label.global_position = self.active_areas[0].global_position;
		self.label.global_position.x -= self.label.size.x / 2;
		self.label.global_position.y -= 36;
		self.label.show();
	else:
		self.label.hide();
		
func _sort_areas(areaA, areaB):
	var d1 = player.global_position.distance_to(areaA.global_position);
	var d2 = player.global_position.distance_to(areaB.global_position);
	return d1 < d2;

func _input(event):
	if event.is_action_pressed("ui_accept") && self.can_interact:
		if self.active_areas.size():
			self.can_interact = false;
			self.label.hide();
			await self.active_areas[0].interact.call();
			self.can_interact = true;
