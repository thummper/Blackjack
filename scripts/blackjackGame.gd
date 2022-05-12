extends Node


var gameResolverScript = preload("res://scripts/blackjackFunctions/gameResolve.gd")

# Logic to play blackjack
var gameDeck
var positions
var dealerPosition
var delayTimer
var dealerHand  = []


var dealerWinnings = 0
var dealerStand    = 17
var bettingEnabled = true
var activePlayer = null
var gameResolver


var dealer
var humanPlayer
var ais
var gameControls
var gamestate = null
var chipTrayVisible = true
var actionButtonsVisible = false

var dealingOrder = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null
}


func _init(_deck, _player, _dealer, controls):
	dealer = _dealer
	humanPlayer = _player
	gameControls = controls
	gameResolver = gameResolverScript.new()
	
	dealingOrder[humanPlayer.playingPosition.order] = humanPlayer
	# Previously had AI assignment to dealing order, TODO: update this structire
	assignDeck(_deck)
	# Progress game state to triggle UI animations
	changeGameState(0)



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
			
			showTray()
			# gameControls.dealActions.enableButtons()
			# gameControls.actionButtons.disableButtons()
			# Disable action buttons
			print("Game ended / not playing")
			print("Enable betting / clear bets")
		1:
			print("Betting phase is finished (by player), dealer will deal")
			# Hide dealing buttons
			hideTray()
		2:
			print("Dealer is dealing")
		3:
			print("Dealing over")
			# Show actions buttons
			showActionButtons()
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
			gameResolver.resolveGame(dealer, humanPlayer, gameControls.eventLog, gameControls.delayTimer)

			gameControls.delayTimer.start(0.5)
			yield(gameControls.delayTimer, "timeout")


			humanPlayer.clearHand()
			dealer.clearHand()
			updateMoneyLabel()
			hideActionButtons()
			
			yield(gameControls.uiAnimations, "animation_finished")
			
			changeGameState(0)




func assignDeck(deck):
	gameDeck = deck
	gameControls.eventLog.addMessage("System", "Deck attached with " +  String(deck.remainingCards) + " cards")
	# Not sure if leave this in, some games burn card on game start?
	gameDeck.burn(1)
	gameControls.eventLog.addMessage("System", "Burnt 1 card from deck")



# Starts a round of blackjack
func startTable():
	# Change to dealing state
	changeGameState(2)
	# Deal 1 face up to all players
	dealTo(humanPlayer, true)
	# Deal 1 face down to dealer
	dealTo(dealer, false)
	yield(gameControls.cardTween, "tween_all_completed")
	# Deal 1 face up to all players
	dealTo(humanPlayer, true)
	yield(gameControls.cardTween, "tween_all_completed")
	# Deal 1 face up card to dealer
	dealTo(dealer, true)
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
	gameControls.eventLog.addMessage("System", "All player hands have been resolved")
	changeGameState(6)


# Resolve dealers hand
func resolveDealer():
	activePlayer = dealer
	dealer.playingPosition.showTurnIndicator()

	gameControls.eventLog.addMessage("System", "Resolving dealer hands")
	dealer.revealAllCards()
	gameControls.eventLog.addMessage("System", "Revealed dealers cards, hand value is: " + String(dealer.playingPosition.handValue))
	# If dealer hand is 21 the dealer has blackjack
	if dealer.playingPosition.hardValue == 21:
		gameControls.eventLog.addMessage("System", "Dealer has blackjack")

	# AHH
	while dealer.playingPosition.handValue <= 17:
		dealTo(dealer, true)

		yield(dealer.playingPosition.cardTween, "tween_all_completed")
		dealer.playingPosition.calculateValue()
		print("DEALER HARD: ", dealer.playingPosition.hardValue)




	changeGameState(7)



func showTray():
	if chipTrayVisible != true:
		gameControls.uiAnimations.play_backwards("HideBettingInfo")
		#gameControls.trayButton.flip_v = false
		chipTrayVisible = true

func hideTray():
	if chipTrayVisible:
		gameControls.uiAnimations.play("HideBettingInfo")
		#gameControls.trayButton.flip_v = true
		chipTrayVisible = false
		
func showActionButtons():
	if !actionButtonsVisible:
		gameControls.uiAnimations.play("ShowGameActions")
		actionButtonsVisible = true
	
func hideActionButtons():
	if actionButtonsVisible:
		gameControls.uiAnimations.play_backwards("ShowGameActions")
		actionButtonsVisible = false

		

# Deal to an entitiy that has a playing position
func dealTo(_player, cardVisible = true):
	print(_player.playingPosition)
	_player.playingPosition.setCardTween(gameControls.cardTween)
	dealCard(_player.playingPosition, cardVisible)
	
	



func checkBetting():
	# Loop through players and check if bets have all been made
	var finishedBetting = true
	if(humanPlayer.madeBet != true):
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

	if humanPlayer.playingPosition == position:
		printCardValue("player", card, position)
	elif dealer.playingPosition == position:
		printCardValue("dealer", card, position)


func printCardValue(entitiy, card, position):
	if card.flipped:
		gameControls.eventLog.addMessage("System", "Dealt " + String(card.softVal) + " | " + String(card.hardVal) + " to " + entitiy)
		gameControls.eventLog.addMessage("System", entitiy + " hand value is: " + String(position.handValue) )
	else:
		gameControls.eventLog.addMessage("System", "Dealt face down card to " + entitiy)





# Handle actions below v
func playerAction(button):
	var action = button.text.to_lower()
	print("Action handled in blackjack core: ", action)
	match action:
		"hit":
			gameControls.eventLog.addMessage("System", "Player hit")
			playerHit()
		"stand":
			gameControls.eventLog.addMessage("System", "Player stand")
			playerStand()
		"surrender":
			gameControls.eventLog.addMessage("System", "Player surrender")
			playerSurrender()
		"split":
			gameControls.eventLog.addMessage("System", "Player split")
			playerSplit()
		"double":
			gameControls.eventLog.addMessage("System", "Player double")
			playerDouble()


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

func playerStand():
	# Check we are waiting for player action
	print(" game stand action: ", gamestate)
	if gamestate == 4:
		# If player presses stand button, end their turn
		activePlayer.handResolved = true
		# Return to playTable loop
		playTable()

func playerSurrender():
	pass

func playerSplit():
	pass

func playerDouble():
	pass











