extends PathFollow2D


signal target_hit

var speed = 250
var direction = 1


func _ready():
	randomize()
	var index = randi() % $Body.get_child_count()
	var body = $Body.get_child(index)
	body.show()
	
	unit_offset = index
	direction = direction - 2 * index
	pass


func _process(delta):
	offset += speed * delta * direction
	if unit_offset < 0 or unit_offset > 1:
		queue_free()


func _on_shot(facing):
	print("hit ", facing)
	var body = $Body.get_node(facing)
	var pos = body.get_local_mouse_position() - body.get_node("Target").position
	
	if pos.length() <= 20:
		emit_signal("target_hit")
	
	queue_free()

