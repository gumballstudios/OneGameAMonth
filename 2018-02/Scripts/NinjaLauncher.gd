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
var hint_index = 1

var factoryScene = preload("res://Objects/Ninjas/NinjaFactory.tscn")


func _ready():
	factory = factoryScene.instance()
	startPosition = $NinjaHideout.position
	FadeHints(null, $Hud/Hint1)


func FadeHints(outNode, inNode):
	if outNode:
		print("fade out: ", outNode)
		$Hud/Fader.interpolate_property(outNode, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if inNode:
		print("fade in: ", inNode)
		$Hud/Fader.interpolate_property(inNode, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Hud/Fader.start()


func RecruitNinja(ninja_roster):
	for ninja in ninja_roster:
		ninja.connect("returned", self, "_on_ninja_returned")
		ninja.connect("power_up", self, "_on_power_up")
		ninja.connect("attack", self, "_on_ninja_attack")
		$NinjaHideout.add_child(ninja)


func _process(delta):
	if !(ready && aiming):
		return
	
	if hint_index == 4:
		FadeHints($Hud/Hint3, null)
		hint_index += 1
	
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
		if hint_index == 1:
			FadeHints($Hud/Hint1, $Hud/Hint2)
			hint_index += 1
	elif event.is_action_released("fire"):
		if !(ready && aiming):
			return
		
		if hint_index == 2:
			FadeHints($Hud/Hint2, null)
			hint_index += 1
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
		if hint_index == 3:
			FadeHints(null, $Hud/Hint3)
			hint_index += 1
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
