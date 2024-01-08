extends Node

@onready var textBoxScene = preload("res://scene/ui/TextBox.tscn")

var lines: Array = [];
var index_line: int = 0;

var textBox;
var position: Vector2 = Vector2();

var isActive: bool = false;
var canNextLine: bool = false;

signal finished_display()

func startDialog(_position: Vector2, _lines: Array):
	
	if self.isActive:
		return
		
	self.lines = _lines;
	self.position = _position;
	
	showTextBox();
	self.isActive = true;
	
func showTextBox():
	self.textBox = textBoxScene.instantiate();
	self.textBox.finished_display.connect(textBoxFinished);
	self.get_tree().root.add_child(self.textBox);
	self.textBox.global_position = self.position;

	self.textBox.displayText(self.lines[self.index_line]);
	self.canNextLine = false;
	
func textBoxFinished():
	self.canNextLine = true;
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") && self.isActive && self.canNextLine:
		self.textBox.queue_free();
		self.index_line += 1;
		
		if self.index_line >= self.lines.size():
			self.isActive = false;
			self.index_line = 0;
			finished_display.emit();
			return
			
		showTextBox();
	
