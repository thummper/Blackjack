extends Node

# Logic to play blackjack 
var gameDeck
var positions
var dealerPosition
var delayTimer
var dealerHand  = []
var dealerValue = []
var dealerWinnings = 0
var dealerStand    = 17
var bettingEnabled = true


var dealer
var humanPlayer
var ais
var gameControls


var dealingOrder = {
	0: null,
	1: null,
	2: null,
	3: null, 
	4: null
}



""" 
GAMESTATES:
	0 - GAME NOT STARTED
	1 - ALL BETS HAVE BEEN MADE
	2 - GAME IS RUNNING
"""
var gamestate = null

func _init(deck, humanPlyer, aiPlyers, dealerPlyer, controls):
	assignDeck(deck)
	dealer       = dealerPlyer
	ais          = aiPlyers
	humanPlayer  = humanPlyer
	gameControls = controls

	
	
	""" 
	Not sure if good?
	Players are associated with positions, not the other way around
	When dealing, ideally we loop through positions in order and get the player
	So might be better to have this the other way around?
	"""
	dealingOrder[humanPlayer.playingPosition.order] = humanPlayer
	for ai in ais:
		dealingOrder[ai.playingPosition.order] = ai
	print(dealingOrder)
	
	# Init 0 game state to make sure UI elements are toggled
	changeGameState(0)

	
	

func assignDeck(deck):
	gameDeck = deck
	# Not sure if leave this in, some games burn card on game start?
	gameDeck.burn(1)
	



	
	
# Starts a round of blackjack
func startTable():
	# Change game state
	changeGameState(2)
	# Deal 1 to players
	dealToPlayers()
	# Deal 1 down card to dealer
	dealToDealer(false)
	# Deal 2nd up card to players
	yield(gameControls.cardTween, "tween_completed")
	dealToPlayers()
	yield(gameControls.cardTween, "tween_all_completed")
	# Deal 2nd card (up) to dealer
	dealToDealer(true)
	
	
func dealToPlayers():
	# Loop through playing order and deal to them
	for key in dealingOrder:
		var player = dealingOrder[key]
		if(player != null):
			# Deal to this player's position
			var position = player.playingPosition
			dealCard(position, true)
		
	
	
#	# Loop through positions in order
#	for pos in positions:
#		# If there is a player
#		if pos.player != "none":
#			# Deal a card to the position
#			print("Dealing to player in position: ", pos.position, " player is: ", pos.player)
#			dealCard(pos.position, true)
#			delayTimer.start(2)
#			yield(delayTimer, "timeout")
#
	
	
func startGame():
	# We should only start the game once all bets have been made

	#2 - Deal one up card to each player
	dealToPlayers()
	delayTimer.start(0.25)
	yield(delayTimer, "timeout")

	#3 - Deal one down card to 
	dealToDealer(false)
	delayTimer.start(0.25)
	yield(delayTimer, "timeout")
	# 4 - Deal second up card to players
	dealToPlayers()
	delayTimer.start(0.25)
	yield(delayTimer, "timeout")
	# 5 - Deal up card to dealer
	dealToDealer(true)
	delayTimer.start(0.25)
	yield(delayTimer, "timeout")
	
	
func dealToDealer(faceup):
	dealCard(dealer.playingPosition, faceup)


func checkBetting():
	# Loop through players and check if bets have all been made
	var finishedBetting = true
	if(humanPlayer.madeBet != true):
		finishedBetting = false
	for ai in ais:
		if(ai.madeBet != true):
			finishedBetting = false
	if(finishedBetting):
		print("All players have finished betting, should disable betting")
		changeGameState(1)

		

func changeGameState(newstate):
	gamestate = newstate
	match newstate:
		0:
			# Enable betting
			# Technically this already happens, we check game state in main
			# We could toggle the UI
			gameControls.dealActions.enableButtons()
			gameControls.actionButtons.disableButtons()
			# Disable action buttons
			print("Game ended / not playing")
			print("Enable betting / clear bets")
		1:
			gameControls.dealActions.disableButtons()
			gameControls.actionButtons.enableButtons()
			# Disable betting
			# Enable action buttons
			print("Pending game start, disable betting / clear bets")


func humanPlayerBet(amount):
	humanPlayer.bet(amount)


func changePlayerMoney(amount):
	humanPlayer.money += amount




			
			


# Deal card is always called when dealing
# We need to spawn the card and then play animation?
func dealCard(position, faceUp):
	# Get card
	var card = gameDeck.getCard()



	# Get spot the card will go into
	var spot = position.getCardSlot()
	
	
	# Get start and end points of the Tween
	var startLocation = gameControls.cardSpawn.rect_global_position
	var endLocation   = spot.rect_global_position
	
	card.visible = false
	spot.add_child(card)
	card.global_position = startLocation
	card.visible = true
	
	
	# Make Tween work 
	var cardTween: Tween = gameControls.cardTween
	cardTween.interpolate_property(card, "global_position", startLocation, endLocation, 0.6, Tween.EASE_OUT)
	cardTween.start()
	yield(cardTween, "tween_completed")
	# TODO: POSITION HAND VALUE HERE (IF CARDS VISIBLE)
	position.calculateValue()
	

	
	

	
	if(faceUp):
		# By default dealt cards are face down
		card.showCard()

	
	




