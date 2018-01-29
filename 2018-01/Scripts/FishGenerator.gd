extends Node


const base_fish_time = 3

var block_scene = preload("res://Objects/Block.tscn")


func _ready():
	randomize()
	_on_fish_timer_timeout()


func set_timer():
	var timer = get_node("FishTimer")
	timer.set_wait_time(base_fish_time + rand_range(-1, 1))
	timer.start()


func block_create():
	var block_index = randi() % 4
	var block = block_scene.instance()
	block.type = block.block_types[block_index]
	block.active = false
	return block


func _on_fish_timer_timeout():
	var fish = block_create()
	var zone_index = randi() % 2
	var zone = get_node("StartZones").get_child(zone_index)
	var pos_x = zone.get_pos().x
	var pos_y = rand_range(zone.get_node("Start").get_pos().y, zone.get_node("End").get_pos().y)
	
	fish.get_node("Animation").set_flip_h(bool(zone_index))
	fish.set_pos(Vector2(pos_x, pos_y))
	add_child(fish)
	
	var to_pos_x = pos_x + (1152 * -sign(pos_x))
	var to_pos_y = pos_y + rand_range(-32, 32)
	fish.move(Vector2(to_pos_x, to_pos_y), 12 + rand_range(-1, 1), Tween.TRANS_LINEAR)
	
	set_timer()

