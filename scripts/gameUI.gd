extends Control


onready var topBar = get_node("GameTopBar")
onready var tabContainer = get_node("CanvasLayer/GameControlWrapper/TabContainer")
onready var tabButtonContainer = get_node("CanvasLayer/GameControlWrapper/TabButtons/TabButtonsHCenter")

onready var activeTheme = preload("res://misc/Themes/TabActiveTheme.tres")
onready var subTheme = preload("res://misc/Themes/TabSubTheme.tres")


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
			newButton.theme = activeTheme
		else:
			newButton.theme = subTheme 
		
		tabButtonContainer.add_child(newButton)
		tabButtons.push_back(newButton)
		
		newButton.connect("pressed", self, "tabButtonPressed", [newButton, i])

func tabButtonPressed(button, i):
	tabContainer.current_tab = i
	activeButton = button
	
	
	for i in range(0, tabButtons.size()):
		var btn = tabButtons[i]
		btn.theme = subTheme 
	activeButton.theme = activeTheme
	
	
	

