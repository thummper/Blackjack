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
	# Regardless of outcome, we have played a game
	handsPlayed += 1
	if _res == 0:
		handsLost += 1
		handOver()
	elif _res == 1:
		handsWon += 1
		money += currentBet * 1.5
		handOver()
	elif _res == 2:
		handsPush += 1
		money += currentBet
		handOver()



