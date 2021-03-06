extends Control
export var buttonGroup: ButtonGroup

""" 
I think I will need references to each individual button
so I can toggle enable / disable depending on the game state

"""

onready var hitButton       = get_node("ActionHAlign/HitButton")
onready var standButton     = get_node("ActionHAlign/StandButton")
onready var doubleButton    = get_node("ActionHAlign/DoubleButton")
onready var splitButton     = get_node("ActionHAlign/SplitButton")
onready var surrenderButton = get_node("ActionHAlign/SurrenderButton")

signal hit
signal stand
signal double
signal split
signal surrender

var buttons 


# Called when the node enters the scene tree for the first time.
func _ready():
	buttons = [
		hitButton,
		standButton,
		doubleButton, 
		splitButton,
		surrenderButton,

	];
	
	

func enableButtons():
	print("Enable action buttons")
	for button in buttons:
		button.disabled = false
	
func disableButtons():
	print("Disable action buttons")
	for button in buttons:
		button.disabled = true

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
