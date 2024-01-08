extends CanvasLayer

var config = ConfigFile.new()
var player_info_load;

# Called when the node enters the scene tree for the first time.
func _ready():
	$BattlePlayer.get_node("AnimatedSprite2D").play("walk")

func update():
	if MultiplayerManager.is_solo:
		player_info_load = config.load("user://player_info.cfg")
		if player_info_load == OK:
			$NinePatchRect6/Player_Name.text = config.get_value("Player Info", "player_name")
			$NinePatchRect6/Player_Lvl.text = "Lvl. " + str(config.get_value("Player Info", "player_level"))
			$bars/health_bar/PV_Amount.text = str(config.get_value("Player Info", "player_current_hp")) + "/" + str(config.get_value("Player Info", "player_hp"))
			$bars/health_bar.max_value = config.get_value("Player Info", "player_hp")
			$bars/health_bar.value = config.get_value("Player Info", "player_current_hp")
			$bars/mana_bar/MANA_Amount.text = str(config.get_value("Player Info", "player_current_mana")) + "/" + str(config.get_value("Player Info", "player_mana"))
			$bars/mana_bar.max_value = config.get_value("Player Info", "player_mana")
			$bars/mana_bar.value = config.get_value("Player Info", "player_current_mana")
			$Control/Health/HP_Value.text = str(config.get_value("Player Stats", "health"))
			$Control/Strength/STR_Value.text= str(config.get_value("Player Stats", "strength"))
			$Control/Defense/DEF_Value.text = str(config.get_value("Player Stats", "defense"))
			$Control/Mana/MN_Value.text = str(config.get_value("Player Stats", "mana"))
			$Control/Luck/LUCK_Value.text = str(config.get_value("Player Stats", "luck"))
			$Control/UA_Points.text = str(config.get_value("Player Stats", "unassigned_stat_points"))
	else:
		var player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		$NinePatchRect6/Player_Name.text = player.name
		$NinePatchRect6/Player_Lvl.text = "Lvl. " + str(player.level)
		$bars/health_bar/PV_Amount.text = str(player.current_hp) + "/" + str(player.hp)
		$bars/health_bar.max_value = player.hp
		$bars/health_bar.value = player.current_hp
		$bars/mana_bar/MANA_Amount.text = str(player.current_mana) + "/" + str(player.mana)
		$bars/mana_bar.max_value = player.mana
		$bars/mana_bar.value = player.current_mana
		$Control/Health/HP_Value.text = str(player.stats.hp)
		$Control/Strength/STR_Value.text= str(player.stats.strength)
		$Control/Defense/DEF_Value.text = str(player.stats.defense)
		$Control/Mana/MN_Value.text = str(player.stats.mana)
		$Control/Luck/LUCK_Value.text = str(player.stats.luck)
		$Control/UA_Points.text = str(player.stats.unassigned_stat_points)

