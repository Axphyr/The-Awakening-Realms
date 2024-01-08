extends CharacterBody2D

const SPEED = 200;

var sprite_state;
var last_direction = Vector2(0, 1);
var can_move = true

func  _ready():
	velocity = Vector2();
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int());
	
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		$Camera2D.make_current(); 

func _physics_process(_delta):

	var vector_direction;

	if can_move and ($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() or MultiplayerManager.is_solo):
		vector_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
		velocity = vector_direction * SPEED * (1.4 if Input.is_key_pressed(KEY_C) else 1.);
		#position += velocity;
		move_and_slide()
	
		if ( !vector_direction.x and !vector_direction.y ):
			choose_animation("idle", last_direction);
		else:
			choose_animation("walk", vector_direction);
			last_direction = vector_direction;

func choose_animation(_sprite_state, _direction):
	var direction_name = "down";

	if (_direction.y == -1):     direction_name = "up";
	if (_direction.x > .7):      direction_name = "right";
	if (_direction.x < -.7):     direction_name = "left";

	$AnimatedSprite2D.play(_sprite_state + "_" + direction_name);

func disable_movement():
	can_move = false

func enable_movement():
	can_move = true
