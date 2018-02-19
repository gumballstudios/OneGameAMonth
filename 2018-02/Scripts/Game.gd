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


func _on_attack_complete():
	$EnemyFormation.ProcessRound()
	$MoveTimer.start()


func _on_zone_entered(area):
	print("game over")
	gameOver = true
