extends Node


const grid_size = Vector2(4, 8)
const block_size = Vector2(64, 64)
const lines_per_level = 5
const speed_increase = 0.01

var block_types = [
	"Red",
	"Green",
	"Blue",
	"Yellow",
	"Orange",
	"Black"
]

var score = 0
var speed = 0.70
var lines = 0

onready var game_grid = get_node("GameGrid")
onready var movement_handler = get_node("MovementHandler")
onready var fill_timer = get_node("FillTimer")

var block_scene = preload("res://Objects/Block.tscn")



# ***************
# AUTO FUNCTIONS
# called by the engine or connected through signals
# ***************

func _ready():
	randomize()
	grid_initialize()
	fill_timer.set_wait_time(speed * grid_size.y)



# ***************
# HELPER FUNCTIONS
# ***************

func rand_int_range(min_range, max_range):
	# returns a random integer for a given range (inclusive)
	var mod_by = max_range - min_range + 1
	return (randi() % mod_by) + min_range


func create_mover(target, from_pos, to_pos):
	var mover = Tween.new()
	mover.interpolate_property(target, "transform/pos", from_pos, to_pos, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	mover.connect("tween_complete", mover, "queue_free")
	movement_handler.add_child(mover)
	mover.start()


func is_game_over():
	var result = false
	var end_zone = get_node("EndZone")
	if end_zone.get_overlapping_areas().size() > 0:
		print("*** GAME OVER ***")
		print("Lines: ", lines)
		print("Score: ", score)
		game_grid.queue_free()
		get_node("FillTimer").stop()
		result = true
	
	return result

# ***************
# GRID FUNCTIONS
# functions dealling with the full game grid
# ***************

func grid_initialize():
	grid_add_columns(game_grid.get_node("HalfTop"), -1)
	grid_add_columns(game_grid.get_node("HalfBottom"), 1)
	
	for grid_part in game_grid.get_children():
		for column in grid_part.get_children():
			column_add_items(column, grid_size.x)


# Adds columns to a grid in a set position
func grid_add_columns(grid_part, direction):
	while grid_part.get_child_count() < (grid_size.y / 2):
		var column = Node2D.new()
		column.set_pos(Vector2(0, grid_part.get_child_count() * block_size.y * direction))
		grid_part.add_child(column)


# move columns and contents to fill in  empty spaces
func grid_collapse():
	for grid_part in game_grid.get_children():
		for column in grid_part.get_children():
			if column.get_child_count() == 0:
				grid_part.remove_child(column)
				column.queue_free()
	
	var grid_half_top = game_grid.get_node("HalfTop")
	if grid_half_top.get_child_count() < (grid_size.y / 2):
		grid_move_columns(grid_half_top, -1)
		grid_add_columns(grid_half_top, -1)
	
	var grid_half_bottom  = game_grid.get_node("HalfBottom")
	if grid_half_bottom.get_child_count() < (grid_size.y / 2):
		grid_move_columns(grid_half_bottom, 1)
		grid_add_columns(grid_half_bottom, 1)
	
	for grid_part in game_grid.get_children():
		for column in grid_part.get_children():
			column_move_items(column)


func grid_move_columns(grid_part, direction):
	for column in grid_part.get_children():
		var to_pos = Vector2(0, column.get_index() * block_size.y * direction)
		create_mover(column, column.get_pos(), to_pos)


func _on_fill_timeout():
	if is_game_over():
		return
	
	lines += 1
	if lines % lines_per_level == 0:
		speed -= speed_increase
		fill_timer.set_wait_time(speed * grid_size.y)
		print("speed up ", speed)
	
	for grid_part in game_grid.get_children():
		for column in grid_part.get_children():
			var block = block_create()
			block.set_pos(Vector2(-(block_size.x * 2), 0))
			column.add_child(block)
			column_move_items(column)



# ***************
# COLUMN FUNCTIONS
# functions dealling with grid columns
# ***************

func column_add_items(column, count):
	for index in range(count):
		var block = block_create()
		var block_index = count - (index + 1)
		block.set_pos(Vector2((block_index * block_size.x), 0))
		column.add_child(block)


func column_move_items(column):
	var child_count = column.get_child_count()
	for item in column.get_children():
		var index = child_count - (item.get_index() + 1)
		var to_pos = Vector2(index * block_size.x, 0)
		create_mover(item, item.get_pos(), to_pos)



# ***************
# BLOCK FUNCTIONS
# functions dealling with blocks in the grid
# ***************

func block_create():
	var block_index = rand_int_range(0, 3)
	var block = block_scene.instance()
	block.type = block_types[block_index]
	block.connect("clicked", self, "_on_block_clicked")
	return block


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
		block.get_parent().remove_child(block)
		block.queue_free()
		score += 1
	
	grid_collapse()

