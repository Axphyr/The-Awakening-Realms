extends CanvasLayer

var skills = []
var selectedSkills = []
var initialSkillsNames = []
var button_scene = preload("res://scene/ui/Skill.tscn")
var types = ["fire", "water", "earth", "wind", "normal", "dark"]

# Called when the node enters the scene tree for the first time.
func _ready():
	if MultiplayerManager.is_solo:
		var config = ConfigFile.new()
		var player_load = config.load("user://player_info.cfg")
		if player_load == OK:
			self.skills = MovesManager.new().get_moves_by_level(config.get_value("Player Info", "player_level"))
			self.selectedSkills = config.get_value("Player Info", "player_moves")
	else:
		self.skills = MovesManager.new().get_moves_by_level(MultiplayerManager.list_player[multiplayer.get_unique_id()].level)
		self.selectedSkills = MultiplayerManager.list_player[multiplayer.get_unique_id()].moves
	self.delete_nulls(true)
	self.update()
	
	for skill in skills:
		var button = button_scene.instantiate()
		button.connect("skill_selected", skill_button_pressed)
		button.move = skill
		button.name = skill.display_name
		if(skill.display_name in initialSkillsNames):
			button.get_node("NinePatchRect2").visible = true
		
		$ScrollContainer/VBoxContainer.add_child(button)

func skill_button_pressed(move):
	self.delete_nulls()
	if move in selectedSkills:
		selectedSkills.erase(move)
	else:
		selectedSkills.append(move)
	self.save()
	self.update()

func update():
	for i in range(4):
		if i < selectedSkills.size() and selectedSkills[i] != null:
			get_node("Skill_slot_" + str(i)).get_node("Name").text = selectedSkills[i].display_name
			get_node("Skill_slot_" + str(i)).get_node("Type").texture = load("res://assets/texture/ui/elements/" + types[selectedSkills[i].type] + ".png")
			get_node("Skill_slot_" + str(i)).get_node("Mana").show()
			get_node("Skill_slot_" + str(i)).get_node("Str").show()
			get_node("Skill_slot_" + str(i)).get_node("DmgAmount").text = str(selectedSkills[i].initial_dmg)
			get_node("Skill_slot_" + str(i)).get_node("ManaAmount").text = str(selectedSkills[i].mana_cost)
		else:
			get_node("Skill_slot_" + str(i)).get_node("Name").text = ""
			get_node("Skill_slot_" + str(i)).get_node("Type").texture = null
			get_node("Skill_slot_" + str(i)).get_node("Mana").hide()
			get_node("Skill_slot_" + str(i)).get_node("Str").hide()
			get_node("Skill_slot_" + str(i)).get_node("DmgAmount").text = ""
			get_node("Skill_slot_" + str(i)).get_node("ManaAmount").text = ""

func save():
	var save_moves = selectedSkills
	while save_moves.size() < 4:
		save_moves.append(null)
	
	if MultiplayerManager.is_solo:
		var config = ConfigFile.new()
		var player_load = config.load("user://player_info.cfg")
		if player_load == OK:
			config.set_value("Player Info", "player_moves", save_moves)
			config.save("user://player_info.cfg")
	else:
		MultiplayerManager.list_player[multiplayer.get_unique_id()].moves = save_moves

func delete_nulls(start = false):
	var lst = []
	for move in selectedSkills:
		if(move != null):
			lst.append(move)
			if start:
				initialSkillsNames.append(move.display_name)
	selectedSkills = lst

func _input(event):
	if self.visible:
		if event.is_action_pressed("ui_cancel"):
			self.queue_free()
