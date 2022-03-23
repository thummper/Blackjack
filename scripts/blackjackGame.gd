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
	4 - WAITING FOR PLAYER TO RESOLVE HAND

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
			print("Some placeholder for AI actions determination")
		6:
			print(" All hands have been resolved")
			resolveDealer()
		7:
			print("Dealer has been resolved")
			resolveGame()




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
			# Toggle turn information
			activePlayer = player
			player.playingPosition.showTurnIndicator()


			changeGameState(4)
			# Return so loop does not complete
			return null
		elif player != null && player.handResolved:
			player.playingPosition.hideTurnIndicator()
			print("Player has resolved hand")
	# If loop finishes, all hands are resolved
	print("Play table loop finished")
	changeGameState(6)


# Resolve dealers hand
func resolveDealer():
	# Reveal all cards in dealers hand
	dealer.revealAllCards()
	dealer.playingPosition.showTurnIndicator()


	while dealer.playingPosition.handValue <= 17:
		dealToDealer(true)
		yield(dealer.playingPosition.cardTween, "tween_all_completed")
		dealer.playingPosition.calculateValue()

	print("Final dealer value: ", dealerValue)
	changeGameState(7)

# Check dealer and all player hands, resolve outcomes
func resolveGame():
	var dealerBust  = false
	var dealerValue = dealer.playingPosition.handValue

	if dealerValue > 21:
		dealerBust = true


	for pos in dealingOrder.keys():

		var playerBust = false
		var player     = dealingOrder[pos]

		if player != null:
			var playerValue = player.playingPosition.handValue
			if playerValue > 21:
				playerBust = true

			if dealerBust && playerBust:
				print("Player loses money")
				player.gameResolved(0)
			if dealerBust && !playerBust:
				print("Player wins, dealer bust")
				player.gameResolved(1)
			if !dealerBust && !playerBust:
				if dealerValue > playerValue:
					print("Dealer beat player, no bust")
					player.gameResolved(0)
				if dealerValue < playerValue:
					print("Player beat dealer, no bust")
					player.gameResolved(1)
				else:
					print("Player and dealer tie")
					player.gameResolved(2)
			updateMoneyLabel()














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
	updateMoneyLabel()

func updateMoneyLabel():
	gameControls.moneyLabel.text = "£" + String(humanPlayer.money)


# Deal card is always called when dealing
func dealCard(position, faceUp):
	# Get card
	var card = gameDeck.getCard()
	card.visible = true
	# By default cards are face down, if face up make sure it is added to board flipped
	if(faceUp):
		card.showCard()
	var cardStartLocation = gameControls.cardSpawn.rect_global_position
	card.startLocation    = cardStartLocation
	position.addCard(card)
	position.calculateValue()


func playerStand():
	# Check we are waiting for player action
	print(" game stand action: ", gamestate)
	if gamestate == 4:
		# If player presses stand button, end their turn
		activePlayer.handResolved = true
		# Return to playTable loop
		playTable()


func playerHit():
	if gamestate == 4:
		# Deal to player
		dealCard(activePlayer.playingPosition, true)
		activePlayer.playingPosition.calculateValue()
		# If player has bust end turn
		if activePlayer.playingPosition.handValue > 21:
			print("Player has bust")
			activePlayer.handResolved = true
		playTable()











