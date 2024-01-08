extends Node2D

@onready var interactionArea: InteractionArea = $InteractionArea;


const lines: Array[String] = [
	"Hamlet of Zolnarian →"
];

func _on_i():
	print("TEST")
	TextBoxManager.startDialog(self.global_position, self.lines);
	await TextBoxManager.finished_display;

func _ready():
	print( "IA -> Sign :", self.interactionArea)
	self.interactionArea.interact = Callable(self, "_on_i")

