extends Node2D

var front
var back
var suit
var type
var softVal
var hardVal
var flipped = false

var spriteScale = 0.6


func init(cardTexture, backTexture, cardSuit, cardType, hardValue, softValue):
	front = cardTexture
	back  = backTexture
	suit  = cardSuit
	type  = cardType
	softVal = softValue
	hardVal = hardValue
	$cardFront.visible = false
	
func _ready():
	$cardFront.texture = front
	$cardBack.texture  = back
	$cardFront.scale =  Vector2(spriteScale, spriteScale)
	$cardBack	.scale =  Vector2(spriteScale, spriteScale)
	
func flip():
	if flipped:
		$cardFront.visible = false
		$cardBack.visible  = true
	else:
		$cardFront.visible = true
		$cardBack.visible  = false
	flipped = !flipped
	




