extends Node


var factory

var factoryScene = preload("res://Objects/Ninjas/NinjaFactory.tscn")
var sound_sprite = preload("res://Sprites/UI/button_sound_on.png")
var sound_pressed_sprite = preload("res://Sprites/UI/button_pressed_sound_on.png")
var mute_sprite = preload("res://Sprites/UI/button_sound_off.png")
var mute_pressed_sprite = preload("res://Sprites/UI/button_pressed_sound_off.png")


func _ready():
	randomize()
	SetSoundButtonTextures()
	factory = factoryScene.instance()
	Launch()
	$Title/Many/Animation.interpolate_property($Title/Many, "rect_position", Vector2(0, -120), Vector2(0, 0), 0.8, Tween.TRANS_QUART, Tween.EASE_OUT, 1)
	$Title/Many/Animation.start()
	


func Launch():
	var ninjaRecruit = factory.GetNinja()
	ninjaRecruit.position = Vector2(rand_range(48, 312), 656)
	var to = Vector2(180, rand_range(544, 608))
	var direction = (to - ninjaRecruit.position).normalized()
	ninjaRecruit.velocity = direction * ninjaRecruit.SPEED
	$Launcher/Container.add_child(ninjaRecruit)
	ninjaRecruit.set_physics_process(true)
	$Launcher/Timer.wait_time = rand_range(0.25, 1.5)
	$Launcher/Timer.start()
	$Launcher/LaunchSound.play()


func _on_launch_timeout():
	Launch()


func SetSoundButtonTextures():
	var button = $Buttons/Container/ButtonSound
	if Settings.audio:
		button.texture_normal = sound_sprite
		button.texture_pressed = sound_pressed_sprite
	else:
		button.texture_normal = mute_sprite
		button.texture_pressed = mute_pressed_sprite


func _on_sound_pressed():
	Settings.audio = !Settings.audio
	SetSoundButtonTextures()
	$Buttons/ClickSound.play()


func _on_play_pressed():
	$Buttons/ClickSound.play()
	SceneSwitch.ChangeScene(SceneSwitch.SCENE_GAME)


func _on_mouse_exited():
	$Buttons/Action.text = ""


func _on_mouse_entered(hint):
	$Buttons/Action.text = hint


func _on_many_tween_completed( object, key ):
	$Title/Mini/Animation.interpolate_property($Title/Mini, "rect_position", Vector2(0, 0), Vector2(0, 85), 0.8, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Title/Mini/Animation.start()


func _on_mini_tween_completed( object, key ):
	$Title/Ninja/Animation.interpolate_property($Title/Ninja, "rect_position", Vector2(0, 205), Vector2(0, 155), 0.2, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Title/Ninja/Animation.interpolate_property($Title/Ninja, "rect_scale", Vector2(1, 0), Vector2(1, 1), 0.2, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Title/Ninja/Animation.start()
	$Title/Ninja.show()


func _on_ninja_tween_completed( object, key ):
	$Buttons/Container.show()
	if Settings.high_score > 0:
		$HighScore/Score.text = str(Settings.high_score)
		$HighScore/Animation.interpolate_property($HighScore, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.4, Tween.TRANS_QUAD, Tween.EASE_IN)
		$HighScore/Animation.start()

