extends Node2D


signal attack_complete

var ninjaIndex = 0
var ninjaReturned = 0
var startPosition
var direction
var recruitCount = 0
var factory
var soundBuffer = true
var aiming = false
var ready = false

var factoryScene = preload("res://Objects/Ninjas/NinjaFactory.tscn")


func _ready():
	factory = factoryScene.instance()
	startPosition = $NinjaHideout.position


func RecruitNinja(ninja_roster):
	for ninja in ninja_roster:
		ninja.connect("returned", self, "_on_ninja_returned")
		ninja.connect("power_up", self, "_on_power_up")
		ninja.connect("attack", self, "_on_ninja_attack")
		$NinjaHideout.add_child(ninja)


func _process(delta):
	if !(ready && aiming):
		return
	
	var b = get_local_mouse_position()
	$AimLine.position = b
	$AimLine.show()
	var a = startPosition
	var dir = (a - b)
	$AimLine.region_rect.size = Vector2(round(dir.length()) + 16, 16)
	$AimLine.rotation = dir.angle()


func _input(event):
	if event.is_action_pressed("fire"):
		aiming = true
	elif event.is_action_released("fire"):
		if !(ready && aiming):
			return
		
		ready = false
		aiming = false
		var a = startPosition
		var b = get_local_mouse_position()
		direction = (b - a).normalized()
		$AimLine.hide()
		ninjaIndex = 0
		ninjaReturned = 0
		NinjaStrike()


func NinjaStrike():
	if ninjaIndex < $NinjaHideout.get_child_count():
		var ninja = $NinjaHideout.get_child(ninjaIndex)
		ninja.velocity = direction * ninja.SPEED
		ninja.set_physics_process(true)
		$LaunchTimer.start()


func _on_launch_timeout():
	ninjaIndex += 1
	NinjaStrike()


func _on_ninja_returned(ninja):
	if ninjaReturned == 0:
		startPosition = ninja.position
	else:
		ninja.MoveTo(startPosition)
	
	ninjaReturned += 1
	if ninjaReturned == $NinjaHideout.get_child_count():
		if recruitCount > 0:
			for i in range(recruitCount):
				var ninjaRecruit = factory.GetNinja()
				ninjaRecruit.connect("returned", self, "_on_ninja_returned")
				ninjaRecruit.connect("power_up", self, "_on_power_up")
				ninjaRecruit.connect("attack", self, "_on_ninja_attack")
				ninjaRecruit.position = startPosition
				$NinjaHideout.add_child(ninjaRecruit)
				$Hud/Label.text = str($NinjaHideout.get_child_count())
			recruitCount = 0
		emit_signal("attack_complete")


func _on_power_up():
	recruitCount += 1


func _on_ninja_attack():
	if !soundBuffer:
		return
	
	var i = 0
	while i < $SoundEffects.get_child_count():
		var sound = $SoundEffects.get_child(i)
		if !sound.playing:
			sound.play()
			soundBuffer = false
			$SoundTimer.start()
			return
		i += 1


func _on_sound_timeout():
	soundBuffer = true
