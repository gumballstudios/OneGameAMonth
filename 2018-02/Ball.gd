extends KinematicBody2D


signal grounded

const SPEED = 2500

var velocity = Vector2()


func _ready():
	set_process_input(false)
	set_physics_process(false)


func _input(event):
	if event.is_action("fire") && event.is_pressed():
		var a = global_position
		var b = get_global_mouse_position()
		var direction = b - a
		velocity = direction.normalized() * SPEED
		set_process_input(false)
		set_physics_process(true)


func _physics_process(delta):
	var motion = velocity * delta
	# move the ball and get any remaining motion after a collision
	var collision = move_and_collide(motion)
	
	if collision:
		set_physics_process(false)
		if collision.collider.is_in_group("Ground"):
			set_process_input(true)
			emit_signal("grounded")
			return
		elif collision.collider.is_in_group("Block"):
			collision.collider.queue_free()
		
		velocity = velocity.bounce(collision.normal)
		$AttackTimer.start()



func _on_attack_timeout():
	set_physics_process(true)
