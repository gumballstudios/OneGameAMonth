extends Area2D


var speed = 250
var travel = false


func _ready():
	set_process(true)


func _process(delta):
	if !travel:
		return
	
	var offset = Vector2(speed * delta, 0)
	set_pos(get_pos() - offset)


func _on_visibility_exit_screen():
	queue_free()

