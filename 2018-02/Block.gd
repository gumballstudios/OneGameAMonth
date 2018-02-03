extends StaticBody2D


var blockSize = Vector2(48, 48)


func _ready():
	pass

func Initialize(column):
	var startPosition = Vector2((blockSize.x * column), blockSize.y)
	print("init ", position, " -> ", startPosition)
	$Mover.interpolate_property(self, "position", position, startPosition, 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()

func MoveDown():
	$Mover.interpolate_property(self, "position", position, position + Vector2(0, blockSize.y), 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func _on_Mover_tween_started( object, key ):
	print("start")


func _on_Mover_tween_completed( object, key ):
	print("end")
