extends Node


var factory

var factoryScene = preload("res://Objects/Ninjas/NinjaFactory.tscn")


func _ready():
	randomize()
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


func _on_play_pressed():
	$Buttons/ClickSound.play()
	SceneSwitch.ChangeScene(SceneSwitch.SCENE_GAME)


func _on_play_mouse_entered():
	$Buttons/Action.text = "play"


func _on_play_mouse_exited():
	$Buttons/Action.text = ""

