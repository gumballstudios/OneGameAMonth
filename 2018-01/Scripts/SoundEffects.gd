extends Node


func play(sound):
	var sound_node = get_node(sound)
	if sound_node:
		sound_node.play("sound")

