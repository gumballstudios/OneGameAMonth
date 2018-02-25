extends Node


var gameOver = false

var factoryScene = preload("res://Objects/Ninjas/NinjaFactory.tscn")


func _ready():
	$MoveTimer.connect("timeout", self, "_on_move_timeout")

	var factory = factoryScene.instance()
	$NinjaLauncher.RecruitNinja([ factory.GetNinja() ])
	$NinjaLauncher.ready = true

	$EnemyFormation.ProcessRound()
	$MoveTimer.start()


func _on_move_timeout():
	if !gameOver:
		$NinjaLauncher.ready = true
	else:
		$GameOver.show()
		if $EnemyFormation.deployRound > Settings.high_score:
			Settings.high_score = $EnemyFormation.deployRound
			$GameOver/HighScore.show()
			$GameOver/HighScore/Animation.interpolate_property($GameOver/HighScore, "scale", Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			$GameOver/HighScore/Animation.start()
			$GameOver/HighScore/SoundEffect.play()


func _on_attack_complete():
	$EnemyFormation.ProcessRound()
	$MoveTimer.start()


func _on_zone_entered(area):
	gameOver = true


func _on_retry_pressed():
	$GameOver/ClickSound.play()
	SceneSwitch.ChangeScene(SceneSwitch.SCENE_GAME)


func _on_menu_pressed():
	$GameOver/ClickSound.play()
	SceneSwitch.ChangeScene(SceneSwitch.SCENE_MENU)


func _on_mouse_entered(hint):
	$GameOver/Action.text = hint


func _on_mouse_exited():
	$GameOver/Action.text = ""
