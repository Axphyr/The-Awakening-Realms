extends Control

var base_dialog = null
var move_dialog = null
var base_pos = Vector2()

var current_monster : Monster
var monster_instance
var types = ["fire", "water", "earth", "wind", "normal", "dark"]
var player : BattlePlayer
var player_instance
var move_instance
var enemy_move_instance
var death_messages = ["That wasn't supposed to happen...","That's all?","Try not to do that again next time.","Are you okay?","You'll recover... someday...","Why did you do that?","That's... bad...","Were you expecting something?","Things aren't looking so bright.","I expected a little more.","Get up on your feet.","How... unfortunate.","Your body is lifeless.","You can do a little better.","The shadows claim another victim.","In the end, we all return to dust.","The journey ends here.","Defeat is the bitterest pill.","The reaper comes for us all.","Fate has a twisted sense of humor.","The world mourns your valiant effort.","May your next life be more fortunate.","Even legends meet their match.","Your journey was cut short.","The afterlife awaits your return.", "When the seagulls cry, no one shall remains..."]
var level_diference: int = 2;

# Variables pour les coefficients d'efficacité des types
var avantage = 1.5
var faiblesse = 0.5
var meme = 0.75
var normal = 1.0


# Table des types
var typeChart = [
		   # FIRE          WATER      EARTH     WIND      NORMAL     DARK
	# FIRE
			[ meme,      faiblesse, avantage,  normal,    normal,   avantage    ],
	# WATER
			[ avantage,  meme,      faiblesse, normal,    normal,   normal,     ],
	# EARTH
			[ normal,    avantage,  meme,      normal,    normal,   avantage    ],
	# WIND
			[ normal,    normal,    faiblesse, meme,      normal,   normal      ],
	# NORMAL
			[ normal,    normal,    normal,    normal,    meme,     faiblesse   ],
	# DARK
			[ faiblesse, normal,    faiblesse, normal,    avantage, meme        ]
]

# Player Stats
var health;
var strength;
var defense;
var mana;
var luck;

# Called when the node enters the scene tree for the first time.
func _ready():
	if($Fond):
		$BattleMusic.play()
		$BaseDialog.connect("attack", _move_selected)
		set_player()
		spawnMonster()
		base_pos = $BaseDialog.position
	
func set_player():
	if MultiplayerManager.is_solo:
		var config = ConfigFile.new()
		var player_name_load = config.load("user://player_info.cfg")
		if player_name_load == OK and config.get_value("Player Info", "player_name"):
			# Sets player's stats
			strength = config.get_value("Player Stats", "strength")
			defense = config.get_value("Player Stats", "defense")
			luck = config.get_value("Player Stats", "luck")
			
			# Loads player with stats
			self.player = BattlePlayer.new().setup(
				config.get_value("Player Info", "player_name"), 
				"BattlePlayer", 
				config.get_value("Player Info", "player_hp"),
				config.get_value("Player Info", "player_level"),
				config.get_value("Player Info", "player_mana"),
				config.get_value("Player Info", "player_moves"))
			
			self.player.current_hp = config.get_value("Player Info", "player_current_hp")
			self.player.current_mana = config.get_value("Player Info", "player_current_mana")
		else:
			self.player = BattlePlayer.new().setup("Tristan l'unique", "BattlePlayer", 20, 4, 15, MovesManager.new().get_moves())
	else:
		var m_player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		strength = m_player.stats.strength
		defense = m_player.stats.defense
		luck = m_player.stats.luck
		
		self.player = BattlePlayer.new().setup(
			m_player.name, 
			"BattlePlayer", 
			m_player.hp, 
			m_player.level, 
			m_player.mana, 
			m_player.moves)
		
		self.player.current_hp = m_player.current_hp
		self.player.current_mana = m_player.current_mana

	$PlayerInfoBox/Player_name.text = player.display_name
	$PlayerInfoBox/Player_lvl.text = "Lv." + str(player.level)
	$PlayerInfoBox/health_bar.max_value = player.hp
	$PlayerInfoBox/health_bar.value = player.current_hp
	$PlayerInfoBox/mana_bar.value = player.current_mana	
	$PlayerInfoBox/mana_bar.max_value = player.mana
	$PlayerInfoBox/health_bar/PV_Amount.text = str(player.current_hp) + "/" + str(player.hp)
	$PlayerInfoBox/mana_bar/MANA_Amount.text = str(player.current_mana) + "/" + str(player.mana)
	player_instance = load("res://scene/entity/BattlePlayer.tscn").instantiate()
	player_instance.position = $Player.position
	add_child(player_instance)

