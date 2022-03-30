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
		
		
func clear():
	while rowContainer.get_child_count() > 1:
		for _child in rowContainer.get_children():
			_child.queue_free()
	
	activeContainer = rowContainer.get_children()[0]
	
	for _child in activeContainer.get_children():
		activeContainer.remove_child(_child)
		_child.queue_free()
	
	


	
func addNewRow():
	var newRow = HBoxContainer.new()
	newRow.theme = miniChipTheme
	rowContainer.add_child(newRow)
	activeContainer = newRow
	
