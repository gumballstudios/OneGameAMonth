extends Node


signal attack_complete

var ball_index = 0
var caught = 0
var start_position = Vector2(180, 632)
var direction


func _ready():
	set_process_input(false)


func _input(event):
	if event.is_action("fire") && event.is_pressed():
		var a = start_position
		var b = get_global_mouse_position()
		direction = (b - a).normalized()
		set_process_input(false)
		ball_index = 0
		caught = 0
		LaunchBall()


func LaunchBall():
	if ball_index < $BallContainer.get_child_count():
		var ball = $BallContainer.get_child(ball_index)
		ball.velocity = direction * ball.SPEED
		ball.set_physics_process(true)
		$LaunchTimer.start()


func _on_launch_timeout():
	ball_index += 1
	LaunchBall()


func _on_ball_grounded(ball):
	if caught == 0:
		start_position = ball.position
	caught += 1
	if caught == $BallContainer.get_child_count():
		emit_signal("attack_complete")
		MoveBalls()


func MoveBalls():
	for ball in $BallContainer.get_children():
		ball.MoveTo(start_position)