func spawnMonster():
	# Choses a random monster
	self.current_monster = MonstersManager.get_random_monster();
	
	# Sets the monster's parameters
	self.current_monster.level = max(1, self.player.level + randi_range(-self.level_diference, self.level_diference))
	self.current_monster.base_xp_gain += (self.current_monster.level - 1) * 30;
	self.current_monster.current_hp = self.current_monster.initial_hp + (self.current_monster.level - 1) * 3;
	self.current_monster.initial_hp = self.current_monster.current_hp
	
	# Load the Monster scene
	var monster_scene = load("res://scene/monsters/" + current_monster.file_name + ".tscn")

	# Instance the scene
	monster_instance = monster_scene.instantiate()
	monster_instance.get_node("AnimatedSprite2D").play("idle")

	# Set the position of the instantiated monster
	monster_instance.position = $BaseEnemy.position + Vector2(180, 0)
	
	# Add the monster to the scene hierarchy
	add_child(monster_instance)
	
	# Add monster info
	$EnemyInfoBox/Mob_name.text = current_monster.display_name
	$EnemyInfoBox/Mob_lvl.text = "Lv." + str(current_monster.level)
	$EnemyInfoBox/health_bar/PV_Amount.text = str(current_monster.current_hp) + "/" + str(current_monster.initial_hp)
	$EnemyInfoBox/health_bar.max_value = current_monster.initial_hp
	$EnemyInfoBox/health_bar.value = current_monster.initial_hp
	
	$Type.texture = load("res://assets/texture/ui/elements/" + types[current_monster.type] + ".png")
	$Type.size = Vector2(30,30)
	
	# Load monster's moves
	current_monster.moves = MovesManager.new().get_moves(current_monster)

func _attack_enemy(move):
	move_dialog.visible = false
	var player_animation = player_instance.get_node("AnimatedSprite2D")
	await attack_animation(move)
	$EnemyInfoBox/DMG_Amount.hide()
	$EnemyInfoBox/Crited.hide()
	player_animation.play("idle")
	if(current_monster.current_hp <= 0):
		player_wins()
	else:
		enemy_attacks()

func enemy_attacks():
	# erases duplication bug
	if(enemy_move_instance):
		enemy_move_instance.queue_free()
	
	# Monster choses a random move
	current_monster.moves.shuffle()
	var chosen_move = current_monster.moves[0]
	$enemy_chosing/chosing_dialog.text = current_monster.display_name + " is choosing what to do..."
	$enemy_chosing.visible = true
	await get_tree().create_timer(3.5).timeout
	$enemy_chosing.visible = false
	await get_tree().create_timer(.5).timeout
	$enemy_choose/choose_dialog.text  = current_monster.display_name + " used " + chosen_move.display_name
	$enemy_choose.visible = true
	
	# Monster attacks ("attack" animation if Normal type, "magic" animation else)
	monster_instance.get_node("AnimatedSprite2D").play("attack" if chosen_move.type == 4 else "magic") # 4 = Types.NORMAL
	await get_tree().create_timer(1).timeout
	enemy_move_instance = load("res://scene/moves/" + types[chosen_move.type] + "/" + chosen_move.file_name + ".tscn").instantiate()
	enemy_move_instance.position = $Base.position + Vector2(220, 20)
	add_child(enemy_move_instance)
	await get_tree().create_timer(1).timeout
	$enemy_choose.visible = false
	
	# Player looses HP
	var damage_taken = floor((chosen_move.initial_dmg + self.current_monster.level) - defense/4)
	$PlayerInfoBox/DMG_Amount.text = "-" + str(damage_taken)
	$PlayerInfoBox/DMG_Amount.show()
	var new_hp = player.current_hp - damage_taken
	player.current_hp = new_hp if new_hp > 0 else 0
	$PlayerInfoBox/health_bar.value = player.current_hp
	$PlayerInfoBox/health_bar/PV_Amount.text = str(player.current_hp) + "/" + str(player.hp)
	await get_tree().create_timer(1).timeout
	monster_instance.get_node("AnimatedSprite2D").play("idle")
	$PlayerInfoBox/DMG_Amount.hide()
	
	# If player's HP is at 0, player dies. Else continues.
	if(player.current_hp <= 0):
		player_death()
	else:
		_move_esc()

