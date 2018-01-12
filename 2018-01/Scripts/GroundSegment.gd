extends Node2D


var speed = 50


func _ready():
	randomize()
	randomize_sprites()
	set_process(true)


func _process(delta):
	var offset = Vector2(speed * delta, 0)
	set_pos(get_pos() + offset)


func _on_visibility_exit_screen():
	queue_free()


func randomize_sprites():
	for sprite in get_node("Containter").get_children():
		var frame = randi() % sprite.get_sprite_frames().get_frame_count("default")
		sprite.set_frame(frame)