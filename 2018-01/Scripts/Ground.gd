extends Node2D


onready var container = get_node("Container")

var segment_scene = preload("res://Objects/GroundSection.tscn")


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_spawner_area_enter(area):
	var offset = Vector2(18 * 64, 0)
	var new_ground = segment_scene.instance()
	new_ground.set_pos(area.get_pos() - offset)
	container.add_child(new_ground)

func stop():
	for segment in container.get_children():
		segment.set_process(false)