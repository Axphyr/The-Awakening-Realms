extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func save_player_position(player):
	if MultiplayerManager.is_solo:
		var config = ConfigFile.new()
		config.load("user://positions.cfg")
		config.set_value("Player", "last_position_before_battle", player.position)
		config.save("user://positions.cfg")
	else:
		MultiplayerManager.players_positions[player.get_node("MultiplayerSynchronizer").get_multiplayer_authority()] = player.position

func transition():
	for n in range(3):
		$transition.show()
		await get_tree().create_timer(0.2).timeout
		$transition.hide()
		await get_tree().create_timer(0.2).timeout

func _on_area_2d_body_entered(body):
	if randf() < .025 and body is CharacterBody2D and (MultiplayerManager.is_solo or body.get_node("MultiplayerSynchronizer").get_multiplayer_authority() == multiplayer.get_unique_id()):
		disable_player_movement(body)
		save_player_position(body)
		$transitionMusic.play()
		print("Battle!")
		await transition()
		get_tree().change_scene_to_file("res://scene/battle/BattleScene.tscn")
		enable_player_movement(body)

func disable_player_movement(player):
	if player.has_method("disable_movement"):
		player.disable_movement()

func enable_player_movement(player):
	if player.has_method("enable_movement"):
		player.enable_movement()
