tool
extends Node2D


export var color: Color
export var radius: int
export var width: int



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _draw():
	draw_arc(Vector2(0, 0), radius, 0, TAU, 30, color, width)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
