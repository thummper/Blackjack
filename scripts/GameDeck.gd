

var cardFactory
var cards = []
var numberDecks
var remainingCards


func _init(factory):
	cardFactory = factory


func generateDeck(numberofDecks):
	numberDecks = numberofDecks
	for i in range(numberofDecks):
		var deck = cardFactory.generateDeck()
		cards.append_array(deck)
	remainingCards = cards.size()
	print("Remaining: ", remainingCards)
	shuffle()

func shuffle():
	if cards.size() > 0:
		cards.shuffle()


func getCard():
	var card = cards.pop_back()
	remainingCards = cards.size()
	return card

func burn(number):
	for i in range(number):
		cards.pop_back()



