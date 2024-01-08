extends CanvasLayer
var player_info = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal player_name()

func _on_button_quit_pressed():
	var player_info_load = player_info.load("user://player_info.cfg")
	player_info.set_value("Player Info", "player_name", $TextEdit.text)
	player_info.set_value("Player Info", "player_level", 1)
	player_info.set_value("Player Info", "player_hp", 20)
	player_info.set_value("Player Info", "player_mana", 10)
	player_info.set_value("Player Info", "player_current_hp", 20)
	player_info.set_value("Player Info", "player_current_mana", 10)
	player_info.set_value("Player Info", "player_xp", 0)
	player_info.set_value("Player Info", "player_moves", [MovesManager.new().get_base_move(), null, null, null])
	
	player_info.set_value("Player Stats", "health", 0)
	player_info.set_value("Player Stats", "strength", 0)
	player_info.set_value("Player Stats", "defense", 0)
	player_info.set_value("Player Stats", "mana", 0)
	player_info.set_value("Player Stats", "luck", 0)
	player_info.set_value("Player Stats", "unassigned_stat_points", 10)
	player_info.save("user://player_info.cfg")
	get_parent().player_name = $TextEdit.text
	get_parent().beginning_dialog = true
	emit_signal("player_name")
	self.queue_free()

var last_text = ""
func _on_text_edit_text_changed():
	var current_text = $TextEdit.text

	# Check if the modification includes newline characters
	if current_text.find("\n") != -1:
		# Remove newline characters from the text
		$TextEdit.text = current_text.replace("\n", "")
	else:
		# Update the last valid text
		last_text = current_text
