extends Control

var _curpos = 0
const _positions = [Vector2(30,35),Vector2(30,100)]
var attacks = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("attack", Callable(get_parent(), "attack"))

signal attack()

func _input(event):
	if self.visible:
		var olcur = _curpos
		if(attacks == false):
			if event.is_action_pressed("ui_down") and _curpos % 2 == 0:
				_curpos += 1
			elif event.is_action_pressed("ui_up") and _curpos % 2 == 1:
				_curpos -= 1
			elif event.is_action_pressed("ui_accept"):
				handle_button_selection()
		if olcur != _curpos:
			$BattleDialog/Arrow.position = _positions[_curpos]
			$Blip.play()

func handle_button_selection():
	if _curpos == 1:
		self.visible = false
		await get_tree().create_timer(.25).timeout
		get_parent().get_node("EscapeBattle").visible = true
		await get_tree().create_timer(2).timeout
		if(canEscape(get_parent().player.level, get_parent().current_monster.level)):
			get_parent().get_node("EscapeBattle").get_node("escape_dialog").get_node("escape_dialog").text = ""
			await get_tree().create_timer(.4).timeout
			get_parent().get_node("EscapeBattle").get_node("escape_dialog").get_node("escape_dialog").text = "You escaped succesfully!"
			await get_tree().create_timer(2).timeout
			if MultiplayerManager.is_solo:
				var config = ConfigFile.new()
				var player_name_load = config.load("user://player_info.cfg")
				if player_name_load == OK:
					config.set_value("Player Info", "player_current_hp", get_parent().player.current_hp)
					config.set_value("Player Info", "player_current_mana", get_parent().player.current_mana)
					config.save("user://player_info.cfg")
			else:
				var m_player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
				m_player.current_hp = get_parent().player.current_hp
				m_player.current_mana = get_parent().player.current_mana
			
			get_tree().change_scene_to_file("res://scene/world.tscn")
		else:
			get_parent().get_node("EscapeBattle").get_node("escape_dialog").get_node("escape_dialog").text = ""
			await get_tree().create_timer(.5).timeout
			get_parent().get_node("EscapeBattle").get_node("escape_dialog").get_node("escape_dialog").text = "You failed to escape!"
			await get_tree().create_timer(1).timeout
			get_parent().get_node("EscapeBattle").visible = false
			get_parent().get_node("EscapeBattle").get_node("escape_dialog").get_node("escape_dialog").text = "You're trying to escape..."
			await get_tree().create_timer(.5).timeout
			get_parent().enemy_attacks()
	elif _curpos == 0:
		attacks = true
		emit_signal("attack")

# Function to calculate escape rate based on level difference
func escapeRate(player_level, opponent_level):
	var escape_rate = (player_level - opponent_level + 30) * 32 / 60
	return clamp(escape_rate, 0, 255)

# Function to check if the player can escape
func canEscape(player_level, opponent_level):
	var escape_chance = 95
	var random_value = randi() % 256
	return escapeRate(player_level, opponent_level) * (escape_chance / 100.0) < random_value
