extends Node2D


var frame = 0 setget SetFrame


func _ready():
	pass


func SetFrame(value):
	if value < 0 || value + 1 > get_child_count():
		return
	
	var currentSprite = get_child(frame)
	currentSprite.hide()
	
	var nextSprite = get_child(value)
	nextSprite.show()
	
	frame = value