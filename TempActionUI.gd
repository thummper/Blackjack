extends Control
export var buttonGroup: ButtonGroup

""" 
I think I will need references to each individual button
so I can toggle enable / disable depending on the game state

"""

onready var hitButton       = get_node("TempButtonVAlign/HitButton")
onready var standButton     = get_node("TempButtonVAlign/StandButton")
onready var doubleButton    = get_node("TempButtonVAlign/DoubleButton")
onready var splitButton     = get_node("TempButtonVAlign/SplitButton")
onready var surrenderButton = get_node("TempButtonVAlign/SurrenderButton")

signal hit
signal stand
signal double
signal split
signal surrender


# Called when the node enters the scene tree for the first time.
func _ready():
	var buttons = [
		hitButton,
		standButton,
		doubleButton, 
		splitButton,
		surrenderButton
	];
	
	for button in buttons:
		button.connect("pressed", self, "actionButtonPressed", [button])
	
	

		
func actionButtonPressed(button):
	print("Pressed passed: ", button)
	var action = button.text.to_lower()
	print("Action: ", action)
	emit_signal(action)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
