tool
extends Node2D


export var color: Color
export var radius: int
export var width: int


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _draw():
	draw_arc(Vector2(0, 0), radius, 0, TAU, 30, get_owner().outlineColor, width)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
