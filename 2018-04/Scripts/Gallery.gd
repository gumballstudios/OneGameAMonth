extends Node

var angle = 0

var duckScene = preload("res://Objects/Duck.tscn")


func _ready():
	randomize()
	SendDuck()


func _input(event):
	if event.is_action_pressed("shoot"):
		if $Hud.shots == 0:
			get_tree().set_input_as_handled()
			return
		
		$Hud.shots -= 1
	
	if event.is_action_pressed("reload"):
		print("reload")
		if $Hud.shots == 3:
			return
		
		$Hud.shots += 1


func SendDuck():
	var duck = duckScene.instance()
	duck.connect("target_hit", self, "_on_target_hit")
	
	var index = randi() % $Sections.get_child_count()
	var section = $Sections.get_child(index)
	section.AddDuck(duck)


func _on_target_hit():
	print("score")


#func _process(delta):
#	angle = fmod(angle + 90 * delta, 360.0)
#	$Duck.position.x = start_x + sin(deg2rad(angle)) * 100


func _on_Timer_timeout():
	SendDuck()
	pass
