extends Node
# Helper class to handle game resolution and to play hand over animations
# Check dealer and all player hands, resolve outcomes
func resolveGame(dealer, human, eventLog, delayTimer):
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
			


