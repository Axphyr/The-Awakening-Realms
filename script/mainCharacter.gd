extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.play("default");

var deltaTot = 0;	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if deltaTot < 25:
		deltaTot += delta;
	elif deltaTot < 28:
		deltaTot += delta;
		position.x += .7;
	else:
		deltaTot = 0;
		
	
