extends Node
# Helper class to handle game resolution and to play hand over animations
# Check dealer and all player hands, resolve outcomes
func resolveGame(dealer, human, eventLog, moneyLabelUpdater):
	print("GAME RESOLVE")
	
	""" 
	To resolve the game we need:
		- Dealer Entitiy
		- Human Entitiy
		- Message log reference to print into the log
		- Ability to update the player money label
		
		We also need
		- Mini Chip Reference
		- The minichip spawn point in the players hand
		- The location of the players money display
		- The chip tween instance
		This is so we can play a nice chip animation when we make money
	
	"""

	var dealerBust = false
	var dealerValue = dealer.playingPosition.handValue

	if dealerValue > 21:
		dealerBust = true

	var playerBust = false
	var playerValue = human.playingPosition.handValue

	if dealerBust and playerBust:
		human.gameResolved(0)
		eventLog.addMessage("System", "Player and dealer have both bust")
	elif !dealerBust and playerBust:
		human.gameResolved(0)
		eventLog.addMessage("System", "Player has bust but dealer has not")
	elif dealerBust and !playerBust:
		human.gameResolved(1)
		eventLog.addMessage("System", "Dealer bust but player did not")
	elif !dealerBust and !playerBust:
		eventLog.addMessage("System", "Neither player has bust")
		# As neither player busted, the logic is a bit more advanced

		if playerValue > dealerValue:
			human.gameResolved(1)
			eventLog.addMessage("System", "Player hand beats Dealer hand")
		elif playerValue == dealerValue:
			human.gameResolved(2)
			eventLog.addMessage("System", "Hands are equal, draw")
		else:
			human.gameResolved(0)
			eventLog.addMessage("System", "Delaer hand beats Player")




	



	
	
	
#	gameControls.eventLog.addMessage("System", "Resolving game..")
#	var dealerBust  = false
#	var dealerValue = dealer.playingPosition.handValue
#	if dealerValue > 21:
#		dealerBust = true
#
#	for pos in dealingOrder.keys():
#		var player = dealingOrder[pos]
#		if player != null:
#			var playerBust = false
#			var playerPos  = player.playingPosition
#
#
#			var playerValue = playerPos.handValue
#
#
#			if playerValue > 21:
#				playerBust = true
#
#			if dealerBust and playerBust:
#				player.gameResolved(0)
#				gameControls.eventLog.addMessage("System", "Both players bust")
#			elif !dealerBust and playerBust:
#				player.gameResolved(0)
#				gameControls.eventLog.addMessage("System", "Player bust but dealer did not")
#			elif dealerBust and !playerBust:
#				player.gameResolved(1)
#				gameControls.eventLog.addMessage("System", "Dealer bust but player did not")
#			elif !dealerBust and !playerBust:
#				gameControls.eventLog.addMessage("System", "Neither player bust")
#				if playerValue > dealerValue:
#					gameControls.eventLog.addMessage("System", "Player hand beats dealer")
#					player.gameResolved(1)
#				else:
#					if playerValue == dealerValue:
#						gameControls.eventLog.addMessage("System", "Hands are equal")
#						player.gameResolved(2)
#					else:
#						gameControls.eventLog.addMessage("System", "Dealer hand beats player")
#						player.gameResolved(0)
#
#			updateMoneyLabel()
#
#	# Dealer has no player vars to resolve, we only need to reset the hands at this point
#	# This is separate to gameResolved in case i need to slide animations in here
#	activePlayer.playingPosition.hideTurnIndicator()
#	# Before we call clear position, ideally we need some UI animation to play depending on the result for the player
#	gameControls.delayTimer.start(1.0)
#	yield(gameControls.delayTimer, "timeout")
#
#	for pos in dealingOrder.keys():
#		var player = dealingOrder[pos]
#		if player != null:
#			player.clearHand()
#	# Clear dealer hand also
#	dealer.clearHand()
#	changeGameState(0)

