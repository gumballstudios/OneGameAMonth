extends Node2D


var blocks_high = 0

var block_types = [
	"Red",
	"Green",
	"Blue",
	"Yellow",
	"Orange",
	"Pink",
	"White",
	"Black"
]

var block_scene = preload("res://Objects/Block.tscn")


func _ready():
	randomize()


func fill():
	while get_child_count() < blocks_high:
		var block_index = GlobalSettings.rand_int_range(0, GlobalSettings.block_type_max - 1)
		var block = block_scene.instance()
		block.my_group = block_types[block_index]
		add_child(block)
	
	for block in get_children():
		block.set_pos(Vector2(0, -(block.get_index() * GlobalSettings.block_size.y)))


func has_valid_matches():
	for block in get_children():
		var count = block.get_neighbor_match_count()
		
		if count >= 3:
			return true
	
	return false
	
