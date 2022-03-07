extends Control
var cards = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func addCard(card):
	cards.push_back(card)
	add_child(card)
