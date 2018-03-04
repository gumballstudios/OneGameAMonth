extends Node2D


export(String, "Left", "Right") var facing = "Left"

var facingType = { "Left": -1, "Right": 1 }


func _ready():
	$Collider.position.x *= facingType[facing]

