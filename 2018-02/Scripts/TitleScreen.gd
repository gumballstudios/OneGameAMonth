extends Node


var factory

var factoryScene = preload("res://Objects/Ninjas/NinjaFactory.tscn")
var sound_sprite = preload("res://Sprites/UI/button_sound_on.png")
var sound_pressed_sprite = preload("res://Sprites/UI/button_pressed_sound_on.png")
var mute_sprite = preload("res://Sprites/UI/button_sound_off.png")
var mute_pressed_sprite = preload("res://Sprites/UI/button_pressed_sound_off.png")


func _ready():
	randomize()
	if Settings.high_score > 0:
		$HighScore.show()
		$HighScore/Score.text = str(Settings.high_score)
	SetSoundButtonTextures()
	factory = factoryScene.instance()
	Launch()


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



