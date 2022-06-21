extends Control

export var outlineColor: Color
export var dealer = false
export var order  = 0

onready var c1 = $CARD1
onready var c2 = $CARD2
var cards = []

var betValue  = 0

var hardValue = 0
var softValue = 0

var handValue = 0

var valueVisible = false
var cardTween = null

var aceInHand = false
var aceSoft   = true
var feedbackLabel = 0


onready var uiBetValue     = get_node("BettingInfo/VBoxContainer/BetAmount")
onready var miniContainer  = get_node("BettingInfo/BetDisplay")
onready var valueContainer = get_node("ValueControl")
onready var valueLabel     = get_node("ValueControl/HandValue")
onready var turnIndicator  = get_node("CENTER/TurnIndicator")
onready var cardPivot      = get_node("CardPivot")
onready var handFeedback = get_node("feedbackWrapper/handFeedback")
onready var spotAnimations = get_node("PositionPlayer")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func showTurnIndicator():
	turnIndicator.drawIndicator = true
	turnIndicator.update()

func hideTurnIndicator():
	turnIndicator.drawIndicator = false
	turnIndicator.update()



func setCardTween(_cardTween):
	cardTween = _cardTween

# Called when the node enters the scene tree for the first time.
func _ready():
	handFeedback.visible = false


func _process(_delta):
	if(handValue == 0):
		valueContainer.visible = false
	else:
		valueContainer.visible = true

	if(betValue == 0):
		uiBetValue.visible = false
		miniContainer.visible = false
	else:
		uiBetValue.visible = true
		miniContainer.visible = true



func updateCardPositions(newCard):
	for n in cardPivot.get_children():
		cardPivot.remove_child(n)

	var spacing = 40
	var vertShrink = 0.003
	var start = Vector2(-(spacing / 2) - (spacing * ((float(cards.size()) / 2) - 1)), 0)

	var i = 0
	for _card in cards:
		var x = start.x + (spacing * i)
		var y = vertShrink * pow(x, 2)
		# We need to tween the card from start position to current position
		cardPivot.add_child(_card)
		if _card == newCard:
			# Tween from startLocation
			_card.global_position = _card.startLocation
			print("Tween from: ", _card.startLocation, " to: ", rect_global_position + Vector2(x, y))
			cardTween.interpolate_property(_card, "position", _card.position, Vector2(x, y), 0.45, Tween.EASE_OUT)
			cardTween.start()
		else:
			print("Tween from: ", _card.position, " to: ", Vector2(x, y))
			cardTween.interpolate_property(_card, "position", _card.position, Vector2(x, y), 0.3, Tween.EASE_OUT)
			cardTween.start()
		i += 1

	var constRot = 7
	var startRot = -(constRot / 2) - (constRot * ((float(cards.size()) / 2) - 1))

	i = 0
	for _card in cards:
		cardTween.interpolate_property(_card, "rotation_degrees", _card.rotation_degrees, (startRot + constRot * i), 0.25)
		cardTween.start()
		i += 1






# We need a better function for add card
func addCard(card):
	# Given a card, add it to the board (and return its position?)
	cards.push_back(card)
	updateCardPositions(card)











func addMiniChip(mini):
	# Pass off to bet display as sizing logic is in there
	miniContainer.addMini(mini)



func addBetValue(amount):
	betValue += amount
	uiBetValue.text = "£" + String(betValue)


func calculateValue():

	aceInHand = false
	# Ace is soft if it is 11
	aceSoft   = true


	handValue = 0
	for card in cards:
		if card.flipped:
			if String(card.type) == "A":
				if !aceInHand:
					aceInHand = true
					handValue += 11
				else:
					# Already an ace in hand
					handValue += 1
			else:
				handValue += card.hardVal

			if handValue > 21 and aceInHand and aceSoft:
				print("LOWER HAND VALUE")
				aceSoft = false
				handValue -= 10



	# If we bust on hardValue


	if handValue != 0:
		if !valueVisible:
			spotAnimations.play_backwards("fadeValue")
			yield(spotAnimations, "animation_finished")
			valueVisible = true

	if aceInHand and aceSoft:
		valueLabel.text = String(handValue) + " " + " (" + String(handValue - 10) + ")"
	else:
		valueLabel.text = String(handValue)




func revealAllCards():
	for _card in cards:
		if !_card.flipped:
			_card.showCard()
	calculateValue()



func setFeedback(_res):
	feedbackLabel = _res



# Reset function for playing position - everything should be shiny and new 
func clearPosition():
	betValue  = 0
	cards     = []
	miniContainer.clear()


	if !dealer:
		# We should fade out the hand value indicator
		print("Fading hand value")
		# Set hand feedback if not dealer
		handFeedback.setLabel(feedbackLabel)
		handFeedback.visible = true

	# Feedback info comes in
	spotAnimations.play("feedbackIn")
	handFeedback.playTextFade()
	yield(spotAnimations, "animation_finished")
	# Timeout
	yield(get_tree().create_timer(0.5),"timeout")
	# Hand value fades out
	spotAnimations.play("fadeValue")
	yield(spotAnimations, "animation_finished")
	handValue = 0
	valueVisible = false
	# Timeout
	yield(get_tree().create_timer(0.5),"timeout")
	# Feedback info fades out
	handFeedback.playTextFade()
	spotAnimations.play_backwards("feedbackIn")
	yield(spotAnimations, "animation_finished")


	# Tween all cards to 0 position
	for _card in cardPivot.get_children():
		cardTween.interpolate_property(_card, "position", _card.position, Vector2(0, 0), 0.6)
		cardTween.interpolate_property(_card, "rotation_degrees", _card.rotation_degrees, 0, 0.6)
		cardTween.start()

	yield(cardTween, "tween_all_completed")

	# Remove all cards
	for _card in cardPivot.get_children():
		_card.queue_free()


