extends Area2D


var size = Vector2(38, 38)


func _ready():
	$Sprite.frame = randi() % $Sprite.frames.get_frame_count("default")


func _on_body_entered(body):
	if body.is_in_group("Ninja"):
		body.PowerUp()
		disconnect("body_entered", self, "_on_body_entered")
		$Sprite.animation = "shadow"
		z_index = 5
		modulate = Color(1, 1, 1, 0.6)
		$Mover.interpolate_property(self, "position", position, position + Vector2(0, 640), 0.6, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Mover.start()


func Deploy(column):
	position = Vector2((size.x * column), 0)
	$Mover.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1, 1), 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func March():
	$Mover.interpolate_property(self, "position", position, position + Vector2(0, size.y), 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func _on_exited( viewport ):
	queue_free()
