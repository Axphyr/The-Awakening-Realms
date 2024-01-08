extends Node2D

@onready var interactionArea: InteractionArea = $InteractionArea;
@export var Location: Vector2;

func _on_i():
	if MultiplayerManager.is_solo:
		get_tree().root.get_node("World/Player").position = self.Location * 32;
	else:
		get_tree().root.get_node("World/" + str(MultiplayerManager.list_player[multiplayer.get_unique_id()].id)).position = self.Location * 32;

func _ready():
	print("IA -> Door : ", self.interactionArea)
	self.interactionArea.interact = Callable(self, "_on_i")
