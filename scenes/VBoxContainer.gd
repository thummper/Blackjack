extends VBoxContainer


func _draw():
	var bg        = GameVars.outlineColor
	var style_box = GameVars.getUIStyleBox(bg, [0, 0, 0, 0], 2)
	draw_style_box(style_box, Rect2(Vector2(0,0), rect_size))

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
