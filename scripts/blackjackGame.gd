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
""" 
GAMESTATES:
	0 - GAME NOT STARTED
"""
var gamestate = 0

func _init(deck, positionInfo, dealerPos, timer):
	gameDeck  = deck
	positions = positionInfo
	dealerPosition = dealerPos
	delayTimer = timer
	
func startGame():
	#1 - Burn 1 card from the deck 
	gameDeck.burn(1)
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
	dealCard(dealerPosition, faceup)







func dealToPlayers():
	# Loop through positions in order
	for pos in positions:
		# If there is a player
		if pos.player != "none":
			# Deal a card to the position
			print("Dealing to player in position: ", pos.position, " player is: ", pos.player)
			dealCard(pos.position, true)
			delayTimer.start(2)
			yield(delayTimer, "timeout")

			
			
			
func dealCard(position, faceUp):
	var card = gameDeck.getCard()
	if(faceUp):
		# By default dealt cards are face down
		card.showCard()
	position.addCard(card)
	
	




