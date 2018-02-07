extends Node2D


signal attack_complete

var ninjaIndex = 0
var ninjaReturned = 0
var startPosition
var direction


func _ready():
	startPosition = $NinjaHideout.position
	set_process_input(false)


func RecruitNinja(ninja_roster):
	for ninja in ninja_roster:
		ninja.connect("returned", self, "_on_ninja_returned")
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
		emit_signal("attack_complete")

