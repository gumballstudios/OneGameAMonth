extends Node2D


var speed = 250


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _process(delta):
	position.x += speed * delta
	pass


func _on_screen_exited():
	queue_free()