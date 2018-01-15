extends Area2D


signal clicked
signal destroyed

var type setget set_type
var active = true

func _ready():
	for ray in get_node("Neighbors").get_children():
		ray.add_exception(self)


func _input(viewport, event, shape_idx):
	if !active:
		return
	
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
			if neighbor.is_in_group(type) && neighbor.active:
				matches.append(neighbor)
	return matches

func move(to_pos):
	var tween = get_node("MoveAnimation")
	tween.interpolate_property(self, "transform/pos", get_pos(), to_pos, 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func escape():
	active = false
	get_node("MoveAnimation").stop_all()
	var tween = get_node("EscapeAnimation")
	tween.interpolate_property(self, "transform/pos", get_pos(), get_pos() - Vector2(960, 0), 0.6, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	get_node("ParticleTimer").start()


func _on_particle_timer_timeout():
	get_node("ParticleTrail").set_emitting(true)


func _on_escape_tween_complete( object, key ):
	get_node("ParticleTrail").set_emitting(false)
	get_node("LifeTimer").start()


func _on_life_timeout():
	queue_free()
