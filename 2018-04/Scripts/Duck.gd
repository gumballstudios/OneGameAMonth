extends Node2D


signal target_hit


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_shot():
	print("hit")
	var pos = $Body.get_local_mouse_position() - $Body/Target.position
	
	if pos.length() <= 20:
		emit_signal("target_hit")
	
	queue_free()

