extends Node


func _ready():
	get_node("GroundSection").set_process(false)
	
	var title_anim = get_node("Tween")
	var title = get_node("Title")
	title_anim.interpolate_property(title, "rect/pos", title.get_pos(), Vector2(64, 128), 3, Tween.TRANS_SINE, Tween.EASE_OUT)
	title_anim.interpolate_property(get_node("Title"), "visibility/opacity", 0, 1, 3, Tween.TRANS_QUINT, Tween.EASE_IN)
	title_anim.start()
	
	get_node("Bubbles/AnimationPlayer").play("Move")


func _on_title_tween_complete(object, key):
	get_node("Buttons").show()


func _on_button_exit_pressed():
	get_tree().quit()


func _on_button_play_pressed():
	SceneSwitch.change_scene(SceneSwitch.SCENE_GAME)
	#get_tree().change_scene("res://Stages/Stack.tscn")

