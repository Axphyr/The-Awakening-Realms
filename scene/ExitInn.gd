extends Node2D

@onready var interactionArea: InteractionArea = $InteractionArea;

func _on_i():
	get_tree().root.get_node("World/Player").position = Vector2(1.5, -18)*32;

func _ready():
	print( "IA -> Inn :", self.interactionArea)
	self.interactionArea.interact = Callable(self, "_on_i");

