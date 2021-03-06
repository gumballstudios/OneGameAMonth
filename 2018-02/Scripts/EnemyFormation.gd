extends Node2D


var deployRound = 0
var kills = 0

var enemyScene = preload("res://Objects/Enemy.tscn")
var powerUpScene = preload("res://Objects/Powerup.tscn")


func _ready():
	randomize()


func _on_enemy_killed():
	kills += 1
	$Hud/Kills.text = str(kills)


func ProcessRound():
	EnemyMarch()
	DeployNewEnemies()
	$Hud/Round.text = str(deployRound)
	var sound_index = deployRound % $SoundEffects.get_child_count()
	$SoundEffects.get_child(sound_index).play()


func EnemyMarch():
	for enemy in $EnemyContainer.get_children():
		enemy.March()


func DeployNewEnemies():
	deployRound += 1
	var enemyChance = [2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6]
	var enemyCount = enemyChance[randi() % enemyChance.size()]
	var giveItem = (randf() <= 0.8)
	if deployRound == 1:
		giveItem = true
	var columns = GetRandomColumns(enemyCount, giveItem)
	for i in range(enemyCount):
		var enemy = enemyScene.instance()
		enemy.connect("killed", self, "_on_enemy_killed")
		enemy.position = $EnemySpawn.position
		$EnemyContainer.add_child(enemy)
		enemy.Deploy(columns[i], deployRound, randf() <= 0.1)
	
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