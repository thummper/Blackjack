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

var activePlayer = null


var dealer
var humanPlayer
var ais
var gameControls
var gamestate = null

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
	2 - DEALING
	3 - FINISHED DEALING
"""
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
			print("Betting phase is finished (by player), dealer will deal")
		2:
			print("Dealer is dealing")
		3:
			print("Dealing over")
			gameControls.actionButtons.enableButtons()
			playTable()
		4:
			print("Waiting for player to resolve hand")
		5:
			print("All players have resolved hands")




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
	# Change to dealing state
	changeGameState(2)
	# Deal 1 face up to all players
	dealToPlayers()
	# Deal 1 face down to dealer
	dealToDealer(false)
	yield(gameControls.cardTween, "tween_all_completed")
	# Deal 1 face up to all players
	dealToPlayers()
	yield(gameControls.cardTween, "tween_all_completed")
	# Deal 1 face up card to dealer
	dealToDealer(true)
	yield(gameControls.cardTween, "tween_completed")
	# Dealing over, change to end dealing state
	changeGameState(3)

# Play hands on table
func playTable():
	# Loop through each player that is actually playing
	for pos in dealingOrder.keys():
		var player = dealingOrder[pos]
		print("Play table: ", player)
		# A player has a hand that is not resolved
		if player!= null && !player.handResolved:
			activePlayer = player
			player.playingPosition.toggleTurnIndicator()
			changeGameState(4)






func dealToPlayers():
	# Loop through playing order and deal to them
	for key in dealingOrder:
		var player = dealingOrder[key]
		if(player != null):
			# Deal to this player's position
			var position = player.playingPosition
			position.setCardTween(gameControls.cardTween)
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





func dealToDealer(faceup):
	dealer.playingPosition.setCardTween(gameControls.cardTween)
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






func humanPlayerBet(amount):
	humanPlayer.bet(amount)


func changePlayerMoney(amount):
	humanPlayer.money += amount



# Deal card is always called when dealing
# We need to spawn the card and then play animation?
func dealCard(position, faceUp):
	# Get card
	var card = gameDeck.getCard()
	card.visible = true
	# By default cards are face down, if face up make sure it is added to board flipped
	if(faceUp):
		card.showCard()

	var cardStartLocation = gameControls.cardSpawn.rect_global_position
	card.startLocation = cardStartLocation



	position.addCard(card)
	#var spot =
#	# Get start and end points of the Tween
#	var startLocation = gameControls.cardSpawn.rect_global_position
#	var endLocation   = spot.rect_global_position
#	# Set start location of card
#	card.global_position = startLocation
#	card.visible = true


	# Tween card to final position
#	var cardTween: Tween = gameControls.cardTween
#	cardTween.interpolate_property(card, "global_position", startLocation, endLocation, 0.6, Tween.EASE_OUT)
#	cardTween.start()
#	yield(cardTween, "tween_all_completed")
	# Once card has been added to hand, calculate the hand value
	position.calculateValue()











