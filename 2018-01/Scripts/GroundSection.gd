extends Node2D


var speed = 50

onready var container = get_node("AccentContainer")

var accent_scene = preload("res://Objects/GroundSpriteAccent.tscn")


func _ready():
	randomize()
	set_process(true)
	add_accents()


func _process(delta):
	var offset = Vector2(speed * delta, 0)
	set_pos(get_pos() + offset)


func _on_visibility_exit_screen():
	queue_free()


func add_accents():
	var count = (randi() % 10) + 1
	for index in range(count):
		var accent = accent_scene.instance()
		var x = (randi() % (16 * 64)) + 64
		var y = 64 + 12 + (randi() % 12)
		accent.set_pos(Vector2(-x, -y))
		container.add_child(accent)
	