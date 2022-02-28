extends Node


var cardFactory = preload("res://scripts/CardFactory.gd").new()
var gameDeck    = preload("res://scripts/GameDeck.gd").new(cardFactory)
var debugPoint  = preload("res://scenes/Point.tscn")
var activeCards = []
#export var numberofDecks = 1
#var GameDeck = preload("res://Scenes/GameDeck.tscn").instance()


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Generate game deck 
	gameDeck.generateDeck(2)
	var pSpots = get_tree().get_nodes_in_group("pSpot")
	for spot in pSpots:
		print("SPOT: ", spot.c1, spot.c2)
		var c1 = gameDeck.getCard()
		var c2 = gameDeck.getCard()
		activeCards.push_back(c1)
		activeCards.push_back(c2)
		
		spot.c1.add_child(c1)
		spot.c2.add_child(c2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_Timer_timeout():
	for card in activeCards:
		card.flip()
	
	print("TIMER")
	pass # Replace with function body.
