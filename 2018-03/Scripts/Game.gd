extends Node2D


var score = 0
var active = true

var playerScene = preload("res://Objects/Player.tscn")


func _ready():
	pass


func _physics_process(delta):
	if $ScoreCheck/Detector.is_colliding():
		set_physics_process(false)
		active = false
		$Player.queue_free()
		$Timers/Respawn.start()
		score += 1
		print("score ", score)



func MovePlayer(direction):
	if active:
		$Player.Move(direction)


func _on_gate_timeout():
	$Gate.Toggle()


func _on_respawn_timeout():
	var player = playerScene.instance()
	player.position = Vector2(240, 330)
	add_child(player)
	active = true
	set_physics_process(true)
