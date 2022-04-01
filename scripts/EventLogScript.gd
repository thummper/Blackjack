extends Control

onready var eventLog = get_node("VBoxContainer/EventLogContent")
onready var inputLabel = get_node("VBoxContainer/HBoxContainer/Label")
onready var inputField = get_node("VBoxContainer/HBoxContainer/EventLogInput")

var colours = [
	'#2d567c', # Blue 
	'#793638', # Red
	'#b5986e', # Gold
]


func _input(event):
	# Grab and release focus if enter / escape is pressed
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			inputField.grab_focus()
		if event.pressed and event.scancode == KEY_ESCAPE:
			inputField.release_focus()

# Fires when text is entered into EventLogInput
func EventLogInputEntered(text):
	if text != '':
		print(text)
		addMessage("Player", text)
		inputField.text = ''

# Add text and new line to rich text field
func addMessage(username, text, colourIndex = 0):
	eventLog.bbcode_text += '[color=' + colours[colourIndex] + ']'
	eventLog.bbcode_text += '[' + username + ']: '
	eventLog.bbcode_text += '[/color]'
	eventLog.bbcode_text += text 
	eventLog.bbcode_text += "\n"
