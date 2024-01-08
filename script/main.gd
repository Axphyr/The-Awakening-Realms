extends Node2D

@export var player_scene: PackedScene;
var world_scene = preload("res://scene/world.tscn")
var peer;
var story = ConfigFile.new();
var intro;
var moves_manager = MovesManager.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	AudioManager.stream = load("res://assets/musics/theme.mp3");
	AudioManager.play();
	
	multiplayer.peer_connected.connect(peer_connected);
	multiplayer.peer_disconnected.connect(peer_disconnected);
	multiplayer.connected_to_server.connect(connected_to_server);
	multiplayer.connection_failed.connect(connection_failed);
	
	var story_load = story.load("user://story.cfg")
	if story_load == OK && story.get_value("Progression", "game_started") == true:
		$Start/ButtonStart.text = "CONTINUE"
		intro = false
	else:
		intro = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func peer_connected(id):
	print("[+] ", str(id));
	
func peer_disconnected(id):
	print("[-] ", str(id));
	
func connected_to_server():
	print("Connected to server");
	add_player.rpc_id(1, multiplayer.get_unique_id(), $Camera2D/LineEdit.text);
	
func connection_failed():
	print("Connection failed");

@rpc("any_peer", "call_local")
func start_game():
	AudioManager.stop();
	get_tree().change_scene_to_packed(load("res://scene/world.tscn"));

@rpc("any_peer")
func add_player(id, text):
	if !MultiplayerManager.list_player.has(id):
		MultiplayerManager.list_player[id] = {
			'id': id,
			'name': text,
			'hp': 10,
			'current_hp': 10,
			'mana': 10,
			'current_mana': 10,
			'moves': [moves_manager.get_base_move(), null, null, null],
			'stats': {
				'hp': 0,
				'strength': 0,
				'defense': 0,
				'mana': 0,
				'luck': 0,
				'unassigned_stat_points': 5
			},
			'level': 1,
			'xp': 0,
			'ready': false,
		};
	
	var player_frame = load("res://scene/multiplayer_instance.tscn").instantiate();
	player_frame.position = Vector2(len(MultiplayerManager.list_player)*150+200, 350)
	player_frame.name = "start_"+str(id);
	$Camera2D.add_child(player_frame);
	
	if multiplayer.is_server():
		for i in MultiplayerManager.list_player:
			add_player.rpc(i, MultiplayerManager.list_player[i].name);

@rpc("any_peer", "call_local")
func set_ready(id, ready, name):
	var tot = 0
	for i in MultiplayerManager.list_player:
		if MultiplayerManager.list_player[i].id == id:
			MultiplayerManager.list_player[i].ready = ready;
			MultiplayerManager.list_player[i].name = name;
			get_node("Camera2D").get_node("start_"+str(id)).get_node("Button").text = 'READY' if ready else 'Preparing...';
			get_node("Camera2D").get_node("start_"+str(id)).get_node("Label").text = name;
		tot += int(MultiplayerManager.list_player[i].ready)
	
	if tot == len(MultiplayerManager.list_player):
		start_game.rpc()
	
	return

func _on_button_start_pressed():
	MultiplayerManager.is_solo = true;
	AudioManager.stop();
	
	var exit_transition = load("res://scene/ui/transitions/exit_transition.tscn").instantiate()
	$Camera2D.add_child(exit_transition)
	exit_transition.get_node("AnimationPlayer").play("fade")
	$Start.hide();
	$Quit.hide();
	$Multiplayer.hide();
	
	await get_tree().create_timer(exit_transition.get_node("AnimationPlayer").current_animation_length).timeout
	
	var player_position = ConfigFile.new()
	var player_position_load = player_position.load("user://positions.cfg")
	if player_position_load == OK:
		player_position.erase_section_key("Player", "last_position_before_battle")
		player_position.save("user://positions.cfg")
	
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_file("res://scene/ui/beginning.tscn" if intro else "res://scene/world.tscn")

func _on_button_multiplayer_pressed():
	$Camera2D/MultiplayerTitle.show();
	$Host.show();
	$Join.show();
	$Return.show();
	
	$Camera2D/Cooltext447313219024398.hide();
	$Start.hide();
	$Quit.hide();
	$Multiplayer.hide();
	

func _on_button_quit_pressed():
	get_tree().quit();


func _on_button_return_pressed():
	$Camera2D/MultiplayerTitle.hide();
	$Host.hide();
	$Join.hide();
	$Return.hide();
	
	$Camera2D/Cooltext447313219024398.show();
	$Start.show();
	$Quit.show();
	$Multiplayer.show();
	$Camera2D/LineEdit.hide();


func _on_button_host_pressed(id = 1):
	peer = ENetMultiplayerPeer.new();
	if peer.create_server(9000, 4):
		print("Error...");
		return;
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	multiplayer.set_multiplayer_peer(peer);
	add_player(multiplayer.get_unique_id(), $Camera2D/LineEdit.text);
	print("Waiting players...")
	
	$Host.hide();
	$Join.hide();
	$Return.hide();
	$StartMulti.show();
	$Camera2D/LineEdit.show();


func _on_button_join_pressed():
	peer = ENetMultiplayerPeer.new();
	peer.create_client("localhost", 9000);
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	multiplayer.set_multiplayer_peer(peer);
	
	$Host.hide();
	$Join.hide();
	$Return.hide();
	$StartMulti.show();
	$Camera2D/LineEdit.show();

var pressed: bool = false;

func _on_button_start_multi_pressed():
	pressed = not pressed;
	set_ready.rpc(multiplayer.get_unique_id(), pressed, $Camera2D/LineEdit.text);
	# start_game.rpc()
	pass # Replace with function body.
