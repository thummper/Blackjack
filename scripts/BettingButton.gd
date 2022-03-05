extends TextureButton
signal betButton
var betAmount = 1


# Accepts loaded textures, sets button up
func setTextures(textureInfo):
	texture_normal  = textureInfo.normal
	texture_hover   = textureInfo.hover
	texture_pressed = textureInfo.pressed
	
func _ready():
	# These are added programtically and I do not want to pass a reference to the root node here
	# So will pass to parent and parent will link to root (i can do that through ui)

	connect("betButton", get_parent(), "betButtonPressed")
	print("Betting button added to scene")


func buttonPressed():
	# Emit a betting signal for main to handle
	emit_signal("betButton", betAmount)

