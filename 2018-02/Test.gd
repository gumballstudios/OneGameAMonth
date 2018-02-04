extends Node


func _ready():
	for i in range(3):
		$Grid.ProcessRound()
		$MoveTimer.start()
		yield($MoveTimer, "timeout")
	
	$Launcher.set_process_input(true)
	$MoveTimer.connect("timeout", self, "_on_move_timeout")


func _on_move_timeout():
	$Launcher.set_process_input(true)


func _on_attack_complete():
	$Grid.ProcessRound()
	$MoveTimer.start()
