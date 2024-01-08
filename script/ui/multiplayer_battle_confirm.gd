extends CanvasLayer

var enemy_player;
var initialiser_player;

signal battle_rejected(initialiser_player, enemy_player)
signal battle_accepted(initialiser_player, enemy_player)

# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect/Label.text = "The player " + initialiser_player.name + "\n challenges you to a duel."

func _on_reject_pressed():
	if self.visible:
		emit_signal("battle_rejected", initialiser_player, enemy_player)
		self.queue_free()

func _on_accept_pressed():
	if self.visible:
		emit_signal("battle_accepted", initialiser_player, enemy_player)
		self.queue_free()
