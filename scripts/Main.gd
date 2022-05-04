extends Node

export var oc: Color
var cardFactory   = preload("res://scripts/CardFactory.gd").new()
var gameDeck      = preload("res://scripts/GameDeck.gd").new(cardFactory)

var playerScript  = preload("res://scripts/player.gd")
var blackjackGame = preload("res://scripts/blackjackGame.gd")
var activeCards   = []
var chipTrayVisible = true
var playing = false
var humanPlayer = null

var currentGame = null
# We can only start playing once all bets have been placed
var betsMade = false
onready var actionButtons = get_node("UI Layer/UIWRAPPER/TempActionUI")
onready var trayButton    = get_node("UI Layer/UIWRAPPER/BottomUI/ChipButtonContainer/trayButtonVAlign/trayButton")
onready var uiAnimations  = get_node("UI Layer/UI ANIMATIONS")
onready var moneyLabel    = get_node("UI Layer/UIWRAPPER/MoneyContainer/playerMoney")
onready var miniChip      = preload("res://scenes/SmallChip.tscn")
onready var cardSpawn     = get_node("UI Layer/UIWRAPPER/CardSpawnPoint")
onready var gameDealActions = get_node("UI Layer/UIWRAPPER/BottomUI/DealActions")
onready var cardTween     = get_node("CardTween")
onready var delayTimer    = get_node("DelayTimer")
onready var eventLog = get_node("UI Layer/UIWRAPPER/EventLog")

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
	"eventLog": eventLog
}





onready var playerPosition = get_node("TableWrapper/PlayerPos/PlayerSpot")
onready var dealerPosition = get_node("TableWrapper/DealerPos/DealerSpot")






# Called when the node enters the scene tree for the first time.
func _ready():
	# Init Human Player
	humanPlayer = playerScript.new(1000, false)
	humanPlayer.assignPosition(playerPosition)
	# Init Dealer
	var dealer = playerScript.new(0, false)
	dealer.assignPosition(dealerPosition)
	# Generate initial game deck TODO: Pass this to game script entirely
	gameDeck.generateDeck(2)
	# 3 - Pass all information to the blackjack handler
	currentGame = blackjackGame.new(gameDeck, humanPlayer, dealer, gameControls)
	# 4 - Connect game action buttons to the current game
	connectGameSignals()

func connectGameSignals():
	actionButtons.hitButton.connect("pressed", currentGame, "playerAction", [actionButtons.hitButton])
	actionButtons.standButton.connect("pressed", currentGame, "playerAction", [actionButtons.standButton])
	actionButtons.doubleButton.connect("pressed", currentGame, "playerAction", [actionButtons.doubleButton])
	actionButtons.splitButton.connect("pressed", currentGame, "playerAction", [actionButtons.splitButton])
	actionButtons.surrenderButton.connect("pressed", currentGame, "playerAction", [actionButtons.surrenderButton])






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


func trayButtonMouseEnter():
	trayButton.setLight()

func trayButtonMouseExit():
	trayButton.setDark()




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
