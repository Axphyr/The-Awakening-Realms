extends Control

var _curpos = 0
var _positions = [Vector2(20,30), Vector2(20, 100), Vector2(340, 30), Vector2(340, 100)]
var types = ["fire", "water", "earth", "wind", "normal", "dark", "thunder"]

signal move_chosen(id)

var _moves : Array = [null, null, null, null]

func set_moves(moves):
	_moves = moves

func _ready():
	connect("move_chosen", Callable(get_parent(), "move_chosen"))
	
	for i in range(_moves.size()):
		if _moves[i] != null:
			get_node("MovesDialog/Move" + String.num(i)).text = "" + _moves[i].display_name
			get_node("MovesDialog/Type" + String.num(i)).texture = load("res://assets/texture/ui/elements/" + types[_moves[i].type] + ".png")

signal esc()

func _input(event):
	if self.visible:
		var olcur = _curpos
		if event.is_action_pressed("ui_cancel"):
			emit_signal("esc")
		elif event.is_action_pressed("ui_down") and _curpos % 2 == 0: # If down and in the upper part of the box
			_curpos += 1
		elif event.is_action_pressed("ui_up") and _curpos % 2 == 1: # If up and in the lower part of the box
			_curpos -= 1
		elif event.is_action_pressed("ui_right") and _curpos < 2: # If right and in the left part of the box
			_curpos += 2
		elif event.is_action_pressed("ui_left") and _curpos >= 2: # If left and in the right part of the box
			_curpos -= 2
		elif event.is_action_pressed("ui_accept"):
			var selected_move = _moves[_curpos]
			if selected_move != null and selected_move.current_pp > 0 and selected_move.mana_cost <= get_parent().player.current_mana:
				selected_move.current_pp -= 1
				# Only emit the signal if the move has PP remaining or if the player has sufficient mana
				emit_signal("move_chosen", selected_move)
		if olcur != _curpos: # Update the cursor and the infobox only if the position has changed
			$MovesDialog/Arrow.position = _positions[_curpos]
			$Blip.play()
		update_info_box()

func update_info_box():
	if _moves[_curpos] != null:
		$InfoBox/PP.text = "PP: " + str(_moves[_curpos].current_pp) + "/" + str(_moves[_curpos].initial_pp)
		$NinePatchRect/ManaCost.text = str(_moves[_curpos].mana_cost)
	else:
		$InfoBox/PP.text = "PP:--/--"
		$NinePatchRect/ManaCost.text = "--"
