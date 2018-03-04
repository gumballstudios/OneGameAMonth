extends Node2D


var direction = 1


func Toggle():
	$Sprite.frame += direction
	$Blocker.position.y = 32 * $Sprite.frame
	direction *= -1

