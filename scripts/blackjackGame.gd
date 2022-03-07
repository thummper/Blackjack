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



""" 
GAMESTATES:
	0 - GAME NOT STARTED
	1 - ALL BETS HAVE BEEN MADE
"""
var gamestate = null

func _init(deck, humanPlyer, aiPlyers, dealerPlyer, controls):
	assignDeck(deck)
	dealer = dealerPlyer
	ais    = aiPlyers
	humanPlayer = humanPlyer
	gameControls = controls
	
	print(gameControls)
	
	# Init 0 gamestate
	changeGameState(0)

	
	

func assignDeck(deck):
	gameDeck = deck
	# Not sure if leave this in, some games burn card on game start?
	gameDeck.burn(1)
	
	
	
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
	dealCard(dealerPosition, faceup)


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
	
	




