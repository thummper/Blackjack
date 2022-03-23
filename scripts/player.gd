var madeBet = false
var handResolved = false

var money
var ai

var handsPlayed = 0
var handsWon    = 0
var handsPush   = 0
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
	madeBet    = false
	currentBet = 0


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
func gameResolved(_res):
	if _res == 0:
		handOver()
	elif _res == 1:
		money += currentBet * 1.5
		handOver()
	elif _res == 2:
		money += currentBet
		handOver()



