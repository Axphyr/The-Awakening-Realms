extends Node2D

var story = ConfigFile.new()
var player_info = ConfigFile.new()
var player_name = ""
var dialogs = [
	"Where am I... ? ▶",
	"What is this place... ▶",
	"Who am I... ? ▶"
]

var dialogs2 = []

var currentDialogIndex = 0
var currentDialog = ""
var index = 0
var timer_duration = 0.05
var timer = Timer.new()
var needLineBreak = false
var beginning_dialog = false
var isInDialogs2 = false

var spawn = Vector2(-2_860, 150);
var playerStats;
var player_selects = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if MultiplayerManager.is_solo:
		var player = load("res://scene/entity/player.tscn").instantiate()
		add_child(player);
		InteractionManager.player = player;
		
		var player_position = ConfigFile.new()
		var player_position_load = player_position.load("user://positions.cfg")
		if player_position_load == OK and player_position.has_section_key("Player", "last_position_before_battle"):
			player.position = player_position.get_value("Player", "last_position_before_battle")
		else:
			var story_load = story.load("user://story.cfg")
			if story_load == OK:
				player.position = Vector2(208, -408)
			else:
				player.position = spawn;
	else:
		var player_scene = load("res://scene/entity/player.tscn");
		for i in MultiplayerManager.list_player:
			var current_player = player_scene.instantiate();
			current_player.name = str(MultiplayerManager.list_player[i].id);
			current_player.get_node("Label").text = MultiplayerManager.list_player[i].name;
			self.add_child(current_player);
			current_player.position = spawn;
			
			if (MultiplayerManager.list_player[i].id == multiplayer.get_unique_id()):
				var multi_chat = load("res://scene/ui/multi_chat.tscn").instantiate();
				add_child(multi_chat);
		
			
			if(MultiplayerManager.players_positions.has(current_player.get_node("MultiplayerSynchronizer").get_multiplayer_authority())):
				current_player.position = MultiplayerManager.players_positions[current_player.get_node("MultiplayerSynchronizer").get_multiplayer_authority()]
			else:
				current_player.position = spawn + Vector2(randi()%10+1, randi()%10+1);
			
			if i == 1:
				InteractionManager.player = current_player;
	
	playerStats = load("res://scene/ui/PlayerStats.tscn").instantiate()
	add_child(playerStats)
	playerStats.hide()
	
	if MultiplayerManager.is_solo:
		var enter_transition = load("res://scene/ui/transitions/enter_transition.tscn").instantiate()
		add_child(enter_transition)
		enter_transition.get_node("AnimationPlayer").play("fade")
		$Player.get_node("AnimatedSprite2D").play("idle_right")
		$Player.disable_movement()
		await get_tree().create_timer(enter_transition.get_node("AnimationPlayer").current_animation_length).timeout
		enter_transition.queue_free()
		
		var story_load = story.load("user://story.cfg")
		if story_load != OK:
			timer.wait_time = timer_duration
			var callback = Callable(self, "_on_timer_timeout")
			timer.connect("timeout", callback)
			add_child(timer)
	
			$Dialog.position.x = $Player.position.x - get_viewport().get_visible_rect().size.x / 2
			$Dialog.position.y = $Player.position.y + get_viewport().get_visible_rect().size.y / 2 - 175  # 175 = taille y en pixels du dialog
			$Dialog.visible = true
			beginning_dialog = true
			showNextDialog()
			timer.start()
		else:
			if playerStats:
				if not playerStats.visible:
					$Player.enable_movement()
			else:
				$Player.enable_movement()

func showNextDialog():
	if isInDialogs2:
		currentDialog = dialogs2[currentDialogIndex]
	else:
		currentDialog = dialogs[currentDialogIndex]
	$Dialog/NinePatchRect/RichTextLabel.text = ""
	index = 0
	needLineBreak = false

func _on_timer_timeout():
	if index < currentDialog.length():
		$Dialog/NinePatchRect/RichTextLabel.text += currentDialog[index]

		if (index % 50 == 49):
			needLineBreak = true

		if (needLineBreak and currentDialog[index] == ' '):
			$Dialog/NinePatchRect/RichTextLabel.text += "\n"
			needLineBreak = false

		index += 1
	else:
		timer.stop()

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_I and not player_selects and not beginning_dialog and not isInDialogs2:
			if not playerStats.visible:
				playerStats.update()
				if MultiplayerManager.is_solo:
					$Player.can_move = false
				else:
					get_node(str(multiplayer.get_unique_id())).can_move = false
				playerStats.show()
			else:
				playerStats.hide()
				if MultiplayerManager.is_solo:
					$Player.can_move = true
				else:
					get_node(str(multiplayer.get_unique_id())).can_move = true
	
	if event.is_action_pressed("ui_cancel") and playerStats and playerStats.visible:
		playerStats.hide()
		if MultiplayerManager.is_solo:
			$Player.can_move = true
		else:
			get_node(str(multiplayer.get_unique_id())).can_move = true
	if event.is_action_pressed("ui_accept") and beginning_dialog and $Dialog.visible:
		if index < currentDialog.length():
			# If the dialog is still being typed, finish typing it
			$Dialog/NinePatchRect/RichTextLabel.text += currentDialog.substr(index)
			index = currentDialog.length()
		else:
			currentDialogIndex += 1
			if isInDialogs2:
				if currentDialogIndex < dialogs2.size():
					showNextDialog()
					timer.start()
				else:
					handleTransition()
			else:
				if currentDialogIndex < dialogs.size():
					showNextDialog()
					timer.start()
				else:
					beginning_dialog = false
					$Dialog.visible = false
					player_selects = true
					var player_name_selection = load("res://scene/ui/player_name_selection.tscn").instantiate()
					player_name_selection.connect("player_name", _player_name_chosen)
					add_child(player_name_selection)

func _player_name_chosen():
	var player_info_load = player_info.load("user://player_info.cfg")
	if player_info_load == OK:
		player_name = player_info.get_value("Player Info", "player_name")

	dialogs2 = [
		"Oh right, I am " + player_name + " ! ▶",
		"But... I don't know that place. ▶",
		"Let's go around. ▶"
	]
	player_selects = false
	isInDialogs2 = true
	currentDialogIndex = 0
	showNextDialog()
	$Dialog.visible = true
	timer.start()

func handleTransition():
	$Dialog.visible = false
	beginning_dialog = false
	isInDialogs2 = false
	timer.stop()
	$Player.enable_movement()
	story.set_value("Progression", "game_started", true)
	story.save("user://story.cfg")
