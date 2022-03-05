extends VBoxContainer

var backgroundColor = GameVars.outlineColor
func _draw():
	var style_box = StyleBoxFlat.new()
	style_box.set_expand_margin_individual(10, 0, 10, 0)
	style_box.set_corner_radius_all(2)
	style_box.bg_color = backgroundColor
	draw_style_box(style_box, Rect2(Vector2(0,0), rect_size))
