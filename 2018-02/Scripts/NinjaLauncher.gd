extends Node2D


signal attack_complete

var ninjaIndex = 0
var ninjaReturned = 0
var startPosition
var direction
var recruitCount = 0
var factory

var factoryScene = preload("res://Objects/Ninjas/NinjaFactory.tscn")


func _ready():
	factory = factoryScene.instance()
	startPosition = $NinjaHideout.position
	set_process_input(false)


func RecruitNinja(ninja_roster):
	for ninja in ninja_roster:
		ninja.connect("returned", self, "_on_ninja_returned")
		ninja.connect("power_up", self, "_on_power_up")
		$NinjaHideout.add_child(ninja)


func _input(event):
	if event.is_action("fire") && event.is_pressed():
		var a = startPosition
		var b = get_local_mouse_position()
		direction = (b - a).normalized()
		set_process_input(false)
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
				ninjaRecruit.position = startPosition
				$NinjaHideout.add_child(ninjaRecruit)
				$Hud/Label.text = str($NinjaHideout.get_child_count())
			recruitCount = 0
		emit_signal("attack_complete")


func _on_power_up():
	recruitCount += 1