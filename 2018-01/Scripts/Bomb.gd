extends Area2D


signal clicked

var active = true


func _ready():
	randomize()
	for ray in get_node("Neighbors").get_children():
		ray.add_exception(self)

	var anim = get_node("Animation")
	var frame = randi() % anim.get_sprite_frames().get_frame_count("default")
	anim.set_frame(frame)
	anim.play()


func _input( viewport, event, shape_idx ):
	if !active:
		return
	
	if event.is_action_pressed("left_click"):
		emit_signal("clicked", self)


func get_neighbor_matches():
	var matches = []
	for ray in get_node("Neighbors").get_children():
		if ray.is_colliding():
			var neighbor = ray.get_collider()
			if neighbor.active:
				matches.append(neighbor)
	return matches


func move(to_pos, speed):
	var tween = get_node("MoveAnimation")
	tween.interpolate_property(self, "transform/pos", get_pos(), to_pos, speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()


func escape(speed):
	active = false
	get_node("MoveAnimation").stop_all()
	var target = get_node("Animation")
	var tween = get_node("EscapeAnimation")
	tween.interpolate_property(target, "transform/scale", Vector2(1, 1), Vector2(1.5, 1.5), speed / 2, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween.interpolate_property(target, "visibility/opacity", 1, 0, speed / 2, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()
	get_node("ParticleExplosion").set_emitting(true)


func _on_area_enter(area):
	if !area.is_in_group("Sharks"):
		return
	
	escape(0.4)


func _on_escape_tween_complete( object, key ):
	var timer = get_node("LifeTimer")
	timer.set_wait_time(0.75)
	timer.start()


func _on_life_timeout():
	queue_free()

