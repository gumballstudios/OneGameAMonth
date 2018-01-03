extends Node2D


var grid_size = Vector2(12, 8)

var column_scene = preload("res://Objects/Column.tscn")

onready var column_list = get_node("Columns")


func _ready():
	add_columns()


func add_columns():
	while column_list.get_child_count() < grid_size.x:
		var column = column_scene.instance()
		column.set_pos(Vector2(column_list.get_child_count() * GlobalSettings.block_size.x, 0))
		column.blocks_high = grid_size.y
		column_list.add_child(column)


func refresh():
	for column in column_list.get_children():
		column.fill()
	
	get_node("Timer").start()


func _on_Timer_timeout():
	for column in column_list.get_children():
		if column.has_valid_matches():
			return
	
	print("Game Over")

