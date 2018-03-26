extends Node2D

enum ModeType { DEMO, GAME, END }

var mode = ModeType.DEMO
var playerActive = false

var projectileCounter = 1

var gateOpen = false
var gateTimerRange = {false: Vector2(1, 4), true: Vector2(1, 3)}

var playerScene = preload("res://Objects/Player.tscn")


func _ready():
	randomize()
	SetupDemo()


func PlaySound(sound):
	if mode == ModeType.GAME:
		var sound_node = $SoundEffects.get_node(sound)
		if sound_node:
			sound_node.play()


func SetupDemo():
	mode = ModeType.DEMO
	$Hud.mode = $Hud.ModeType.TIME
	# set high score
	$Hud.miss = 0
	CreatePlayer()
	SetGateTimer()
	for i in range((randi() % 16) + 5):
		_on_projectile_timeout()
	$Timers/Projectile.start()
	$Timers/Projectile.paused = false
	$Timers/DemoPlayer.start()


func ChangeMode():
	if mode == ModeType.DEMO:
		$Hud.ToggleMode()
	if mode == ModeType.END:
		SetupDemo()


func StartGame():
	if mode == ModeType.GAME:
		return
	
	if $Player:
		$Player.queue_free()
	
	mode = ModeType.GAME
	$Hud.mode = $Hud.ModeType.SCORE
	$Hud.score = 0
	$Hud.miss = 0
	$Timers/DemoPlayer.stop()
	$ProjectileContainer.Reset()
	projectileCounter = 1
	SetGateTimer()
	$Timers/Respawn.start()
	$Timers/Projectile.start()
	$Timers/Projectile.paused = false



func CreatePlayer():
	var player = playerScene.instance()
	if mode == ModeType.GAME:
		player.connect("score", self, "_on_player_score")
		player.connect("hit", self, "_on_player_hit")
	add_child(player)
	playerActive = true


func MovePlayer(direction):
	if mode == ModeType.GAME && playerActive:
		$Player.Move(direction)


func _on_player_score():
	if mode == ModeType.GAME:
		$Hud.score += 1
	
	PlaySound("Score")
	playerActive = false
	$Timers/Projectile.paused = true
	$Timers/Gate.paused = true
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
	$Timers/HitAnimation.start()
	PlaySound("Hit")


func _on_hit_timeout():
	if $EventSprites/HitPositions.frame < 0:
		$Player.queue_free()
	
	if $EventSprites/HitPositions.frame == $EventSprites/HitPositions.get_child_count() - 1:
		$EventSprites/HitPositions.frame = -1
		$EventSprites/BeamSprite.hide()
		
		if mode == ModeType.GAME:
			$Hud.miss += 1
			if $Hud.miss == 3:
				mode = ModeType.END
				return
		
		$Timers/Projectile.paused = false
		$Timers/Gate.paused = false
		$Timers/Respawn.start()
		return
	
	$EventSprites/HitPositions.frame += 1
	$Timers/HitAnimation.start()
	PlaySound("Hit")


func SetGateTimer():
	var timerRange = gateTimerRange[gateOpen]
	$Timers/Gate.wait_time = 1 + rand_range(timerRange.x, timerRange.y)
	$Timers/Gate.start()
	$Timers/Gate.paused = false



func _on_gate_timeout():
	$Gate.Toggle()
	gateOpen = !gateOpen
	SetGateTimer()


func _on_respawn_timeout():
	CreatePlayer()


func _on_projectile_timeout():
	$ProjectileContainer.Tick(projectileCounter)
	PlaySound("Tick")
	projectileCounter += 1


func _on_demo_timeout():
	if playerActive:
		$Player.Move((randi() % 3) - 1)

