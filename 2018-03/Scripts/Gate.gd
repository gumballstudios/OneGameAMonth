extends Node2D


var direction = 1


func Toggle():
	$Sprite.frame += direction
	$Blocker.position.y += 32 * direction
	direction *= -1

