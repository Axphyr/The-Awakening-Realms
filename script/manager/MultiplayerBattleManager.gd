extends Node

var confirm_battle_messages: Dictionary = {}
var battles: Dictionary = {}
var multiplayer_battle_scene = preload("res://scene/battle/MultiplayerBattleScene.tscn")

func start_battle(initialiser_player, enemy_player):
	var multiplayer_battle = multiplayer_battle_scene.instantiate()
	multiplayer_battle.position = Vector2(20_000, 1_000 * battles.size())
	var battle_id = "battle-" + str(initialiser_player.id) + "_" + str(enemy_player.id)
	multiplayer_battle.battle_id = battle_id
	multiplayer_battle.initialiser_player = initialiser_player
	multiplayer_battle.enemy_player = enemy_player
	
	battles[battle_id] = {
		initialiser_player.id: initialiser_player,
		enemy_player.id: enemy_player,
		"state": "starting"
	}
	get_tree().root.get_node("World").add_child(multiplayer_battle)

	multiplayer_battle.get_node("Camera2D").make_current()
	get_tree().root.get_node("World/" + str(initialiser_player.id)).can_move = false
	
	multiplayer_battle.get_node("Camera2D").make_current()
	get_tree().root.get_node("World/" + str(enemy_player.id)).can_move = false

