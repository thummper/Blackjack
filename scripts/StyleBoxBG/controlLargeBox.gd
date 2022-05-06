extends Control

func _draw():
	var bg        = GameVars.outlineColor
	var style_box = GameVars.getUIStyleBox(bg, [0, 0, 0, 0], 2)
	style_box.set_expand_margin_all(6)
	draw_style_box(style_box, Rect2(Vector2(0,0), rect_size))
