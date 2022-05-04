# Card factory creates cards and handles their sprites
const frontDir  = "res://sprites/card_assets"
const backDir   = "res://sprites/card_assets/backs"
const cardScene = preload("res://scenes/card.tscn")
var suitNames   = ["clubs", "diamonds", "hearts", "spades"]
var cardTypes   = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"]
var textureStore = {}
# Ace is a special value case, all other cards have the same soft/hard values
var cardValues = {
	2: 2,
	3: 3,
	4: 4,
	5: 5,
	6: 6,
	7: 7,
	8: 8,
	9: 9, 
	10: 10,
	"J": 10,
	"Q": 10,
	"K": 10
}





func _init():
	pass
	
# Need random card generator for main menu
func generateRandomCard():
	# Pick random suit and type
	var randomSuit = suitNames[ randi() % suitNames.size() ]
	var randomType = cardTypes[ randi() % cardTypes.size() ]
	var textureKey = randomSuit + String(randomType)
	# Get or load textures
	var cardTextures = getCardSprites(randomSuit, randomType)
	# Make card
	var tempCard = cardScene.instance()
	tempCard.init(cardTextures.front, cardTextures.back, randomSuit, randomType, 1, 1)
	tempCard.flip()

	return tempCard
	


func getCardSprites(cardSuit, cardType):
	var textureKey  = cardSuit + String(cardType)
	var cardTexture = null
	var backTexture = null
	if textureStore.has(textureKey):
		cardTexture = textureStore[textureKey]
	else:
		# Load from sprites, store loaded texture in texture store
		var cardSprite  = frontDir + "/" + cardSuit + "/" + String(cardType) + ".png"
		cardTexture = load(cardSprite)
		textureStore[textureKey] = cardTexture
	# Check if cardback is loaded
	if textureStore.has("backtext"):
		backTexture = textureStore["backtext"]
	else:
		backTexture = load(backDir + "/" + "01.png")
		textureStore['backtext'] = backTexture
		
	return {
		"front": cardTexture,
		"back": backTexture
	}
	
func generateDeck():
	# Create and return deck
	var deck = []
	for suit in suitNames:
		for type in cardTypes:
			var textureKey  = suit + String(type)
			var cardTexture = null
			var backTexture = null
			var hardValue   = 0
			var softValue   = 0
			# Get card value
			if String(type) == "A":
				hardValue = 1
				softValue = 11
			else:
				hardValue = cardValues[type] 
				softValue = hardValue
			var cardTextures = getCardSprites(suit, type)
			var tempCard = cardScene.instance()
			tempCard.init(cardTextures.front, cardTextures.back, suit, type, hardValue, softValue)
			deck.push_back(tempCard)
	return deck
			
		
