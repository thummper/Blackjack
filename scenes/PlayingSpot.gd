extends Control

export var outlineColor: Color
export var dealer = false


onready var c1 = $CARD1
onready var c2 = $CARD2
var cards = []





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


func addCard(card):
	if cards.size() < 2:
		cards.push_back(card)
		showCard(card)
		
func showCard(card):
	if (c1.get_child_count() == 0):
		c1.add_child(card)
	elif (c2.get_child_count() == 0):
		c2.add_child(card)
	else: 
		push_error("Failed to show card in c1 or c2, they both had more than 0 children")
		


onready var miniContainer = get_node("BettingInfo/BetDisplay")
func addMiniChip(mini):
	# Pass off to bet display as sizing logic is in there 
	miniContainer.addMini(mini)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
