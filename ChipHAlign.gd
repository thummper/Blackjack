extends HBoxContainer
signal makeBet
# Programatically define chip buttons.
var chipButtons = [
	{
		"name": "01",
		"betAmount": 1,
		"texturePath": "res://sprites/card_assets/chips/01/"
	},
	{
		"name": "02",
		"betAmount": 5,
		"texturePath": "res://sprites/card_assets/chips/02/"
	},
	{
		"name": "03",
		"betAmount": 10,
		"texturePath": "res://sprites/card_assets/chips/03/"
	},
	{
		"name": "04",
		"betAmount": 20,
		"texturePath": "res://sprites/card_assets/chips/04/"
	},
	{
		"name": "05",
		"betAmount": 50,
		"texturePath": "res://sprites/card_assets/chips/05/"
	},
	{
		"name": "06",
		"betAmount": 100,
		"texturePath": "res://sprites/card_assets/chips/06/"
	},
]

var textureNames = {
	"normal": "_small_normal.png",
	"pressed": "_small_pressed.png",
	"hover": "_small_hover.png"
}

onready var chipButtonScene = preload("res://scenes/BettingButton.tscn")


func _ready():
	# When added to scene generate all buttons and add them
	for buttonInfo in chipButtons:
		# Instance chip button scene
		var button = chipButtonScene.instance()
		# Assemble texture paths
		var texturePaths = {}
		for text in textureNames:
			texturePaths[text] = load(buttonInfo.texturePath + buttonInfo.name + textureNames[text])
		button.setTextures(texturePaths)
		button.betAmount = buttonInfo.betAmount
		button.chipName = buttonInfo.name
		add_child(button)
		
func betButtonPressed(betAmount, chipName):
	# I really want to handle this in the main script, so will forward the signal
	emit_signal("makeBet", betAmount, chipName)

		

		
		
