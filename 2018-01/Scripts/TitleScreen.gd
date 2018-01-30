extends Node


var sound_sprite = preload("res://Sprites/UI/button_sound.png")
var sound_pressed_sprite = preload("res://Sprites/UI/button_sound_pressed.png")
var mute_sprite = preload("res://Sprites/UI/button_mute.png")
var mute_pressed_sprite = preload("res://Sprites/UI/button_mute_pressed.png")


func _ready():
	get_node("GroundSection").set_process(false)
	
	var title_anim = get_node("Tween")
	var title = get_node("Title")
	title_anim.interpolate_property(title, "rect/pos", title.get_pos(), Vector2(64, 64), 3, Tween.TRANS_SINE, Tween.EASE_OUT)
	title_anim.interpolate_property(get_node("Title"), "visibility/opacity", 0, 1, 3, Tween.TRANS_QUINT, Tween.EASE_IN)
	title_anim.start()
	
	get_node("Bubbles/AnimationPlayer").play("Move")
	#get_node("SoundEffects").play("bubble_title")
	SoundEffects.play("bubble_title")
	
	set_sound_button_textures()
	
	if Settings.high_score > 0:
		get_node("Buttons/ScorePanel").show()
		get_node("Buttons/ScorePanel/HighScore").set_text(str(Settings.high_score))


func _on_title_tween_complete(object, key):
	get_node("Buttons").show()
	get_node("Buttons/Animation").play("button fade")


func _on_button_exit_pressed():
	#get_node("SoundEffects").play("button_click")
	SoundEffects.play("button_click")
	get_tree().quit()


func _on_button_play_pressed():
	#get_node("SoundEffects").play("button_click")
	SoundEffects.play("button_click")
	SceneSwitch.change_scene(SceneSwitch.SCENE_GAME)


func _on_button_help_pressed():
	#get_node("SoundEffects").play("button_click")
	SoundEffects.play("button_click")
	get_node("Instructions").show()


func _on_button_sound_pressed():
	Settings.audio = !Settings.audio
	set_sound_button_textures()
	#get_node("SoundEffects").play("button_click")
	SoundEffects.play("button_click")


func set_sound_button_textures():
	var button = get_node("Buttons/ButtonSound")
	if Settings.audio:
		button.set_normal_texture(sound_sprite)
		button.set_pressed_texture(sound_pressed_sprite)
	else:
		button.set_normal_texture(mute_sprite)
		button.set_pressed_texture(mute_pressed_sprite)

