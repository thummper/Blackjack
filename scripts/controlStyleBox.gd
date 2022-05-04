extends Control



func _draw():
	var bg        = GameVars.outlineColor
	var style_box = GameVars.getUIStyleBox(bg, [5, 0, 5, 0], 2)
	draw_style_box(style_box, Rect2(Vector2(0,0), rect_size))

