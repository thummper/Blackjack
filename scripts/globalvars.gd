extends Node


var eventLogDebug = true

var outlineColor = "#640c2619"
var outlineLight = "#64133c27"



func getUIStyleBox(color: Color, marginExtends: Array, cornerRad: int):
	var style_box = StyleBoxFlat.new()
	style_box.set_expand_margin_individual(
		marginExtends[0],
		marginExtends[1],
		marginExtends[2],
		marginExtends[3]
	)
	style_box.set_corner_radius_all(cornerRad)
	style_box.bg_color = color
	return style_box




