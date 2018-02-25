extends KinematicBody2D


signal returned
signal power_up
signal attack

const SPEED = 750

var velocity = Vector2()
export(int) var strength = 1


func _ready():
	set_physics_process(false)


func _physics_process(delta):
	velocity.y += 0.1
	if abs(velocity.y) < 0.5:
		velocity.y += 1
	var motion = velocity * delta
	# move the ball and get any remaining motion after a collision
	var collision = move_and_collide(motion)
	
	if collision:
		#set_physics_process(false)
		if collision.collider.is_in_group("Ground"):
			set_physics_process(false)
			emit_signal("returned", self)
			return
		elif collision.collider.is_in_group("Enemy"):
			collision.collider.Hit(strength)
			emit_signal("attack")
		
		velocity = velocity.bounce(collision.normal)


func MoveTo(new_position):
	$Mover.interpolate_property(self, "position", position, new_position, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func PowerUp():
	emit_signal("power_up")
	#strength += 1
	#$Label.text = str(strength)


func _on_screen_exited():
	queue_free()
