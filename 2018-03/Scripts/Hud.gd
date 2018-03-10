extends Control


var score = 0 setget SetScore, GetScore
var miss = 0 setget SetMiss, GetMiss


func _ready():
	pass


func SetScore(value):
	score = value
	$Score.text = str(score)


func GetScore():
	return score


func SetMiss(value):
	miss = value
	$Miss/Value.text = str(miss)


func GetMiss():
	return miss

