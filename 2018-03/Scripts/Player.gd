extends Node2D


signal score
signal hit

var controllerOffset = Vector2(64, 0)
var detectorDirection


func _ready():
	detectorDirection = { -1: $Controller/Detectors/Left, 1: $Controller/Detectors/Right }
	$Sprite.frame = 0


func _physics_process(delta):
	if $Controller/Detectors/Top.is_colliding():
		set_physics_process(false)
		var collider = $Controller/Detectors/Top.get_collider()
		if collider.is_in_group("Exit"):
			emit_signal("score")
		if collider.is_in_group("Projectile"):
			emit_signal("hit", $Sprite.frame)


func Move(direction):
	if abs(direction) != 1:
		return
	
	var detector = detectorDirection[direction]
	if detector.is_colliding():
		return
	
	$Sprite.frame += direction
	$Controller.position += controllerOffset * direction

