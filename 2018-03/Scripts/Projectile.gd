extends Node2D


signal finished

var direction = 1
var controllerOffset = Vector2(0, 16)

func _ready():
	$Sprite.frame = -1


func Tick():
	$Sprite.frame += direction
	$Controller.position += controllerOffset * direction
	$SoundEffects/Tick.play()
	
	if $Sprite.frame < 0 || $Sprite.frame + 1 >= $Sprite.get_child_count():
		direction *= -1
		
		if $Sprite.frame < 0:
			emit_signal("finished")

