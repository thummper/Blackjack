extends Node

export var oc: Color
var cardFactory = preload("res://scripts/CardFactory.gd").new()
var gameDeck    = preload("res://scripts/GameDeck.gd").new(cardFactory)
var debugPoint  = preload("res://scenes/Point.tscn")
var playerScript = preload("res://scripts/player.gd")
var activeCards = []
var chipTrayVisible = true
var playing = false 
# We can only start playing once all bets have been placed
var betsMade = false
onready var trayButton = get_node("UI Layer/UIWRAPPER/BottomUI/BottomHBOX/trayButtonVAlign/trayButton")
onready var uiAnimations = get_node("UI Layer/UI ANIMATIONS")


var playerInformation = {
	"startingMoney": 1000,
	"handsPlayed": 0,
	"handsWon": 0,
	"handsLost": 0,
	"handsSurrendered": 0
}

# Logic to make players? 
var mainPlayer = playerScript.new(1000, false)


var activePlayers = [mainPlayer]
# TODO: Logic for player to pick position
# TODO: Other places should be filled with AI
onready var blackjackPositions = [
	{"position" : get_node("ControlWrapper/PlayerPositions/SPOT_0"), "player": mainPlayer},
	{"position" : get_node("ControlWrapper/PlayerPositions/SPOT_1"), "player": "none"},
	{"position" : get_node("ControlWrapper/PlayerPositions/SPOT_2"), "player": "none"},
	{"position" : get_node("ControlWrapper/PlayerPositions/SPOT_3"), "player": "none"},
	{"position" : get_node("ControlWrapper/PlayerPositions/SPOT_4"), "player": "none"}
]
onready var dealerPosition = get_node("ControlWrapper/DealerPos/DealerSpot")
onready var delayTimer     = get_node("DelayTimer")

#export var numberofDecks = 1
#var GameDeck = preload("res://Scenes/GameDeck.tscn").instance()


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var blackjackGame = preload("res://scripts/blackjackGame.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	# Generate game deck 
	gameDeck.generateDeck(2)
	blackjackGame = blackjackGame.new(gameDeck, blackjackPositions, dealerPosition, delayTimer)

	
	
#	var pSpots = get_tree().get_nodes_in_group("pSpot")
#	for spot in pSpots:
#		print("SPOT: ", spot.c1, spot.c2)
#		var c1 = gameDeck.getCard()
#		var c2 = gameDeck.getCard()
#		activeCards.push_back(c1)
#		activeCards.push_back(c2)
#		spot.c1.add_child(c1)
#		spot.c2.add_child(c2)



# Loop through all active players, check if bets have been made
func checkBetting():
	var allBetsMade = true
	for player in activePlayers:
		if player.madeBet == false:
			allBetsMade = false
	betsMade = allBetsMade

func _process(delta):
	# If not playing, check if all bets have been made
	if(!playing):
		checkBetting()

		
	
	
	
	if(betsMade && !playing):
		blackjackGame.startGame()
		playing = true
	

		
		



func showChipTray():
	pass
	
func hideChipTray():
	pass



func _on_Timer_timeout():
	for card in activeCards:
		card.flip()

	pass # Replace with function body.





func trayButtonMouseEnter():
	trayButton.setLight()




func trayButtonMouseExit():
	trayButton.setDark()




func showTray():
	if chipTrayVisible != true:
		uiAnimations.play_backwards("trayClose")
		trayButton.flip_v = false
		chipTrayVisible = true

func hideTray():
	if chipTrayVisible:
		uiAnimations.play("trayClose")
		trayButton.flip_v = true
		chipTrayVisible = false

func trayButton_pressed():
	if chipTrayVisible:
		hideTray()
	else:
		showTray()

	pass


func player_hit():
	pass # Replace with function body.


func player_double():
	pass # Replace with function body.


func player_split():
	pass # Replace with function body.


func player_stand():
	pass # Replace with function body.


func player_surrender():
	pass # Replace with function body.





func _on_DelayTimer_timeout():
	print("timeout")
	pass # Replace with function body.


func _on_TempActionUI_confirm_bet():
	print("Human player confirms bet")


func chipButtonPressed(action):
	print("CHIP BUTTON: ", action)
	pass # Replace with function body.
