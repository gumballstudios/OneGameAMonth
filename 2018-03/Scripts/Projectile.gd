extends Node2D


signal finished

var direction = 1
var controllerOffset = Vector2(0, 16)
var controllerOrigin


func _ready():
	$Sprite.frame = -1
	controllerOrigin = $Controller.position


func Reset():
	$Sprite.frame = -1
	direction = 1
	$Controller.position = controllerOrigin


func Tick():
	$Sprite.frame += direction
	$Controller.position += controllerOffset * direction
	
	if $Sprite.frame < 0 || $Sprite.frame + 1 >= $Sprite.get_child_count():
		direction *= -1
		
		if $Sprite.frame < 0:
			emit_signal("finished")

