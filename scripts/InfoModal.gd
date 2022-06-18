extends Control

onready var animationPlayer = get_node("ModalAnimator")
onready var modalTimer = get_node("ModalTimer")
onready var label = get_node("InfoLabel")



var modalState = "hidden"
# Number of seconds to display modal 
var modalHangTime = 1


func animationFinished():
	pass

# Play animation in
func animateIn():
	animationPlayer.play("ModalShow")
	modalState = "animateIn"
	
# Play ease in animation backwards 
func animateOut():
	animationPlayer.play_backwards("ModalShow")
	modalState = "animateOut"

	
# Toggle when close button pressed, hide modal instantly
func close():
	# Not sure best way? Just set anchors to hide
	anchor_top = -0.1
	anchor_bottom = -0.4
	
func setLabel(labelValue):
	label.text = labelValue
	
func modalAnimation_finished(anim_name):
	# If we are animating in, when the animation is finished we are showing the modal
	if(modalState == "animateIn"):
		modalState = "showing"
	else:
		# Else we have hidden the modal
		modalState = "hidden"
		
	# If we are now showing the modal, start a timer and then hide the modal
	if(modalState == "showing"):
		modalTimer.start(modalHangTime)


func modalTimer_finished():
	# Timer has finished, if modal is showing, hide the modal
	if(modalState == "showing"):
		animateOut()
	



func closeButton_pressed():
	# Stop any current animations, then hide the modal
	if(modalState == "animateIn" or modalState == "animateOut"):
		animationPlayer.stop()
		close()
	if(modalState == "showing"):
		# If modal state is showing, the hide timer is probably running
		modalTimer.stop()
		close()
	modalState = "hidden"


