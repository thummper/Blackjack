extends Control

export var outlineColor: Color
export var dealer = false
export var order  = 0


onready var c1 = $CARD1
onready var c2 = $CARD2
var cards = []

var betValue  = 0
var handValue = 0


onready var uiBetValue = get_node("BettingInfo/VBoxContainer/BetAmount")
onready var miniContainer = get_node("BettingInfo/BetDisplay")
onready var valueContainer = get_node("ValueControl")
onready var valueLabel = get_node("ValueControl/HandValue")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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


# Add card to playing spot, return the specific spot it was placed in 
func addCard(card):
	print("Adding card to spot")
	var spot = null
	if cards.size() < 2:
		cards.push_back(card)
		spot = getCardSlot()
		spot.add_child(card)
		
		card.connect("cardFlipped", self, "calculateValue")
		
	else:
		push_error("Card spot is overflowing")
	return spot


		
		
func getCardSlot():
	if(c1.get_child_count() == 0):
		return c1
	elif(c2.get_child_count() == 0):
		return c2
	else:
		push_error("No empty card slots")
		return null
		
		
		



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
	print("Setting value: ", hVal)
	if hVal == sVal:
		valueLabel.text = String(hVal)
	else:
		valueLabel.text = String(hVal) + " " + " (" + String(sVal) + ")"



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
