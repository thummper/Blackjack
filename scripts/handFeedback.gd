tool
extends Control



export var winCol: Color #c80c2619
export var loseCol: Color #c87a0006
export var pushCol: Color #8c706c38


onready var label = get_node("CenterLabel/Label")
onready var feedbackPlayer = get_node("FeedbackPlayer")
var style = StyleBoxFlat.new()

var textFaded = true

onready var feedbackInfo = [
	{"label": "Lose", "colour": loseCol},
	{"label": "Win", "colour": winCol},
	{"label": "Push", "colour": pushCol}
]




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
	if !textFaded:
		feedbackPlayer.play("fadeText")
		textFaded = true
	elif textFaded:
		feedbackPlayer.play_backwards("fadeText")
		textFaded = false



func _draw():
	draw_style_box(style, Rect2(Vector2(0,0), rect_size))


