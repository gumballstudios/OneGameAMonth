extends Panel


var confirm_redirect


func _input(event):
	if event.is_action_pressed("pause_toggle"):
		SetPause(!get_tree().paused)
		


func SetPause(toggle):
	visible = toggle
	get_tree().paused = toggle


func _on_mouse_entered(hint):
	$Buttons/Action.text = hint


func _on_mouse_exited():
	$Buttons/Action.text = ""


func _on_resume_pressed():
	SetPause(false)


func _on_restart_pressed():
	confirm_redirect = SceneSwitch.SCENE_GAME
	$ConfirmationDialog/Title.text = "restart game?"
	$ConfirmationDialog.show()


func _on_menu_pressed():
	confirm_redirect = SceneSwitch.SCENE_MENU
	$ConfirmationDialog/Title.text = "quit to menu?"
	$ConfirmationDialog.show()


func _on_ok_pressed():
	SetPause(false)
	$ConfirmationDialog.hide()
	SceneSwitch.ChangeScene(confirm_redirect)


func _on_cancel_pressed():
	$ConfirmationDialog.hide()
