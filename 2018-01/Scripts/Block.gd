extends Area2D


signal clicked
signal destroyed

var type setget set_type


func _ready():
	for ray in get_node("Neighbors").get_children():
		ray.add_exception(self)


func _input(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		emit_signal("clicked", self)


func set_type(value):
	type = value
	
	for group in get_groups():
		remove_from_group(group)
	
	add_to_group(value)
	
	var anim = get_node("Animation")
	anim.set_animation(value)
	var frame = randi() % anim.get_sprite_frames().get_frame_count(value)
	anim.set_frame(frame)
	anim.play()


func get_neighbor_matches():
	var matches = []
	for ray in get_node("Neighbors").get_children():
		if ray.is_colliding():
			var neighbor = ray.get_collider()
			if neighbor.is_in_group(type):
				matches.append(neighbor)
	return matches

