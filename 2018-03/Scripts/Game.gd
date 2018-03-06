extends Node2D


var score = 0
var playerActive = true
var projectileCounter = 0

var playerScene = preload("res://Objects/Player.tscn")


func _ready():
	pass


func _physics_process(delta):
	if $ScoreCheck/Detector.is_colliding():
		set_physics_process(false)
		playerActive = false
		$Player.queue_free()
		$Timers/Respawn.start()
		score += 1
		print("score ", score)



func MovePlayer(direction):
	if playerActive:
		$Player.Move(direction)


func _on_gate_timeout():
	$Gate.Toggle()


func _on_respawn_timeout():
	var player = playerScene.instance()
	add_child(player)
	playerActive = true
	set_physics_process(true)


func _on_projectile_timeout():
	$ProjectileContainer.Tick(projectileCounter)
	projectileCounter += 1
