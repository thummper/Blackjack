extends HBoxContainer
onready var rowContainer  = $VBoxContainer
onready var miniChipTheme = load("res://misc/minichipTheme.tres")
export var maxChildren    = 20
export var totalMax       = 80
onready var activeContainer = $VBoxContainer/HBoxContainer
var totalChildren = 0

var lastAdded = null


# Calculate and return the next minichip position for animation purposes
func getNextMiniPosition():
	# Get the center of the active row
	var activePosition = rect_global_position
	var activeSize = rect_size
	
	
	print("ACTIVE POS: ", activePosition)
	print("ACTIVE SIZE: ", activeSize)
	
	var numRows = int((totalChildren - 1) / 20)
	
	print("NUMBER ROWS: ", int(totalChildren / 20))
	
	var activeCenter = Vector2(
		activePosition[0] + 8 + ( (totalChildren - 1 - (numRows * 20)) * 8),
		activePosition[1] + (numRows * 29)
		)
	print("NEXT LOCATION: ", activeCenter)
	return activeCenter


	
	
	


# Add mini chips to container, but add another row if width passes 200
func addMini(mini):
	
#	print("CENTER OF ACTIVE ROW: ", activeContainer.rect_global_position)
#
#	print("Adding mini chip to active container")
#	print("VALIGN SIZE IS: ", rowContainer.rect_size)
	
	
	var numChildren = activeContainer.get_children().size()
	if(numChildren >= maxChildren):
		addNewRow()
	if(totalChildren < totalMax):
		activeContainer.add_child(mini)
		totalChildren += 1
		
#	print("ADDED POS: ", mini.rect_global_position)
	lastAdded = mini.rect_global_position
		
#	print("AFTER SIZE: ", rowContainer.rect_size)
		
		
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
	
