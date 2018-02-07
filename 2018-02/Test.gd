extends Node

var ninjaScene = preload("res://Objects/Ninja.tscn")

func _ready():
	for i in range(3):
		$EnemyFormation.ProcessRound()
		$MoveTimer.start()
		yield($MoveTimer, "timeout")
	
	$NinjaLauncher.RecruitNinja([ ninjaScene.instance() ])
	$NinjaLauncher.set_process_input(true)
	$MoveTimer.connect("timeout", self, "_on_move_timeout")


func _on_move_timeout():
	$NinjaLauncher.set_process_input(true)


func _on_attack_complete():
	$EnemyFormation.ProcessRound()
	$MoveTimer.start()
