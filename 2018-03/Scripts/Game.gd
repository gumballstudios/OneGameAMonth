extends Node2D


var miss = 0

var playerActive = false

var projectileCounter = 1

var gateOpen = false
var gateTimerRange = {false: Vector2(1, 4), true: Vector2(1, 3)}

var playerScene = preload("res://Objects/Player.tscn")


func _ready():
	randomize()
	$Hud.mode = $Hud.ModeType.SCORE
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
	$Hud.score += 1
	playerActive = false
	$Timers/Projectile.paused = true
	$Timers/Gate.paused = true
	$SoundEffects/Score.play()
	$Timers/ScoreAnimation.start()


func _on_score_timeout():
	$Player.queue_free()
	$Timers/Projectile.paused = false
	$Timers/Gate.paused = false
	$Timers/Respawn.start()



func _on_player_hit(position):
	playerActive = false
	$Timers/Projectile.paused = true
	$Timers/Gate.paused = true
	$EventSprites/HitPositions.frame = -1
	$EventSprites/BeamSprite.show()
	$SoundEffects/Hit.play()
	$Timers/HitAnimation.start()


func _on_hit_timeout():
	if $EventSprites/HitPositions.frame < 0:
		$Player.queue_free()
	
	if $EventSprites/HitPositions.frame == $EventSprites/HitPositions.get_child_count() - 1:
		$EventSprites/HitPositions.frame = -1
		$EventSprites/BeamSprite.hide()
		
		$Hud.miss += 1
		if $Hud.miss == 3:
			print("Game Over")
			return
		
		$Timers/Projectile.paused = false
		$Timers/Gate.paused = false
		$Timers/Respawn.start()
		return
	
	$EventSprites/HitPositions.frame += 1
	$SoundEffects/Hit.play()
	$Timers/HitAnimation.start()


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