func attack_animation(move):
	if move_instance:
		move_instance.queue_free()
	player_instance.get_node("AnimatedSprite2D").play("attack")
	await get_tree().create_timer(1).timeout
	move_instance = load("res://scene/moves/" + types[move.type] + "/" + move.file_name + ".tscn").instantiate()
	move_instance.position = $BaseEnemy.position + Vector2(180, 20)
	add_child(move_instance)
	await get_tree().create_timer(1).timeout
	player.current_mana = player.current_mana if move.type == 4 else player.current_mana - move.mana_cost
	$PlayerInfoBox/mana_bar.value = player.current_mana
	$PlayerInfoBox/mana_bar/MANA_Amount.text = str(player.current_mana) + "/" + str(player.mana)
	
	var damage = floor(move.initial_dmg*typeChart[move.type][current_monster.type] + strength/2)
	var crit_chance = 0.02 + luck * 0.001  # Base crit rate of 2% plus 0.1% for each point in luck
	
	if randf() < crit_chance:
		print("crited")
		$EnemyInfoBox/Crited.show()
		damage *= 1.5
	$EnemyInfoBox/DMG_Amount.text = "-" + str(damage)
	$EnemyInfoBox/DMG_Amount.show()
	
	current_monster.current_hp = current_monster.current_hp - floor(damage) if current_monster.current_hp - floor(damage) > 0 else 0
	$EnemyInfoBox/health_bar.value = current_monster.current_hp
	$EnemyInfoBox/health_bar/PV_Amount.text = str(current_monster.current_hp) + "/" + str(current_monster.initial_hp)
	await get_tree().create_timer(1).timeout

func _move_selected():
	# Hide the current base dialog if it exists
	if base_dialog:
		base_dialog.visible = false
	else:
		$BaseDialog.visible = false

	# Hide the move dialog if it exists
	if move_dialog:
		move_dialog.visible = false
		move_dialog.queue_free()

	# Instantiate the move dialog
	move_dialog = load("res://scene/battle/MoveBattle.tscn").instantiate()
	move_dialog.connect("esc", _move_esc)
	move_dialog.connect("move_chosen", _attack_enemy)
	move_dialog.set_moves(player.moves)
	move_dialog.position = base_pos
	add_child(move_dialog)

func _move_esc():
	# If a move dialog exists, free it
	if move_dialog:
		move_dialog.queue_free()

	# Instantiate a new base dialog
	base_dialog = load("res://scene/battle/BaseDialog.tscn").instantiate()
	base_dialog.position = base_pos
	base_dialog.connect("attack", _move_selected)
	add_child(base_dialog)

	# Show the new base dialog
	base_dialog.visible = true

	# Free the current move dialog
	move_dialog = null
	
func player_wins():
	mob_death()
	add_child(load("res://scene/battle/WinBattle.tscn").instantiate())

func player_death():
	$BattleMusic.stop()
	player_instance.get_node("AnimatedSprite2D").play("die")
	await get_tree().create_timer(3).timeout
	$DeathSound.play()
	var fade_instance = load("res://scene/ui/transitions/death_transition.tscn").instantiate()
	var fade_animation = fade_instance.get_node("AnimationPlayer")
	fade_animation.play("fade")
	add_child(fade_instance)
	await get_tree().create_timer(fade_animation.current_animation_length).timeout
	$death_label.text = death_messages[randi() % death_messages.size()]
	await get_tree().create_timer(7).timeout
	
	if MultiplayerManager.is_solo:
		var config = ConfigFile.new()
		var load = config.load("user://positions.cfg")
		if load == OK:
			config.set_value("Player", "last_position_before_battle", Vector2(208, -408))
			config.save("user://positions.cfg")
		
		var player_info_load = config.load("user://player_info.cfg")
		if player_info_load == OK:
			config.set_value("Player Info", "player_current_hp", floor(config.get_value("Player Info", "player_hp") / 2))
			config.set_value("Player Info", "player_current_mana", floor(config.get_value("Player Info", "player_mana") / 2))
			config.set_value("Player Info", "player_xp", 0)
			config.save("user://player_info.cfg")
	else:
		var m_player = MultiplayerManager.list_player[multiplayer.get_unique_id()]
		MultiplayerManager.players_positions[multiplayer.get_unique_id()] = Vector2(208, -408)
		m_player.current_hp = m_player.hp / 2
		m_player.current_mana = m_player.mana / 2
		m_player.xp = 0
	
	get_tree().change_scene_to_file("res://scene/world.tscn")

func mob_death():
	monster_instance.get_node("AnimatedSprite2D").play("die")
	await get_tree().create_timer(3).timeout
