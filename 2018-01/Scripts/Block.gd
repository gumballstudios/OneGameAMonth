extends Area2D


var my_group 
var strength

var block_textures = { 
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
	if my_group:
		add_to_group(my_group)
		var sprite = get_node("Sprite")
		var texture = load(block_textures[my_group])
		sprite.set_texture(texture)
	
	for ray in get_node("Neighbors").get_children():
		ray.add_exception(self)
	
	strength = GlobalSettings.rand_int_range(1, GlobalSettings.block_strength_max)
	get_node("Label").set_text(str(strength))


func _input(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		var block_list = [self]
		collect_matching_blocks(block_list)
		
		if block_list.size() < 3:
			return
		
		for block in block_list:
			block.clicked()
		
		GlobalSettings.game_grid.refresh()


func collect_matching_blocks(block_list):
	for ray in get_node("Neighbors").get_children():
		if ray.is_colliding():
			var neighbor = ray.get_collider()
			if neighbor.is_in_group(my_group):
				if !block_list.has(neighbor):
					block_list.append(neighbor)
					neighbor.collect_matching_blocks(block_list)


func get_neighbor_match_count():
	var count = 0
	for ray in get_node("Neighbors").get_children():
		if ray.is_colliding():
			var neighbor = ray.get_collider()
			if neighbor.is_in_group(my_group):
				count += 1
	return count


func clicked():
	strength -= 1
	get_node("Label").set_text(str(strength))
	
	if strength < 1:
		get_parent().remove_child(self)
		queue_free()
		GlobalSettings.score()

