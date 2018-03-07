extends Node2D


var score = 0
var miss = 0
var playerActive = false
var projectileCounter = 0

var gateOpen = false
var gateTimerRange = {false: Vector2(1, 4), true: Vector2(1, 3)}

var playerScene = preload("res://Objects/Player.tscn")


func _ready():
	randomize()
	CreatePlayer()
	SetGateTimer()


func CreatePlayer():
	var player = playerScene.instance()
	player.connect("score", self, "_on_player_score")
	player.connect("hit", self, "_on_player_hit")
	add_child(player)
	playerActive = true


func MovePlayer(direction):
	if playerActive:
		$Player.Move(direction)


func _on_player_score():
	score += 1
	print("Score: ", score)
	playerActive = false
	$Player.queue_free()
	$Timers/Respawn.start()


func _on_player_hit():
	miss += 1
	print("Miss: ", miss)
	playerActive = false
	$Player.queue_free()
	
	if miss == 3:
		print("Game Over")
		$Timers/Projectile.stop()
		$Timers/Gate.stop()
		return
	
	$Timers/Respawn.start()


func SetGateTimer():
	var timerRange = gateTimerRange[gateOpen]
	$Timers/Gate.wait_time = 1 + rand_range(timerRange.x, timerRange.y)
	$Timers/Gate.start()


func _on_gate_timeout():
	$Gate.Toggle()
	gateOpen = !gateOpen
	SetGateTimer()


func _on_respawn_timeout():
	CreatePlayer()


func _on_projectile_timeout():
	$ProjectileContainer.Tick(projectileCounter)
	projectileCounter += 1
