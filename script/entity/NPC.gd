extends Node2D

@onready var interactionArea: InteractionArea = $InteractionArea;
@export var asset: Texture;
@export_multiline  var  lines: String;

func _on_i():
	TextBoxManager.startDialog(self.global_position, self.lines.replace("\\", '').split("\n\n"));
	await TextBoxManager.finished_display;

func _ready():
	
	if asset:
		$Sprite2D.texture = asset;
	
	print( "IA -> Villager :", self.interactionArea)
	self.interactionArea.interact = Callable(self, "_on_i")

