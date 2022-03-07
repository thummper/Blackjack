extends Control
var card
var position 

onready var cardTween = get_node("cardTween")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func addCard(c):
	card = c
	add_child(card)

# Move card from spawn to target pos
func moveCard(pos, slot):
	position = pos
	cardTween.interpolate_property(card, "global_position", card.global_position, slot.rect_global_position, 0.75, Tween.TRANS_CUBIC)
	cardTween.start()

func cardMoveFinished(object, key):
	remove_child(card)
	position.addCard(card)

