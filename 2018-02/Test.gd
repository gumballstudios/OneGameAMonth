extends Node

var ninjaScene = preload("res://Objects/Ninja.tscn")


func _ready():
	$MoveTimer.connect("timeout", self, "_on_move_timeout")
	
	$NinjaLauncher.RecruitNinja([ ninjaScene.instance() ])
	$NinjaLauncher.set_process_input(true)
	
	$EnemyFormation.ProcessRound()
	$MoveTimer.start()


func _on_move_timeout():
	$NinjaLauncher.set_process_input(true)


func _on_attack_complete():
	$EnemyFormation.ProcessRound()
	$MoveTimer.start()
