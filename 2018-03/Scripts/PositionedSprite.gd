extends Node2D


var frame setget SetFrame


func _ready():
	pass


func SetFrame(value):
	print("- set frame ", frame, " -> ", value)
	ToggleSprite(frame)
	ToggleSprite(value)
	
	frame = value


func ToggleSprite(value):
	if value == null:
		print("no value")
		return
	
	if value < 0 || value + 1 > get_child_count():
		print("ranged ", value)
		return
	
	var sprite = get_child(value)
	print(value, " visibile ", sprite.visible)
	sprite.visible = !sprite.visible
