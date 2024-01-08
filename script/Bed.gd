extends Node2D

var config = ConfigFile.new();
@onready var interactionArea: InteractionArea = $InteractionArea;

func _on_i():
	
	var load = config.load("user://player_info.cfg");
	if load == OK:
		self.config.set_value("Player Info", "player_current_hp", config.get_value("Player Info", "player_hp"));
		self.config.set_value("Player Info", "player_current_mana", config.get_value("Player Info", "player_mana"));
		config.save("user://player_info.cfg")
		var enter_transition = load("res://scene/ui/transitions/enter_transition.tscn").instantiate()
		# enter_transition.position = $Player.position - get_viewport().get_visible_rect().size / 2
		add_child(enter_transition)
		enter_transition.get_node("AnimationPlayer").play("fade")
		await get_tree().create_timer(enter_transition.get_node("AnimationPlayer").current_animation_length).timeout
		enter_transition.queue_free();

func _ready():
	print( "IA -> Sign :", self.interactionArea)
	self.config.load("user://player_info.cfg");
	self.interactionArea.interact = Callable(self, "_on_i")



