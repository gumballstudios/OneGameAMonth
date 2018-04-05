extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

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
		print(" - target")
	else:
		print(" - body")
