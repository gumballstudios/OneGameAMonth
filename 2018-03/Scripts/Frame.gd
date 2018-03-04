extends Node


func _ready():
	pass


func _on_movement_button_down():
	#play sound
	pass # replace with function body


func _on_movement_button_up():
	#play sound
	pass # replace with function body


func _on_left_pressed():
	$Game.MovePlayer(-1)


func _on_right_pressed():
	$Game.MovePlayer(1)
