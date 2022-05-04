extends Control
# Mainly main menu button events here


func _on_Quit_pressed():
	get_tree().quit()



func _on_Play_pressed():
	get_tree().change_scene("res://Main.tscn")
	pass # Replace with function body.
