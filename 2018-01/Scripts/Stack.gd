extends Node


const grid_size = Vector2(4, 8)
const block_size = Vector2(64, 64)
const fish_per_bomb = 100
const bomb_chance = 8
const lines_per_level = 5
const increase_percentage = 0.925


var score = 0
var base_score = 3
var fish_count = 0
var bomb_count = 0
var speed = 0.70
var line_tick = 0
var move_speed = 0.4
var lines = 0
var active = true

onready var game_grid = get_node("GameGrid")
onready var movement_handler = get_node("MovementHandler")
onready var fill_timer = get_node("FillTimer")
onready var clicked_container = get_node("ClickedContainer")

var block_scene = preload("res://Objects/Block.tscn")
var bomb_scene = preload("res://Objects/Bomb.tscn")


# ***************
# AUTO FUNCTIONS
# called by the engine or connected through signals
# ***************

func _ready():
	randomize()
	grid_initialize()
	fill_timer.set_wait_time(speed)
	fill_timer.start()



# ***************
# HELPER FUNCTIONS
# ***************

func rand_int_range(min_range, max_range):
	# returns a random integer for a given range (inclusive)
	var mod_by = max_range - min_range + 1
	return (randi() % mod_by) + min_range


func create_mover(target, from_pos, to_pos):
	var mover = Tween.new()
	mover.interpolate_property(target, "transform/pos", from_pos, to_pos, move_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	mover.connect("tween_complete", self, "dispose_mover", [mover])
	movement_handler.add_child(mover)
	mover.start()


func dispose_mover(object, key, mover):
	mover.queue_free()


func is_game_over():
	var result = false
	var end_zone = get_node("EndZone")
	if end_zone.get_overlapping_areas().size() > 0:
		get_node("FillTimer").stop()
		active = false;
		get_node("Sharks").set_process(true)
		get_node("Ground").stop();
		result = true
		get_node("SoundEffects").play("steel_sharks")
	
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
	line_tick += 1
	
	get_node("SoundEffects").play("line_shake")
	
	if line_tick < grid_size.y:
		return
	
	line_tick = 0
	
	if is_game_over():
		return
	
	var sound = "steel_line01"
	
	lines += 1
	if lines % lines_per_level == 0:
		speed = speed * increase_percentage
		fill_timer.set_wait_time(speed)
		sound = "steel_line02"
	
	for grid_part in game_grid.get_children():
		for column in grid_part.get_children():
			var new_item
			if bomb_count > 0 && randi() % bomb_chance == 0:
				bomb_count -= 1
				new_item = bomb_create()
			else:
				new_item = block_create()
			new_item.set_pos(Vector2(-(block_size.x * 2), 0))
			column.add_child(new_item)
			column_move_items(column)
	
	get_node("SoundEffects").play(sound)



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
		item.move(to_pos, move_speed)



# ***************
# BLOCK FUNCTIONS
# functions dealling with blocks in the grid
# ***************

func block_create():
	var block_index = rand_int_range(0, 3)
	var block = block_scene.instance()
	block.type = block.block_types[block_index]
	block.connect("clicked", self, "_on_block_clicked")
	return block


func _on_block_clicked(block):
	if !active:
		return
	
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
	
	var sound_index = min(3, floor(block_list.size() / 3))
	var sound = "steel_fish0" + str(sound_index)
	
	dispose_blocks(block_list, sound)


func bomb_create():
	var bomb = bomb_scene.instance()
	bomb.connect("clicked", self, "_on_bomb_clicked")
	return bomb


func _on_bomb_clicked(bomb):
	if !active:
		return
	
	var block_list = [bomb]
	var neighbor_list = bomb.get_neighbor_matches()
	
	while neighbor_list.size() > 0:
		var new_neighbors = []
		for neighbor in neighbor_list:
			if !block_list.has(neighbor):
				block_list.append(neighbor)
				if neighbor.is_in_group("Bomb"):
					new_neighbors += neighbor.get_neighbor_matches()
		neighbor_list = new_neighbors
	
	dispose_blocks(block_list, "steel_line03")


func dispose_blocks(block_list, sound):
	var block_count = block_list.size()
	
	for block in block_list:
		var global_pos = block.get_global_pos()
		block.get_parent().remove_child(block)
		block.set_pos(global_pos)
		clicked_container.add_child(block)
		block.escape(move_speed)
	
	var multiplier = (block_count - 3) + 1
	score += base_score * multiplier
	
	fish_count += block_count
	if fish_count >= fish_per_bomb:
		fish_count -= fish_per_bomb
		bomb_count += 1
	
	get_node("SoundEffects").play(sound)
	
	grid_collapse()


# ***************
# UI FUNCTIONS
# functions dealling with game over UI
# ***************


func _on_sharks_exit_tree():
	var score_panel = get_node("GameOver/ScorePanel")
	score_panel.get_node("ScoreValue").set_text(str(score))
	
	get_node("GameOver/ScorePanel/Particles").set_emitting(true)
	
	var anim = get_node("GameOver/Animation")
	anim.interpolate_property(score_panel, "rect/pos", score_panel.get_pos(), Vector2(320, 256), 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	anim.interpolate_property(get_node("GameOver/Title"), "visibility/opacity", 0, 1, 1.5, Tween.TRANS_QUART, Tween.EASE_IN)
	anim.start()
	get_node("SoundEffects").play("bubble_end")


func _on_animation_tween_complete( object, key ):
	get_node("GameOver/ButtonExit").show()
	get_node("GameOver/ScorePanel/Particles").set_emitting(false)
	get_node("GameOver/ScoreCheck").start()


func _on_score_check_timeout():
	if score > Settings.high_score:
		Settings.high_score = score
		get_node("SoundEffects").play("steel_high_score")
		var score_icon = get_node("GameOver/ScorePanel/HighScore")
		score_icon.show()
		var anim = get_node("GameOver/ScorePanel/HighScore/Animation")
		anim.interpolate_property(score_icon, "transform/scale", Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		anim.start()


func _on_button_retry_pressed():
	get_node("SoundEffects").play("button_click")
	SceneSwitch.change_scene(SceneSwitch.SCENE_GAME)


func _on_button_exit_pressed():
	get_node("SoundEffects").play("button_click")
	get_tree().quit()


func _on_button_menu_pressed():
	get_node("SoundEffects").play("button_click")
	SceneSwitch.change_scene(SceneSwitch.SCENE_MENU)


