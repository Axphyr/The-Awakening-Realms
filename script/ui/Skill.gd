extends Control

signal skill_selected(move)
var type : Texture
var move : Move

# Called when the node enters the scene tree for the first time.
func _ready():
	$Move_Name.connect("pressed", i_am_pressed)
	$Move_Name.text = self.name
	$Type.texture = load("res://assets/texture/ui/elements/" + get_parent().get_parent().get_parent().types[move.type] + ".png")

func i_am_pressed():
	var initialSkillsNames = get_parent().get_parent().get_parent().initialSkillsNames
	var selectedSkills = get_parent().get_parent().get_parent().selectedSkills
	if self.move.display_name in initialSkillsNames:
		selectedSkills[findIdByName(self.move)] = self.move
		initialSkillsNames.erase(self.move.display_name)
	if selectedSkills.size() < 4 or self.move in selectedSkills or null in selectedSkills:
		emit_signal("skill_selected", self.move)
		$NinePatchRect2.visible = not $NinePatchRect2.visible

func findIdByName(move) -> int:
	var selectedSkills = get_parent().get_parent().get_parent().selectedSkills
	for i in range(selectedSkills.size()):
		if(selectedSkills[i].display_name == move.display_name):
			return i
	return -1
