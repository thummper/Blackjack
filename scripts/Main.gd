extends Node

export var oc: Color
var cardFactory   = preload("res://scripts/CardFactory.gd").new()
var gameDeck      = preload("res://scripts/GameDeck.gd").new(cardFactory)
var debugPoint    = preload("res://scenes/Point.tscn")
var playerScript  = preload("res://scripts/player.gd")
var blackjackGame = preload("res://scripts/blackjackGame.gd")
var activeCards   = []
var chipTrayVisible = true
var playing = false
var humanPlayer = null
var aiPlayers = []
var currentGame = null
# We can only start playing once all bets have been placed
var betsMade = false
onready var actionButtons = get_node("UI Layer/UIWRAPPER/TempActionUI")
onready var trayButton    = get_node("UI Layer/UIWRAPPER/BottomUI/BottomHBOX/trayButtonVAlign/trayButton")
onready var uiAnimations  = get_node("UI Layer/UI ANIMATIONS")
onready var moneyLabel    = get_node("UI Layer/UIWRAPPER/MoneyContainer/playerMoney")
onready var miniChip      = preload("res://scenes/SmallChip.tscn")
onready var cardSpawn     = get_node("UI Layer/UIWRAPPER/CardSpawnPoint")
onready var gameDealActions = get_node("UI Layer/UIWRAPPER/BottomUI/DealActions")
onready var cardTween     = get_node("CardTween")
onready var delayTimer    = get_node("DelayTimer")


onready var gameControls = {
	"chipTrayControl": trayButton,
	"cardSpawn": cardSpawn,
	"actionButtons": actionButtons,
	"uiAnimations": uiAnimations,
	"dealActions": gameDealActions,
	"cardTween": cardTween,
	"moneyLabel": moneyLabel,
	"delayTimer": delayTimer,
	"trayButton": trayButton,
}



# TODO: Logic for player to pick position
# TODO: Other places should be filled with AI

onready var playerPositions = [
	get_node("ControlWrapper/PlayerPositions/SPOT_0"),
	get_node("ControlWrapper/PlayerPositions/SPOT_1"),
	get_node("ControlWrapper/PlayerPositions/SPOT_2"),
	get_node("ControlWrapper/PlayerPositions/SPOT_3"),
	get_node("ControlWrapper/PlayerPositions/SPOT_4")
];
onready var dealerPosition = get_node("ControlWrapper/DealerPos/DealerSpot")






#export var numberofDecks = 1
#var GameDeck = preload("res://Scenes/GameDeck.tscn").instance()


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# 1 - Assume we are somehow passed logic that assigns the human player to a position
	# Make the human player
	humanPlayer = playerScript.new(1000, false)
	# Assign the human player to their chosen spot
	humanPlayer.assignPosition(playerPositions[0])
	# TODO - GENERATE X AI PLAYERS AND ASSIGN THEM POSITIONS

	# 1.5 - Generate dealer
	var dealer = playerScript.new(0, false)
	dealer.assignPosition(dealerPosition)

	# 2 - Generate the game deck
	gameDeck.generateDeck(2)
	# 3 - Pass all information to the blackjack handler
	currentGame = blackjackGame.new(gameDeck, humanPlayer, aiPlayers, dealer, gameControls)





func getPlayerPosition():
	if(currentGame != null):
		return currentGame.humanPlayer.playingPosition

func trayButton_pressed():
	if currentGame != null:
		if currentGame.chipTrayVisible:
			currentGame.hideTray()
		else:
			currentGame.showTray()

func _process(delta):
	# If we are not currently playing
	if(currentGame.gamestate == 0):
		currentGame.checkBetting()
	elif(currentGame.gamestate == 1):
		currentGame.startTable()
		#print("Blackjack game could start")


# Loop through all active players, check if bets have been made
#func checkBetting():
#	var allBetsMade = true
#	for player in activePlayers:
#		if player.madeBet == false:
#			allBetsMade = false
#	betsMade = allBetsMade

#func _process(delta):
#	# If not playing, check if all bets have been made
#	if(!playing):
#		checkBetting()
#
#	if(betsMade && !playing):
#		blackjackGame.startGame()
#		playing = true
















func trayButtonMouseEnter():
	trayButton.setLight()

func trayButtonMouseExit():
	trayButton.setDark()








func player_hit():
	currentGame.playerHit()
	pass # Replace with function body.


func player_double():
	pass # Replace with function body.


func player_split():
	pass # Replace with function body.


func player_stand():
	print("Caught stand in main")
	currentGame.playerStand()



func player_surrender():
	pass # Replace with function body.








# Handle money changes here so the UI updates
func changePlayerMoney(amount):
	currentGame.changePlayerMoney(amount)





func makeBet(amount, chipName):
	# TODO - all of this logic should be moved to the game class
	# If we are currently allowed to make bets, subtract the money and add info to board
	if(currentGame.gamestate == 0 && currentGame.humanPlayer.money >= amount):
		# We can and are making a bet
		currentGame.humanPlayerBet(amount)
		changePlayerMoney(-amount)

		var mini = miniChip.instance()
		mini.setTexture(chipName)

		var pos = getPlayerPosition()
		pos.addMiniChip(mini)
		pos.addBetValue(amount)

	# TODO toast for failure reason



func dealButton_pressed():
	# This means human player has finished betting
	currentGame.humanPlayer.endBetting()
	pass # Replace with function body.


func clearBetButton_pressed():
	pass # Replace with function body.
