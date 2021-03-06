extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


var backgroundColor = GameVars.outlineColor


func setDark():
	backgroundColor = GameVars.outlineColor
	update()
	
func setLight():
	backgroundColor = GameVars.outlineLight
	update()
func _draw():
	var style_box = StyleBoxFlat.new()
	style_box.set_expand_margin_all(5)
	style_box.set_corner_radius_all(2)
	style_box.bg_color = backgroundColor
	draw_style_box(style_box, Rect2(Vector2(0,0), rect_size))
