extends PathFollow2D


signal target_hit

var targetSize = 20
var points = 10
var shot = false

var speed = 250
var direction = 1


func _ready():
	randomize()
	var index = randi() % $Body.get_child_count()
	var body = $Body.get_child(index)
	body.show()
	
	unit_offset = index
	direction = direction - 2 * index
	
	#set_process(false)
	pass


func _process(delta):
	offset += (speed + rand_range(-200, 100)) * delta * direction
	#speed * delta * direction
	#(speed + rand_range(-100, 100)) * delta * direction
	if unit_offset < 0 or unit_offset > 1:
		queue_free()


func _on_shot(facing):
	if shot:
		return
	
	shot = true
	var body = $Body.get_node(facing)
	var pos = body.get_local_mouse_position() - body.get_node("Target").position
	
	if pos.length() < targetSize:
		var percentage = (targetSize - pos.length()) / targetSize
		var score = ceil(points * percentage)
		print(points, " * ", percentage, " = ", score)
		emit_signal("target_hit")
	
	set_process(false)
	$DeathAnimation.interpolate_property(self, "rotation_degrees", rotation_degrees, rotation_degrees + rand_range(45, 90) * -direction, .75, Tween.TRANS_QUAD, Tween.EASE_IN)
	$DeathAnimation.interpolate_method(self, "MoveDown", position.y, position.y + 400, .5, Tween.TRANS_BACK, Tween.EASE_IN)
	$DeathAnimation.interpolate_method(self, "MoveSide", position.x, position.x + 100 * direction, .75, Tween.TRANS_QUART, Tween.EASE_OUT)
	$DeathAnimation.start()


func MoveDown(new_y):
	position.y = new_y


func MoveSide(new_x):
	position.x = new_x


func _on_death_completed( object, key ):
	queue_free()
