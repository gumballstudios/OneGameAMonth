extends Area2D


var speed = 500


func _process(delta):
	var offset = Vector2(speed * delta, 0)
	set_pos(get_pos() - offset)


func _on_visibility_exit_screen():
	queue_free()

