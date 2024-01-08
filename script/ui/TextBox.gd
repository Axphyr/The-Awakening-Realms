extends MarginContainer

@onready var label = $MarginContainer/Label;
@onready var timer = $Timer;

const MAX_WIDTH: int = 256;
const TIME_LETTER: float = .03;

var text = "";
var index_letter: int = 0;

signal finished_display()

func displayText(_text: String):
	
	self.text = _text;
	self.label.text = _text;
	
	await resized;
	
	self.custom_minimum_size.x = min(self.size.x, MAX_WIDTH);
	
	if self.size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD;
		await resized;
		self.custom_minimum_size.y = self.size.y;
		
	self.global_position -= Vector2(self.size.x/2, self.size.y + 24);
	
	label.text = "";
	displayLetter();
	
func displayLetter():
	label.text += self.text[self.index_letter];
	self.index_letter += 1;
	
	if self.index_letter >= self.text.length():
		finished_display.emit();
		return;
		
	timer.start(TIME_LETTER);


func _on_timer_timeout():
	displayLetter();
