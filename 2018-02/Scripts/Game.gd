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
		$GameOver/SoundEffect.play()
		$GameOver/Shade/Animation.interpolate_property($GameOver/Shade, "modulate", Color(0, 0, 0, 0), Color(0, 0, 0, 0.75), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$GameOver/Shade/Animation.start()
		$GameOver.show()


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


func _on_shade_tween_completed( object, key ):
	$GameOver/Game/Animation.interpolate_property($GameOver/Game, "rect_position", Vector2(-329, 100), Vector2(0, 100), 0.4, Tween.TRANS_BACK, Tween.EASE_OUT, 0.2)
	$GameOver/Game/Animation.start()
	$GameOver/Over/Animation.interpolate_property($GameOver/Over, "rect_position", Vector2(329, 100), Vector2(0, 100), 0.4, Tween.TRANS_BACK, Tween.EASE_OUT, 0.4)
	$GameOver/Over/Animation.start()


func _on_over_tween_completed( object, key ):
	$GameOver/Buttons.show()
	if $EnemyFormation.deployRound > Settings.high_score:
		Settings.high_score = $EnemyFormation.deployRound
		$GameOver/HighScore/Timer.start()


func _on_high_score_timeout():
	$GameOver/HighScore.show()
	$GameOver/HighScore/Animation.interpolate_property($GameOver/HighScore, "scale", Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$GameOver/HighScore/Animation.start()
	$GameOver/HighScore/SoundEffect.play()
