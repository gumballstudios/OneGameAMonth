extends Node


const config_path = "user://mmn.cfg"

var config_file = ConfigFile.new()
var high_score = 0 setget set_high_score, get_high_score
var audio = true setget set_audio, get_audio


func _ready():
	load_settings()


func get_high_score():
	return high_score


func set_high_score(value):
	high_score = value
	save_settings()


func get_audio():
	return audio


func set_audio(value):
	audio = value
	AudioServer.set_bus_mute(0, !audio)
	save_settings()


func load_settings():
	var error_code = config_file.load(config_path)
	if error_code != OK:
		return
	
	audio = config_file.get_value("audio", "enabled", true)
	AudioServer.set_bus_mute(0, !audio)
	
	high_score = config_file.get_value("user", "score", 0)


func save_settings():
	config_file.set_value("audio", "enabled", audio)
	config_file.set_value("user", "score", high_score)
	config_file.save(config_path)
