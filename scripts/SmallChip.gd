extends Control
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var textures = {
	"01": load("res://sprites/card_assets/chips/miniChips/01_empty_small.png"),
	"02": load("res://sprites/card_assets/chips/miniChips/02_empty_small.png"),
	"03": load("res://sprites/card_assets/chips/miniChips/03_empty_small.png"),
	"04": load("res://sprites/card_assets/chips/miniChips/04_empty_small.png"),
	"05": load("res://sprites/card_assets/chips/miniChips/05_empty_small.png"),
	"06": load("res://sprites/card_assets/chips/miniChips/06_empty_small.png"),
}

func setTexture(name):
	$Sprite.texture = textures[name]
	rect_min_size = Vector2(25, 25)
