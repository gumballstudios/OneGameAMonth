extends Node2D


var controllerOffset = Vector2(80, 0)
var detectorDirection


func _ready():
	detectorDirection = { -1: $Controller/Detectors/Left, 1: $Controller/Detectors/Right }


func Move(direction):
	var detector = detectorDirection[direction]
	if detector.is_colliding():
		return
	
	$Sprite.frame += direction
	$Controller.position += controllerOffset * direction

