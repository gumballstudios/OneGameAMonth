extends Area2D


var size = Vector2(38, 38)


func _on_body_entered(body):
	if body.is_in_group("Ninja"):
		body.PowerUp()
		queue_free()

func Deploy(column):
	position = Vector2((size.x * column), 0)


func March():
	$Mover.interpolate_property(self, "position", position, position + Vector2(0, size.y), 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()