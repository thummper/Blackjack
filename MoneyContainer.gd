extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _draw():
	var bg        = GameVars.outlineColor
	var style_box = GameVars.getUIStyleBox(bg, [0, 0, 0, 0], 10)
	draw_style_box(style_box, Rect2(Vector2(0,0), rect_size))
