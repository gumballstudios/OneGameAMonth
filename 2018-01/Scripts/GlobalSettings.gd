extends Node

const block_size = Vector2(64, 64)

var block_type_max = 3
var block_strength_max = 1

var blocks_destroyed = 0
var difficulty_increase = 150

var game_grid


func score():
	blocks_destroyed += 1
	print(blocks_destroyed)
	if blocks_destroyed % difficulty_increase == 0:
		if blocks_destroyed % (difficulty_increase * 2) == 0:
			print("increase strength")
			block_strength_max += 1
		else:
			print("increase types")
			block_type_max += 1


func rand_int_range(min_range, max_range):
	# returns a random integer for a given range (inclusive)
	var mod_by = max_range - min_range + 1
	return (randi() % mod_by) + min_range