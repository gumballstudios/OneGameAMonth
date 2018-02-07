extends Node2D


var deployRound = 0

var enemyScene = preload("res://Objects/Enemy.tscn")
var powerUpScene = preload("res://Objects/Powerup.tscn")


func _ready():
	randomize()


func ProcessRound():
	EnemyMarch()
	DeployNewEnemies()


func EnemyMarch():
	for enemy in $EnemyContainer.get_children():
		enemy.March()


func DeployNewEnemies():
	deployRound += 1
	var enemyCount = (randi() % 4) + 1
	var giveItem = (randf() <= 0.75)
	var columns = GetRandomColumns(enemyCount, giveItem)
	for i in range(enemyCount):
		var enemy = enemyScene.instance()
		enemy.position = $EnemySpawn.position
		$EnemyContainer.add_child(enemy)
		enemy.Deploy(columns[i], deployRound)
	
	if giveItem:
		var powerup = powerUpScene.instance()
		powerup.Deploy(columns[enemyCount])
		$EnemyContainer.add_child(powerup)


func GetRandomColumns(count, extra):
	if extra:
		count += 1
	var columns = range(7)
	var results = []
	for i in range(count):
		var index = randi() % columns.size()
		results.append(columns[index])
		columns.remove(index)
	
	return results