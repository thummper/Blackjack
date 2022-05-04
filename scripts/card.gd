extends Node2D

signal cardFlipped

var front
var back
var suit
var type
var softVal
var hardVal
var flipped = false

var spriteScale = 0.5
var startLocation


func setFrontModulate(hex):
	$cardFront.modulate = hex


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
	$cardBack.scale  =  Vector2(spriteScale, spriteScale)


func showCard():
	$cardFront.visible = true
	$cardBack.visible = false
	if flipped == false:
		# This func called when card is unflipped
		emit_signal("cardFlipped", softVal, hardVal)
		flipped = true


func hideCard():
	$cardFront.visible = false
	$cardBack.visible  = true
	flipped = false

func printTextures():
	print($cardFront.texture)
	print($cardBack.texture)


func flip():
	if flipped:
		hideCard()
	else:
		showCard()
	flipped = !flipped





