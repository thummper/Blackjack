tool
extends Control


onready var label = get_node("CenterLabel/Label")
onready var feedbackPlayer = get_node("FeedbackPlayer")
var style = StyleBoxFlat.new()

var feedbackInfo = [
	{"label": "Win", "colour": "#c80c2619"},
	{"label": "Lose", "colour": "#c87a0006"},
	{"label": "Push", "colour": "#8c706c38"}
]

export var green: Color 



func setLabel(_feedback):
	var info   = feedbackInfo[_feedback]
	var _label  = info.label
	var colour = info.colour
	label.text = _label
	style.set_corner_radius_all(3)
	style.set_expand_margin_all(1)
	style.set_bg_color(colour)
	add_stylebox_override("panel", style)
	update()
	
func playTextFade():
	feedbackPlayer.play("fadeText")
	
func _draw():
	draw_style_box(style, Rect2(Vector2(0,0), rect_size))


