extends CanvasLayer


const SCENE_MENU = "res://Stages/TitleScreen.tscn"
const SCENE_GAME = "res://Stages/Stack.tscn"

var is_changing = false

func _ready():
	pass


func change_scene(scene_path):
	if is_changing:
		return
	
	is_changing = true;
	get_tree().get_root().set_disable_input(true)
	
	var anim = get_node("Animation")
	anim.play("fade_in")
	yield(anim, "finished")
	
	get_tree().change_scene(scene_path)
	
	anim.play("fade_out")
	yield(anim, "finished")
	
	is_changing = false;
	get_tree().get_root().set_disable_input(false)

