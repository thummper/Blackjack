extends Control

export var outlineColor: Color
export var dealer = false
export var order  = 0


onready var c1 = $CARD1
onready var c2 = $CARD2
var cards = []

var betValue  = 0
var handValue = 0

var cardTween = null


onready var uiBetValue     = get_node("BettingInfo/VBoxContainer/BetAmount")
onready var miniContainer  = get_node("BettingInfo/BetDisplay")
onready var valueContainer = get_node("ValueControl")
onready var valueLabel     = get_node("ValueControl/HandValue")
onready var turnIndicator  = get_node("CENTER/TurnIndicator")
onready var cardPivot      = get_node("CardPivot")

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
	if(dealer):
		$ValueControl.anchor_top = 0.5
		$ValueControl.anchor_bottom = 0.5
		$ValueControl.anchor_left = 1.2
		$BettingInfo.visible = false

func _process(delta):
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
	var hVal = 0
	var sVal = 0

	for card in cards:
		if card.flipped:
			hVal += card.hardVal
			sVal += card.softVal
			
	handValue = hVal
	if hVal > 21:
		handValue = sVal
	
	print("Setting value: ", hVal)
	if hVal == sVal:
		valueLabel.text = String(hVal)
	else:
		valueLabel.text = String(hVal) + " " + " (" + String(sVal) + ")"


func revealAllCards():
	for _card in cards:
		if !_card.flipped:
			_card.showCard()
	calculateValue()




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
