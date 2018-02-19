extends CanvasLayer


const SCENE_MENU = "res://Stages/TitleScreen.tscn"
const SCENE_GAME = "res://Stages/Game.tscn"

var is_changing = false


func ChangeScene(scene_path):
	if is_changing:
		return
	
	is_changing = true;
	#get_tree().get_root().set_disable_input(true)
	
	var anim = $Animation
	anim.play("fade_in")
	yield(anim, "animation_finished")
	
	get_tree().change_scene(scene_path)
	
	anim.play("fade_out")
	yield(anim, "animation_finished")
	
	is_changing = false;
	#get_tree().get_root().set_disable_input(false)

