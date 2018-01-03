extends Node


func _ready():
	GlobalSettings.game_grid = get_node("GameGrid")
	GlobalSettings.game_grid.refresh()


