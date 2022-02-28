extends Control

export var outlineColor: Color
export var dealer = false


onready var c1 = $CARD1
onready var c2 = $CARD2




# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(dealer):
		$ValueControl.anchor_top = 0.5
		$ValueControl.anchor_bottom = 0.5
		$ValueControl.anchor_left = 1.2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
