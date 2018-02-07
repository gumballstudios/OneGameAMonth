extends StaticBody2D


var size = Vector2(38, 38)
var strength = 1


func Deploy(column, deployRound):
	strength = deployRound
	$Label.text = str(deployRound)
	var startPosition = Vector2((size.x * column), 0)
	$Mover.interpolate_property(self, "position", position, startPosition, 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func March():
	$Mover.interpolate_property(self, "position", position, position + Vector2(0, size.y), 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func Hit(force):
	strength -= force
	if strength <= 0:
		queue_free()
	else:
		$Label.text = str(strength)

