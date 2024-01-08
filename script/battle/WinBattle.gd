extends Control

var xp_gain
var xp_amount
var level_gained_amount
var level_gained = false
var config = ConfigFile.new()

# Constants for XP calculation
var base_xp_requirement = 100
var xp_growth_factor = 1.2
var xp_growth_exponent = 1.5
var m_player;

# Called when the node enters the scene tree for the first time.
func _ready():
	xp_gain = get_parent().current_monster.base_xp_gain
	$win_dialog/win_dialog.text = "You won " + str(xp_gain) + "XP! ▶"
	
	if MultiplayerManager.is_solo:
		var player_name_load = config.load("user://player_info.cfg")
		
		if player_name_load == OK:
			config.set_value("Player Info", "player_current_hp", get_parent().player.current_hp)
			config.set_value("Player Info", "player_current_mana", get_parent().player.current_mana)
			xp_amount = int(config.get_value("Player Info", "player_xp") + xp_gain)
	else:
		m_player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		m_player.current_hp = get_parent().player.current_hp
		m_player.current_mana = get_parent().player.current_mana
		xp_amount = int(m_player.xp + xp_gain)
	
	# Check if the player gained levels
	var current_level = config.get_value("Player Info", "player_level") if MultiplayerManager.is_solo else m_player.level
	var new_level = calculate_level()
	level_gained_amount = new_level - current_level
			
	if xp_amount > calculate_xp_required(current_level, base_xp_requirement, xp_growth_factor, xp_growth_exponent):
		level_gained = true
		var xp_required = calculate_xp_required(current_level, base_xp_requirement, xp_growth_factor, xp_growth_exponent)
				
		# Deduct XP required for gained levels
		xp_amount -= xp_required
				
		# Check if the player can gain more levels
		while xp_amount >= xp_required:
			current_level += 1
			new_level += 1
			level_gained_amount += 1
			xp_required = calculate_xp_required(current_level, base_xp_requirement, xp_growth_factor, xp_growth_exponent)
			xp_amount -= xp_required
		if MultiplayerManager.is_solo:
			config.set_value("Player Info", "player_level", new_level)
			config.set_value("Player Stats", "unassigned_stat_points", config.get_value("Player Stats", "unassigned_stat_points") + level_gained_amount * 5)
		else:
			m_player.level = new_level
			m_player.stats.unassigned_stat_points += level_gained_amount * 5
	
	# Save the new level and unassigned stat points
	if MultiplayerManager.is_solo:
		config.set_value("Player Info", "player_xp", int(xp_amount))
		config.save("user://player_info.cfg")
	else:
		print("xp before : ", m_player.xp)
		m_player.xp = int(xp_amount)
		print("xp after : ", m_player.xp)

# Calculate player level based on XP using the provided function
func calculate_level():
	return get_parent().player.level + 1

# Function to calculate XP required for a given level
func calculate_xp_required(level, base_xp_requirement, xp_growth_factor, xp_growth_exponent):
	return base_xp_requirement * (pow(level * xp_growth_factor, xp_growth_exponent))

func _input(event):
	if self.visible:
		if event.is_action_pressed("ui_accept"):
			if level_gained:
				level_gained = false
				$win_dialog/win_dialog.text = ""
				await get_tree().create_timer(0.25).timeout
				var levlevs = "level" if level_gained_amount == 1 else "levels"
				$win_dialog/win_dialog.text = "You gained " + str(level_gained_amount) + " " + levlevs + ".\nYou have " + str(level_gained_amount * 5) + " new unassigned stat points. ▶"
			else:
				self.visible = false
				await get_tree().create_timer(0.5).timeout
				var fade_instance = load("res://scene/ui/transitions/win_transition.tscn").instantiate()
				var fade_animation = fade_instance.get_node("AnimationPlayer")
				fade_animation.play("fade")
				get_parent().add_child(fade_instance)
				await get_tree().create_timer(2.3).timeout
				get_tree().change_scene_to_file("res://scene/world.tscn")
