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
			
			# Get card sprites
			if textureStore.has(textureKey):
				cardTexture = textureStore[textureKey]
			else:
				var cardSprite  = frontDir + "/" + suit + "/" + String(type) + ".png"
				cardTexture = load(cardSprite)
				textureStore[textureKey] = cardTexture
				
			if textureStore.has("backtext"):
				backTexture = textureStore["backtext"]
			else:
				backTexture = load(backDir + "/" + "01.png")
				textureStore['backtext'] = backTexture
				
			print("creating: ", textureKey)
			
			# Instance the card, pass textures and store 
			var tempCard = cardScene.instance()
			tempCard.init(cardTexture, backTexture, suit, type, hardValue, softValue)
			deck.push_back(tempCard)
	return deck
			
		
