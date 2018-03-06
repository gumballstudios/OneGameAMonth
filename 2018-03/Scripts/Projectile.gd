extends Node2D


var direction = 1


func _ready():
	$Sprite.frame = -1


func Tick():
	print("*** projectile ", get_index())
	print("cur frame: ", $Sprite.frame)
	$Sprite.frame += direction
	print("new frame: ", $Sprite.frame)
	
	if $Sprite.frame < 0 || $Sprite.frame + 1 >= $Sprite.get_child_count():
		direction *= -1


