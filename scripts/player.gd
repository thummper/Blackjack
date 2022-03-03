var madeBet = false

var money
var ai

var handsPlayed = 0
var handsWon    = 0
var handsPush   = 0
var blackjacks  = 0
var handsSurrendered = 0

var currentBet  = 0


func _init(startingMoney, isAI = false):
	ai    = isAI
	money = startingMoney
	
	
func endBetting():
	madeBet = true
	
func handOver():
	madeBet = false
	
