extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D/AnimationPlayer.play("Scroll")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.position.x += .1;
	if Input.is_action_just_pressed('ui_accept'):
		get_tree().change_scene_to_file("res://scene/world.tscn")
