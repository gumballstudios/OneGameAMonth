extends PathFollow2D


signal target_hit

var speed = 250


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _process(delta):
	offset += speed * delta
	if unit_offset >= 1:
		queue_free()


func _on_shot():
	print("hit")
	var pos = $Body.get_local_mouse_position() - $Body/Target.position
	
	if pos.length() <= 20:
		emit_signal("target_hit")
	
	queue_free()

