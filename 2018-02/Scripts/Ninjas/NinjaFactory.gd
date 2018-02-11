extends Node


func _ready():

	pass

func GetNinja():
	return get_child(randi() % get_child_count()).duplicate()
