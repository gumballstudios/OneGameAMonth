extends Node


var gameOver = false

var factoryScene = preload("res://Objects/Ninjas/NinjaFactory.tscn")


func _ready():
	$MoveTimer.connect("timeout", self, "_on_move_timeout")

	var factory = factoryScene.instance()
	$NinjaLauncher.RecruitNinja([ factory.GetNinja() ])
	$NinjaLauncher.set_process_input(true)

	$EnemyFormation.ProcessRound()
	$MoveTimer.start()


func _on_move_timeout():
	if !gameOver:
		$NinjaLauncher.set_process_input(true)
	else:
		$GameOver.show()


func _on_attack_complete():
	$EnemyFormation.ProcessRound()
	$MoveTimer.start()


func _on_zone_entered(area):
	gameOver = true


func _on_retry_mouse_entered():
	$GameOver/Action.text = "retry"


func _on_retry_mouse_exited():
	$GameOver/Action.text = ""


func _on_menu_mouse_entered():
	$GameOver/Action.text = "menu"


func _on_menu_mouse_exited():
	$GameOver/Action.text = ""


func _on_retry_pressed():
	$GameOver/ClickSound.play()
	SceneSwitch.ChangeScene(SceneSwitch.SCENE_GAME)


func _on_menu_pressed():
	$GameOver/ClickSound.play()
	SceneSwitch.ChangeScene(SceneSwitch.SCENE_MENU)
