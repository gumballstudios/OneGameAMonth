const STAGE_GAME = "res://stages/Stack.tscn"
const STAGE_MENU = "res://stages/TitleScreen.tscn"

var is_changing = false


func change_stage(stage_path):
	if is_changing:
		return
	
	is_changing = true
	get_tree().get_root().set_disable_input(true)
	
	var anim = get_node("Animation")
	anim.play("fade_in")
	yield(anim, "finished")
	
	get_tree().change_scene(stage_path)
	
	anim.play("fade_out")
	yield(anim, "finished")
	
	is_changing = false
	get_tree().get_root().set_disable_input(false)