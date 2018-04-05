extends Node

var angle = 0
var shots = 3
var start_x

func _ready():
	start_x = $Duck.position.x


func _input(event):
	if event.is_action_pressed("shoot"):
		if shots == 0:
			get_tree().set_input_as_handled()
			return
		
		shots -= 1
		$Label.text = str(shots)
	
	if event.is_action_pressed("reload"):
		print("reload")
		if shots == 3:
			return
		
		shots += 1
		$Label.text = str(shots)



func _process(delta):
	angle = fmod(angle + 90 * delta, 360.0)
	$Duck.position.x = start_x + sin(deg2rad(angle)) * 100
