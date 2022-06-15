signal playerMoneyWin

var madeBet      = false
var handResolved = false
var madeAction   = false

var money
var ai

var handsPlayed = 0
var handsWon    = 0
var handsPush   = 0
var handsLost   = 0
var blackjacks  = 0
var handsSurrendered = 0
var playingPosition  = null
var currentBet  = 0
var moneyToAdd  = 0


# Number of seconds it takes to finish full money animation
const moneyAddTime = 5
var moneyAnimationAmount = 0




func _init(startingMoney, isAI = false):
	ai    = isAI
	money = startingMoney


func bet(amount):
	currentBet += amount

func endBetting():
	if(currentBet > 0):
		print("Player ended betting phase")
		madeBet = true
	else:
		print("Player tried to end betting phase without making a bet")

func handOver():
	madeBet      = false
	handResolved = false
	currentBet = 0


func assignPosition(position):
	playingPosition = position

func revealAllCards():
	playingPosition.revealAllCards()


# Empty cards from playing position and reset internal vars (value)
func clearHand():
	playingPosition.clearPosition()
	pass



"""
_res
0 - lose
1 - win
2 - push
"""
func gameResolved(_res):
	print("RESOLVE GAME: ", _res)
	# Regardless of outcome, we have played a game
	handsPlayed += 1
	if _res == 0:
		handsLost += 1
		handOver()
	elif _res == 1:
		handsWon += 1
		winMoney(currentBet * 1.5)
		
		handOver()
	elif _res == 2:
		handsPush += 1
		winMoney(currentBet)
		handOver()
	playingPosition.setFeedback(_res)
	

func winMoney(amount):
	emit_signal("playerMoneyWin")
	addMoney(amount)


# Add money and remove money should triggle addAmount to be updated
func addMoney(amount):
	print("Player should be given: ", amount)
	moneyToAdd += amount
	updateMoneyAnimationAdd()
	
func removeMoney(amount):
	print("Player should spend: ", amount)
	moneyToAdd -= amount
	updateMoneyAnimationAdd()


func updateMoneyAnimationAdd():
	moneyAnimationAmount = moneyToAdd / moneyAddTime
	print("ANIMATION AMOUNT: ", moneyAnimationAmount)

func updatePlayerMoney(delta):
	var addAmount = 0
	if moneyToAdd != 0:
		# If money below a threshold, just add it
		if abs(moneyToAdd) <= 100:
			addAmount = moneyToAdd
		else:
			# Otherwise, just add the amount of money we need to finish the animation in x seconds
			addAmount = round(moneyAnimationAmount * delta)
			
		print("ADD AMOUNT: ", addAmount)
		
		
		money += addAmount
		
		if(addAmount < 0):
			# We are removing money
			moneyToAdd += abs(addAmount)
		else:
			moneyToAdd -= abs(addAmount)
			
			

				
			
		#print("ADD AMOUNT: ", addAmount, " MONEY TO ADD: ", moneyToAdd)
		


