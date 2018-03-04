extends Node2D


func _ready():
	pass


func MovePlayer(direction):
	$Player.Move(direction)