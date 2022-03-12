extends Control

export var outlineColor: Color
export var dealer = false
export var order  = 0


onready var c1 = $CARD1
onready var c2 = $CARD2
var cards = []

var betValue = 0
onready var uiBetValue = get_node("BettingInfo/VBoxContainer/BetAmount")
onready var miniContainer = get_node("BettingInfo/BetDisplay")



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
	if(betValue == 0):
		uiBetValue.visible = false
		miniContainer.visible = false
	else:
		uiBetValue.visible = true
		miniContainer.visible = true


func addCard(card):
	print("ADDING: ", card)
	if cards.size() < 2:
		cards.push_back(card)
		showCard(card)
		
		
func getCardSlot():
	if(c1.get_child_count() == 0):
		return c1
	else:
		return c2
		
func showCard(card):
	print("CARD: ")
	card.printTextures()
	print("Adding card as child")
	if (c1.get_child_count() == 0):
		c1.add_child(card)
		card.showCard()
	elif (c2.get_child_count() == 0):
		c2.add_child(card)
	else: 
		push_error("Failed to show card in c1 or c2, they both had more than 0 children")
		
	print(c2.get_children())
	print(c1.get_children())


func addMiniChip(mini):
	# Pass off to bet display as sizing logic is in there 
	miniContainer.addMini(mini)




func addBetValue(amount):
	betValue += amount
	uiBetValue.text = "£" + String(betValue)
	
	
func calculateValue():
	print("Should calc value")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
