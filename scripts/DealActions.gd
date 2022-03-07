extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


onready var dealButton  = get_node("DealButton")
onready var clearButton = get_node("ClearBetButton")

func enableButtons():
	dealButton.disabled  = false
	clearButton.disabled = false
	
	
func disableButtons():
	dealButton.disabled  = true
	clearButton.disabled = true
