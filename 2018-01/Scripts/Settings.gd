extends Node

const config_path = "res://schooled.cfg"

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
	var scale = int(audio)
	AudioServer.set_stream_global_volume_scale(scale)
	AudioServer.set_fx_global_volume_scale(scale)
	save_settings()

func load_settings():
	var error_code = config_file.load(config_path)
	if error_code != OK:
		return
	
	var scale = config_file.get_value("audio", "scale", 1)
	AudioServer.set_stream_global_volume_scale(scale)
	AudioServer.set_fx_global_volume_scale(scale)
	audio = bool(scale)
	
	high_score = config_file.get_value("user", "score", 0)

func save_settings():
	config_file.set_value("audio", "scale", int(audio))
	config_file.set_value("user", "score", high_score)
	config_file.save(config_path)
