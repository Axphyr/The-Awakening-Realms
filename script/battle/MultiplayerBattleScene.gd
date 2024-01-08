extends Control


var initialiser_player;
var enemy_player;
var battle_id: String

# Called when the node enters the scene tree for the first time.
func _ready():
	initialiser_player["ready"] = false
	enemy_player["ready"] = false
	$Ready/Initialiser/CenterName/PlayerName.text = initialiser_player.name
	$Ready/Enemy/CenterName/PlayerName.text = enemy_player.name
	print(initialiser_player, enemy_player)
