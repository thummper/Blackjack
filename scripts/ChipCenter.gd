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
	
	
	var activeCenter = Vector2(
		activePosition[0] + (activeSize[0] / 2) - 12.5,
		activePosition[1] + (activeSize[1] / 2) - 12.5
	)


#	print("ACTIVE: ", rect_global_position)
#	print("SIZE: ", rect_size)
#
#	var numRows = int((totalChildren - 1) / 20)
#
#
#
#	var activeCenter = Vector2(
#		activePosition[0] + 8 + ( (totalChildren - 1 - (numRows * 20)) * 8),
#		activePosition[1] + (numRows * 29)
#		)
#	print("CENTER: ", activeCenter)
##
	return activeCenter


	
	
	


# Add mini chips to container, but add another row if width passes 200
func addMini(mini):
	var numChildren = activeContainer.get_children().size()
	if(numChildren >= maxChildren):
		addNewRow()
	if(totalChildren < totalMax):
		activeContainer.add_child(mini)
		totalChildren += 1

	lastAdded = mini.rect_global_position
		
		
func clear():
	totalChildren = 0
	# We could just remove all rows and add a new one?
	for _child in rowContainer.get_children():

		rowContainer.remove_child(_child)
		_child.queue_free()
		
		print("REMOVING CHILDREN: ", rect_global_position)
	
	# Not sure if this does anything
	rowContainer.margin_left = 0
	rowContainer.margin_top = 0
	rowContainer.margin_right = 20
	rowContainer.margin_bottom = 20
	rowContainer.rect_size = Vector2(20, 20)
	addNewRow()
	
	
	
	
#	while rowContainer.get_child_count() > 1:
#		for _child in rowContainer.get_children():
#			_child.queue_free()
#
#	activeContainer = rowContainer.get_children()[0]
#
#	for _child in activeContainer.get_children():
#		activeContainer.remove_child(_child)
#		_child.queue_free()
#
#	totalChildren = 0
	
	


	
func addNewRow():
	var newRow = HBoxContainer.new()
	newRow.theme = miniChipTheme
	newRow.rect_size = Vector2(20, 20)
	rowContainer.add_child(newRow)
	activeContainer = newRow
	
