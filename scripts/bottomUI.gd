extends Control
signal chipButtonPressed


onready var chipButtonContainer = get_node("BottomHBOX/ChipVAlign/ChipHAlign")


func _ready():
	var chipButtons = chipButtonContainer.get_children()
	print(chipButtons)
	
	for chipButton in chipButtons:
		var action = chipButton.name
		chipButton.connect("pressed", self, "chipButtonPressed")
		
		
		emit_signal("chipButtonPressed", action)


func chipButtonPressed():
	print("CHIP PRESSED: ", self)
		


