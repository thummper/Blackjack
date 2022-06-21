signal playerMoneyWin

var madeBet      = false
var handResolved = false
var isDealer = false

var money


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

func _init(startingMoney):
	money = startingMoney


func bet(amount):
	currentBet += amount

func endBetting():
	if(currentBet > 0):
		print("Player ended betting phase")
		madeBet = true
	else:
		print("Player tried to end betting phase without making a bet")

func assignPosition(position):
	playingPosition = position

func revealAllCards():
	playingPosition.revealAllCards()







"""
_res
0 - lose
1 - win
2 - push
"""
func gameResolved(_res, upgradeVars):
	print("RESOLVE GAME: ", _res)
	# Regardless of outcome, we have played a game
	handsPlayed += 1
	if _res == 0:
		handsLost += 1
		loseMoney(currentBet, upgradeVars)
	elif _res == 1:
		handsWon += 1
		winMoney(currentBet * 1.5)
	elif _res == 2:
		handsPush += 1
		winMoney(currentBet)
	playingPosition.setFeedback(_res)
	
	
func gameOver():
	# We only carry out most of the variable resets if we are not the dealer
	if(not isDealer):
		# Reset variables
		madeBet = false
		handResolved = false
		currentBet = 0
	# Dealer and players will still clear their hands
	clearHand()
	
		
	

	
# Just calls reset function for playing position
func clearHand():
	# Empty all cards and reset internal variables
	playingPosition.clearPosition()
	# Toggle hide on possible turn indicator
	playingPosition.hideTurnIndicator()
	

func winMoney(amount):
	emit_signal("playerMoneyWin")
	addMoney(amount)

func loseMoney(amount, upgradeVars):
	var loseMod = upgradeVars['handLoseModifier'];
	# Instead of losing the full amount of money, we lose amount * mod
	var lossAmount = amount * loseMod
	var refundAmount = amount - lossAmount
	addMoney(refundAmount)




	



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

		money += addAmount		
		if(addAmount < 0):
			# We are removing money
			moneyToAdd += abs(addAmount)
		else:
			moneyToAdd -= abs(addAmount)

