extends KinematicBody2D


signal returned

const SPEED = 2500

var velocity = Vector2()
var strength = 1


func _ready():
	set_physics_process(false)


func _physics_process(delta):
	var motion = velocity * delta
	# move the ball and get any remaining motion after a collision
	var collision = move_and_collide(motion)
	
	if collision:
		set_physics_process(false)
		if collision.collider.is_in_group("Ground"):
			emit_signal("returned", self)
			return
		elif collision.collider.is_in_group("Enemy"):
			collision.collider.Hit(strength)
		
		velocity = velocity.bounce(collision.normal)
		$AttackTimer.start()


func _on_attack_timeout():
	set_physics_process(true)


func MoveTo(new_position):
	$Mover.interpolate_property(self, "position", position, new_position, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func PowerUp():
	strength += 1
	$Label.text = str(strength)
