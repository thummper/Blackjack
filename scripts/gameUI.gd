extends Control


onready var topBar = get_node("GameTopBar")
onready var tabContainer = get_node("CanvasLayer/GameControlWrapper/TabContainer")
onready var tabButtonContainer = get_node("CanvasLayer/GameControlWrapper/TabButtons/TabButtonsHCenter")


var tabButtons = []
var activeButton = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all children of tabContainer
	var tabs = tabContainer.get_children()
	print("TAB CHILDREN: ", tabs)
	
	for i in range(0, tabs.size()):
		var tab = tabs[i]
		var buttonText = tab.name
		var buttonIndex = i
		# Create a button that switches the current tab to I
		
		var newButton = Button.new()
		newButton.text = buttonText
		
		if i == 0:
			activeButton = newButton
		
		tabButtonContainer.add_child(newButton)
		tabButtons.push_back(newButton)
		
		newButton.connect("pressed", self, "tabButtonPressed", [newButton, i])

func tabButtonPressed(button, i):
	tabContainer.current_tab = i
	activeButton = button
	

