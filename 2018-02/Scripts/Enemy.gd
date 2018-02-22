extends StaticBody2D


signal killed

var size = Vector2(38, 38)
var strength = 1
var lifebar_index = 0


func Deploy(column, deployRound, strong):
	strength = deployRound
	if strong:
		strength *= 2
		$Sprite.animation = "ogre"
	InitializeLifeBars(strength)
	var startPosition = Vector2((size.x * column), 0)
	$Mover.interpolate_property(self, "position", position, startPosition, 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func InitializeLifeBars(life):
	for lifebar in $Hud.get_children():
		if life <= lifebar.max_value:
			lifebar.value = life
			lifebar_index = lifebar.get_index()
			return
		lifebar.value = lifebar.max_value
		life -= lifebar.max_value
	
	$Hud/LifeBar06.max_value += life
	$Hud/LifeBar06.value = $Hud/LifeBar06.max_value
	lifebar_index = $Hud/LifeBar06.get_index()


func March():
	$Mover.interpolate_property(self, "position", position, position + Vector2(0, size.y), 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mover.start()


func Hit(force):
	for i in range(force):
		var lifebar = $Hud.get_child(lifebar_index)
		lifebar.value -= 1
		if lifebar.value == 0:
			if lifebar_index == 0:
				Kill()
			else:
				lifebar_index -= 1


func Kill():
	$DeathSound.play()
	z_index = 10
	layers = 0
	$Sprite.animation = "grave"
	$Hud.hide()
	$Mover.connect("tween_completed", self, "_on_kill_complete")
	$Mover.interpolate_property(self, "position", position, position + Vector2(0, -10), 0.2, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Mover.interpolate_property(self, "scale", Vector2(1, 1), Vector2(2.5, 2.5), 0.2, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Mover.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Mover.start()
	emit_signal("killed")


func _on_kill_complete(object, key):
	queue_free()

