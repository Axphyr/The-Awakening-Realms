extends Node2D

@onready var interactionArea: InteractionArea = $InteractionArea;

func _on_i():
	if MultiplayerManager.is_solo:
		get_tree().root.get_node("World/Player").position = Vector2(4.5, 42)*32;
	else:
		get_tree().root.get_node("World/1").position = Vector2(4.5, 42)*32;

func _ready():
	print("IA -> Door : ", self.interactionArea)
	self.interactionArea.interact = Callable(self, "_on_i")
