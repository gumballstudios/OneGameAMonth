extends Node




func _ready():
	RunRound()

func RunRound():
	$Grid.ProcessRound()
	$MoveTimer.start()


func _on_move_timeout():
	$Ball.set_process_input(true)


func _on_ball_grounded():
	$Grid.ProcessRound()
	$MoveTimer.start()