func _on_button_health_pressed():
	if MultiplayerManager.is_solo:
		if config.get_value("Player Stats", "unassigned_stat_points") > 0 and (int($Control/add_points.text) <= config.get_value("Player Stats", "unassigned_stat_points") or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			config.set_value("Player Stats", "health", config.get_value("Player Stats", "health") + decrease)
			config.set_value("Player Info", "player_current_hp", config.get_value("Player Info", "player_current_hp") + decrease * 2)
			config.set_value("Player Info", "player_hp", config.get_value("Player Info", "player_hp") + decrease * 2)
			config.set_value("Player Stats", "unassigned_stat_points", config.get_value("Player Stats", "unassigned_stat_points") - decrease)
			config.save("user://player_info.cfg")
	else:
		var player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		if player.stats.unassigned_stat_points > 0 and (int($Control/add_points.text) <= player.stats.unassigned_stat_points or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			player.stats.hp = player.stats.hp + decrease
			player.hp = player.hp + decrease * 2
			player.current_hp = player.current_hp + decrease * 2
			player.stats.unassigned_stat_points = player.stats.unassigned_stat_points - decrease
	update()

func _on_button_strength_pressed():
	if MultiplayerManager.is_solo:
		if config.get_value("Player Stats", "unassigned_stat_points") > 0 and (int($Control/add_points.text) <= config.get_value("Player Stats", "unassigned_stat_points") or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			config.set_value("Player Stats", "strength", config.get_value("Player Stats", "strength") + decrease)
			config.set_value("Player Stats", "unassigned_stat_points", config.get_value("Player Stats", "unassigned_stat_points") - decrease)
			config.save("user://player_info.cfg")
	else:
		var player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		if player.stats.unassigned_stat_points > 0 and (int($Control/add_points.text) <= player.stats.unassigned_stat_points or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			player.stats.strength = player.stats.strength + decrease
			player.stats.unassigned_stat_points = player.stats.unassigned_stat_points - decrease
	update()

func _on_button_defense_pressed():
	if MultiplayerManager.is_solo:
		if config.get_value("Player Stats", "unassigned_stat_points") > 0 and (int($Control/add_points.text) <= config.get_value("Player Stats", "unassigned_stat_points") or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			config.set_value("Player Stats", "defense", config.get_value("Player Stats", "defense") + decrease)
			config.set_value("Player Stats", "unassigned_stat_points", config.get_value("Player Stats", "unassigned_stat_points") - decrease)
			config.save("user://player_info.cfg")
	else:
		var player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		if player.stats.unassigned_stat_points > 0 and (int($Control/add_points.text) <= player.stats.unassigned_stat_points or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			player.stats.defense = player.stats.defense + decrease
			player.stats.unassigned_stat_points = player.stats.unassigned_stat_points - decrease
	update()

func _on_button_mana_pressed():
	if MultiplayerManager.is_solo:
		if config.get_value("Player Stats", "unassigned_stat_points") > 0 and (int($Control/add_points.text) <= config.get_value("Player Stats", "unassigned_stat_points") or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			config.set_value("Player Stats", "mana", config.get_value("Player Stats", "mana") + decrease)
			config.set_value("Player Info", "player_current_mana", config.get_value("Player Info", "player_current_mana") + decrease * 2)		
			config.set_value("Player Info", "player_mana", config.get_value("Player Info", "player_mana") + decrease * 2)		
			config.set_value("Player Stats", "unassigned_stat_points", config.get_value("Player Stats", "unassigned_stat_points") - decrease)
			config.save("user://player_info.cfg")
	else:
		var player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		if player.stats.unassigned_stat_points > 0 and (int($Control/add_points.text) <= player.stats.unassigned_stat_points or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			player.stats.mana = player.stats.mana + decrease
			player.mana = player.mana + decrease * 2
			player.current_mana = player.current_mana + decrease * 2
			player.stats.unassigned_stat_points = player.stats.unassigned_stat_points - decrease
	update()

func _on_button_luck_pressed():
	if MultiplayerManager.is_solo:
		if config.get_value("Player Stats", "unassigned_stat_points") > 0 and (int($Control/add_points.text) <= config.get_value("Player Stats", "unassigned_stat_points") or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			config.set_value("Player Stats", "luck", config.get_value("Player Stats", "luck") + decrease)
			config.set_value("Player Stats", "unassigned_stat_points", config.get_value("Player Stats", "unassigned_stat_points") - decrease)
			config.save("user://player_info.cfg")
	else:
		var player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		if player.stats.unassigned_stat_points > 0 and (int($Control/add_points.text) <= player.stats.unassigned_stat_points or $Control/add_points.text == "") and int($Control/add_points.text) > 0:
			var decrease = 1 if $Control/add_points.text == "" else int($Control/add_points.text)
			player.stats.luck = player.stats.luck + decrease
			player.stats.unassigned_stat_points = player.stats.unassigned_stat_points - decrease
	update()


func _on_reset_pressed():
	if MultiplayerManager.is_solo:
		config.set_value("Player Stats", "unassigned_stat_points", config.get_value("Player Stats", "unassigned_stat_points") + config.get_value("Player Stats", "health") + config.get_value("Player Stats", "strength") + config.get_value("Player Stats", "defense") + config.get_value("Player Stats", "mana") + config.get_value("Player Stats", "luck"))
		config.set_value("Player Stats", "health", 0)
		config.set_value("Player Stats", "strength", 0)
		config.set_value("Player Stats", "defense", 0)
		config.set_value("Player Stats", "mana", 0)
		config.set_value("Player Stats", "luck", 0)
		config.set_value("Player Info", "player_current_hp", 10)		
		config.set_value("Player Info", "player_hp", 10)		
		config.set_value("Player Info", "player_current_mana", 10)		
		config.set_value("Player Info", "player_mana", 10)		
		config.save("user://player_info.cfg")
	else:
		var player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		player.stats.unassigned_stat_points += player.stats.hp + player.stats.strength + player.stats.mana + player.stats.defense + player.stats.luck
		player.current_hp = 10
		player.hp = 10
		player.current_mana = 10
		player.mana = 10
		player.stats.hp = 0
		player.stats.strength = 0
		player.stats.defense = 0
		player.stats.mana = 0
		player.stats.luck = 0
	update()
