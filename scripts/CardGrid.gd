extends CanvasLayer

# Instead of temp sprite I need to get REAL cards
onready var cardFactory = preload("res://scripts/CardFactory.gd")
var cfInstance = null
onready var background = get_node("Background")
onready var cardGrid = get_node("CardGrid")
onready var camera = get_parent().get_node("Camera2D")
onready var cameraTimer = get_parent().get_node("CameraTimer")

func resetGrid():
	# Set the background size to 2x the screen size
	var parent = get_parent()
	var screenSize = parent.rect_size
	background.rect_size = Vector2( parent.rect_size[0] * 2, parent.rect_size[1] * 2)
	var bgSize = background.rect_size
	
	var screenCenter = [screenSize[0] / 2 , screenSize[1] / 2]
	var bgCenter = [bgSize[0] / 2, bgSize[1] / 2]
	
	var xDiff = screenCenter[0] - bgCenter[0]
	var yDiff = screenCenter[1] - bgCenter[1]
	background.rect_position = Vector2(xDiff, yDiff)
	# Generate grid based on rect position
	
	camera.limit_left = xDiff
	camera.limit_top = yDiff
	camera.limit_bottom = yDiff + bgSize[1]
	camera.limit_right =  xDiff + bgSize[0]
	

	
	for child in cardGrid.get_children():
		cardGrid.remove_child(child)
	
	
	generateCardGrid()
	
func generateCardGrid():
	var startPosition = background.rect_position
	var gridRectSize = background.rect_size

	var cellWidth = 200
	var cellHeight = 284
	var cellPadding = 10
	
	var startY = startPosition[1]
	var endY = gridRectSize[1]
	
	var gridHeight = endY - startY
	var gridColumns = floor(gridHeight / cellHeight)

	
	var startX = startPosition[0]
	var endX = gridRectSize[0]
	
	var gridWidth = endX - startX
	var gridRows = floor(gridWidth / cellWidth)

	
	if cfInstance == null:
		cfInstance = cardFactory.new()
	
	
	for y in range(0, gridColumns):
		for x in range(0, gridRows):
			var cellX = startX + (cellWidth/2) +  (x * cellWidth) + (cellPadding * x)
			var cellY = startY + (cellHeight/2) + (y * cellHeight)
			# Create cell at this point
			var sprite = cfInstance.generateRandomCard()
			sprite.spriteScale = 1
			sprite.setFrontModulate("#dddddd")
			sprite.position = Vector2(cellX, cellY)
			cardGrid.add_child(sprite)
		startY += cellPadding
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
var cameraTarget = null
var cameraMoving = false
var rng = RandomNumberGenerator.new()

func pickCameraTarget():
	
	var viewportSize = get_viewport().size
	var viewportWidth = viewportSize.x
	var viewportHeight = viewportSize.y
	
	var minX = background.rect_position[0]
	var maxX = background.rect_position[0] + background.rect_size[0] - viewportWidth
	
	var minY = background.rect_position[1]
	var maxY = background.rect_position[1] + background.rect_size[1] - viewportHeight
	
	var targetX = rng.randi_range(minX, maxX)
	var targetY = rng.randi_range(minY, maxY)
	
	cameraTarget = Vector2(targetX, targetY)
	
	print("TARGET: ", cameraTarget)
	


var lastPos = null
func _process(delta):
	# Maybe we just pick on a timeout	
#	var currentPos = camera.get_camera_screen_center()
#	if lastPos != null:
#		var lastDist = currentPos.distance_to(lastPos)
#		if lastDist <= 0.5:
#			pickCameraTarget()
#			cameraMoving = false
#		lastPos = currentPos
#	else:
#		lastPos = currentPos

	if cameraTarget == null:
		pickCameraTarget()
	if cameraTarget != null and cameraMoving == false:
		camera.position = cameraTarget
		cameraMoving = true

		
		
	

	
	
	
	
	






func _on_MainMenuRoot_resized():
	print("Main menu resized")
	resetGrid()
	pass # Replace with function body.


func _on_CameraTimer_timeout():
	# When timer has ran out, pick a new timer position
	pickCameraTarget()
	cameraMoving = false
	cameraTimer.start(8)
