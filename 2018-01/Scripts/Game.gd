extends Node


const grid_size = Vector2(12, 8)
const block_size = Vector2(64, 64)
const block_type_start = 3

var block_type_max = 2
var block_strength_max = 1

var block_types = [
	"Red",
	"Green",
	"Blue",
	"Yellow",
	"White",
	"Black"
]

var score = 0
var level = 0

var blocks_destroyed = 0
var difficulty_increase = 150

onready var game_grid = get_node("GameGrid")

var block_scene = preload("res://Objects/Block.tscn")



# ***************
# AUTO FUNCTIONS
# called by the engine or connected through signals
# ***************

func _ready():
	randomize()
	next_level()



# ***************
# HELPER FUNCTIONS
# ***************

func rand_int_range(min_range, max_range):
	# returns a random integer for a given range (inclusive)
	var mod_by = max_range - min_range + 1
	return (randi() % mod_by) + min_range



# ***************
# LEVEL FUNCTIONS
# functions dealling with game levels
# ***************

func next_level():
	grid_clear()
	
	score += blocks_destroyed
	blocks_destroyed = 0
	
	level += 1
	block_type_max += 1
	
	if block_type_max > block_types.size():
		block_strength_max += 1
		block_type_max = block_type_start
	
	var display = get_node("LevelDisplay")
	display.set_text("Level " + str(level))
	display.show()
	
	get_node("LevelChangeTimer").start()


func _on_level_change_timeout():
	var display = get_node("LevelDisplay")
	display.hide()
	
	grid_initialize()
	grid_refresh()



# ***************
# GRID FUNCTIONS
# functions dealling with the full game grid
# ***************

func grid_initialize():
	while game_grid.get_child_count() < grid_size.x:
		var column = Node2D.new()
		column.set_pos(Vector2(game_grid.get_child_count() * block_size.x, 0))
		game_grid.add_child(column)


func grid_refresh():
	for column in game_grid.get_children():
		column_fill(column)
	
	get_node("ValidCheckTimer").start()


func grid_clear():
	for column in game_grid.get_children():
		game_grid.remove_child(column)
		column.queue_free()


func _on_valid_check_timeout():
	for column in game_grid.get_children():
		for block in column.get_children():
			var match_list = block.get_neighbor_matches()
			if match_list.size() >= 2:
				return
	
	print("** Game Over **")
	print("Final Score: ", score)


# ***************
# COLUMN FUNCTIONS
# functions dealling with grid columns
# ***************

func column_fill(column):
	while column.get_child_count() < grid_size.y:
		var block_index = rand_int_range(0, block_type_max - 1)
		var block = block_scene.instance()
		block.type = block_types[block_index]
		block.strength = rand_int_range(1, block_strength_max)
		block.connect("clicked", self, "_on_block_clicked")
		block.connect("destroyed", self, "_on_block_destroyed")
		column.add_child(block)
	
	for block in column.get_children():
		block.set_pos(Vector2(0, -(block.get_index() * block_size.y)))



# ***************
# BLOCK FUNCTIONS
# functions dealling with blocks in the grid
# ***************

func _on_block_clicked(block):
		var block_list = [block]
		var neighbor_list = block.get_neighbor_matches()
		
		while neighbor_list.size() > 0:
			var new_neighbors = []
			for neighbor in neighbor_list:
				if !block_list.has(neighbor):
					block_list.append(neighbor)
					new_neighbors += neighbor.get_neighbor_matches()
			neighbor_list = new_neighbors
		
		if block_list.size() < 3:
			return
		
		for block in block_list:
			block.strength -= 1
		
		if blocks_destroyed >= difficulty_increase:
			next_level()
		else:
			grid_refresh()


func _on_block_destroyed():
	blocks_destroyed += 1
	print(blocks_destroyed)



