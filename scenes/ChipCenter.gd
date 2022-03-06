extends HBoxContainer
onready var rowContainer  = $VBoxContainer
onready var miniChipTheme = load("res://misc/minichipTheme.tres")
export var maxChildren    = 20
export var totalMax       = 80
onready var activeContainer = $VBoxContainer/HBoxContainer
var totalChildren = 0



# Add mini chips to container, but add another row if width passes 200
func addMini(mini):
	var numChildren = activeContainer.get_children().size()
	if(numChildren >= maxChildren):
		addNewRow()
	if(totalChildren < totalMax):
		activeContainer.add_child(mini)
		totalChildren += 1
	
func addNewRow():
	var newRow = HBoxContainer.new()
	newRow.theme = miniChipTheme
	rowContainer.add_child(newRow)
	activeContainer = newRow
	
