extends Area2D


signal clicked

var block_types = [
	"Red",
	"Green",
	"Blue",
	"Yellow",
]

var type setget set_type
var active = true


func _ready():
	randomize()
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


func move(to_pos, speed, transition = Tween.TRANS_QUAD):
	var tween = get_node("MoveAnimation")
	tween.interpolate_property(self, "transform/pos", get_pos(), to_pos, speed, transition, Tween.EASE_IN_OUT)
	tween.start()


func escape(speed):
	active = false
	get_node("MoveAnimation").stop_all()
	var tween = get_node("EscapeAnimation")
	tween.interpolate_property(self, "transform/pos", get_pos(), get_pos() - Vector2(960, 0), speed, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	get_node("ParticleTimer").start()


func _on_particle_timer_timeout():
	get_node("ParticleTrail").set_emitting(true)


func _on_escape_tween_complete( object, key ):
	get_node("ParticleTrail").set_emitting(false)
	var timer = get_node("LifeTimer")
	timer.set_wait_time(0.75)
	timer.start()


func _on_life_timeout():
	queue_free()


func _on_area_enter(area):
	if !area.is_in_group("Sharks"):
		return
	
	var anim = get_node("Animation")
	anim.set_animation(type + "Bones")
	active = false
	
	var death_time = 0
	var tween = get_node("DieAnimation")
	tween.interpolate_property(self, "transform/pos", get_pos(), get_pos() + Vector2(64, 8), death_time + rand_range(1, 3), Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "transform/rot", get_rot(), get_rot() + rand_range(-60, 60), death_time + rand_range(1, 3), Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "visibility/opacity", 1, 0, death_time + rand_range(1, 3), Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	
	var timer = get_node("LifeTimer")
	timer.set_wait_time(4)
	timer.start()

