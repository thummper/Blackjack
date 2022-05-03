extends Control

onready var tempSprite = preload("res://scenes/TestSprite.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Pad grid offscreen?
	var gridPadding = [500, 500]
	# Some storage for current offset - will eventually be camera vars for scrolling
	var offset = [0, 0]
	var startPosition = rect_position
	# Not sure why I only get rect size if the parent is a canvas layer
	var screenSize = rect_size
	
	var cellWidth = 100
	var cellHeight = 142
	var cellPadding = 10
	
	
	var startY = floor(startPosition[1] - gridPadding[1])
	var endY = floor(startPosition[1] + gridPadding[1] + screenSize[1])
	
	var gridHeight = endY - startY
	var gridColumns = floor(gridHeight / cellHeight)

	
	var startX = floor(startPosition[0] - gridPadding[0])
	var endX = floor(startPosition[0] + screenSize[0] + gridPadding[1])
	
	var gridWidth = endX - startX
	var gridRows = floor(gridWidth / cellWidth)
	

	
	
	for y in range(0, gridColumns):
		for x in range(0, gridRows):
			var cellX = startX + (cellWidth/2) +  (x * cellWidth) + (cellPadding * x)
			var cellY = startY + (cellHeight/2) + (y * cellHeight)
			# Create cell at this point
			var sprite = tempSprite.instance()
			sprite.position = Vector2(cellX, cellY)
			add_child(sprite)
		startY += cellPadding
			
	



