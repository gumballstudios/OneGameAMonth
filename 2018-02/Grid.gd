extends Node


var blockScene = preload("res://Block.tscn")


func _ready():
	pass


func ProcessRound():
	MoveBricks()
	AddNewBricks()


func MoveBricks():
	for brick in $BlockContainier.get_children():
		brick.MoveDown()


func AddNewBricks():
	var brickCount = (randi() % 3) + 2
	var columns = GetRandomColumns(brickCount)
	for i in range(brickCount):
		var block = blockScene.instance()
		block.position = $Spawn.position
		$BlockContainier.add_child(block)
		block.Initialize(columns[i])


func GetRandomColumns(count):
	var columns = range(7)
	var results = []
	for i in range(count):
		var index = randi() % columns.size()
		results.append(columns[index])
		columns.remove(index)
	
	return results
