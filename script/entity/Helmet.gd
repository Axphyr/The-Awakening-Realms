extends Node2D

@onready var interactionArea: InteractionArea = $InteractionArea;

var player_stats_scene = preload("res://scene/ui/SkillsInventory.tscn");

func _on_i():
	var player_stats = self.player_stats_scene.instantiate();
	add_child(player_stats)

func _ready():
	print( "IA -> Helmet :", self.interactionArea);
	self.interactionArea.interact = Callable(self, "_on_i");
