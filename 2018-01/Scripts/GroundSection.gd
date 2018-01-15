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
	for point in get_node("Accents").get_children():
		var accent = accent_scene.instance()
		var x = (randi() % (2 * 64))
		var y = randi() % 12
		container.add_child(accent)
		accent.set_pos(point.get_pos() + Vector2(x, y))

