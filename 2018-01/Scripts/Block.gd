extends Area2D

signal clicked
signal destroyed

var type 
var strength setget set_strength

var block_type_textures = { 
	"Red": "res://Sprites/block_red.png",
	"Green": "res://Sprites/block_green.png",
	"Blue": "res://Sprites/block_blue.png",
	"Yellow": "res://Sprites/block_yellow.png",
	"Orange": "res://Sprites/block_orange.png",
	"Pink": "res://Sprites/block_pink.png",
	"White": "res://Sprites/block_white.png",
	"Black": "res://Sprites/block_black.png"
}


func _ready():
	if type:
		add_to_group(type)
		var sprite = get_node("Sprite")
		var texture = load(block_type_textures[type])
		sprite.set_texture(texture)
	
	for ray in get_node("Neighbors").get_children():
		ray.add_exception(self)


func _input(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		emit_signal("clicked", self)


func set_strength(value):
	strength = value
	get_node("Label").set_text(str(strength))
	
	if strength < 1:
		get_parent().remove_child(self)
		queue_free()
		emit_signal("destroyed")


func get_neighbor_matches():
	var matches = []
	for ray in get_node("Neighbors").get_children():
		if ray.is_colliding():
			var neighbor = ray.get_collider()
			if neighbor.is_in_group(type):
				matches.append(neighbor)
	return matches

