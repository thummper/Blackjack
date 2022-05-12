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


onready var bottomUI = get_node("UI Layer/UIWRAPPER/BottomUI")

onready var actionButtons = get_node("UI Layer/UIWRAPPER/BottomUI/GameActions")

onready var uiAnimations  = get_node("MainAnimations")
onready var moneyLabel    = get_node("GameUI/GameTopBar/MoneyContainer/playerMoney")
onready var miniChip      = preload("res://scenes/SmallChip.tscn")
onready var cardSpawn     = get_node("GameUI/TableWrapper/CardSpawnPoint")
onready var chipSpawn = get_node("GameUI/GameTopBar/ChipSpawnPoint")


onready var gameDealActions = get_node("UI Layer/UIWRAPPER/BottomUI/BettingInformation/ButtonActions/VerticleCenterButtons/HorizontalCenterButtons")
onready var cardTween     = get_node("CardTween")
onready var chipTween = get_node("ChipTween")
onready var delayTimer    = get_node("DelayTimer")
onready var eventLog = get_node("UI Layer/LeftClone/EventLog")

onready var gameControls = {

	"cardSpawn": cardSpawn,
	"actionButtons": actionButtons,
	"uiAnimations": uiAnimations,
	"dealActions": gameDealActions,
	"cardTween": cardTween,
	"moneyLabel": moneyLabel,
	"delayTimer": delayTimer,

	"eventLog": eventLog
}





onready var playerPosition = get_node("GameUI/TableWrapper/PlayerPos/PlayerSpot")
onready var dealerPosition = get_node("GameUI/TableWrapper/DealerPos/DealerSpot")






# Called when the node enters the scene tree for the first time.
func _ready():
	chipTween.connect("tween_completed", self, "chipTweenCompleted")
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






# Handle money changes here so the UI updates
func changePlayerMoney(amount):
	currentGame.changePlayerMoney(amount)



var animatingChips = []

func chipTweenCompleted(obj, path):
	# Get the most recently added chip
	remove_child(obj)
	var pos = getPlayerPosition()
	var animatingChip = animatingChips.pop_front()
	pos.addMiniChip(animatingChip)
	
	


func addMiniChip(chipName):
	
	var pos = getPlayerPosition()
	# Make a minichip with the correct texture
	var chip = miniChip.instance()
	chip.setTexture(chipName)
	
	# If we reuse the same chip instance the zindex on the tween gets messed up for some reason
	var cleanChip = miniChip.instance()
	cleanChip.setTexture(chipName)
	
	# Generate start and end locations for the animation
	var chipStartLocation = chipSpawn.rect_global_position
	var chipEndLocation = pos.miniContainer.getNextMiniPosition()
	chipEndLocation[0] -= 2

	# Set position of chip to correct location
	add_child(chip)
	chip.rect_global_position = chipStartLocation
	
	chipTween.interpolate_property(chip, "rect_global_position", chip.rect_global_position, chipEndLocation, 1, Tween.EASE_OUT)
	animatingChips.push_back(cleanChip)
	chipTween.start()


func makeBet(amount, chipName):
	# Handles chip button being pressed
	if(currentGame.gamestate == 0 && currentGame.humanPlayer.money >= amount):
		# We can and are making a bet
		currentGame.humanPlayerBet(amount)
		changePlayerMoney(-amount)
		
		
		var pos = getPlayerPosition()
		pos.addBetValue(amount)
		addMiniChip(chipName)





func dealButton_pressed():
	# This means human player has finished betting
	currentGame.humanPlayer.endBetting()



func clearBetButton_pressed():
	print("Should clear bet")

