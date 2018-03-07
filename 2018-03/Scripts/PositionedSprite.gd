extends Node2D


var frame setget SetFrame


func _ready():
	pass


func SetFrame(value):
	ToggleSprite(frame)
	ToggleSprite(value)
	
	frame = value


func ToggleSprite(value):
	if value == null:
		return
	
	if value < 0 || value + 1 > get_child_count():
		return
	
	var sprite = get_child(value)
	sprite.visible = !sprite.visible
