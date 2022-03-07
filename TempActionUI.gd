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
onready var confirmBetButton = get_node("TempButtonVAlign/ConfirmBetButton")

signal hit
signal stand
signal double
signal split
signal surrender
signal confirm_bet
var buttons 


# Called when the node enters the scene tree for the first time.
func _ready():
	buttons = [
		hitButton,
		standButton,
		doubleButton, 
		splitButton,
		surrenderButton,
		confirmBetButton
	];
	
	for button in buttons:
		button.connect("pressed", self, "actionButtonPressed", [button])
	
	

		
func actionButtonPressed(button):
	print("Pressed passed: ", button)
	var action = button.text.to_lower()
	print("Action: ", action)
	emit_signal(action)
	
func enableButtons():
	for button in buttons:
		button.disabled = false
	
func disableButtons():
	for button in buttons:
		button.disabled = true

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
