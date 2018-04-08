extends Node2D


var waterSprites = [
	preload("res://Sprites/water1.png"),
	preload("res://Sprites/water2.png")
]


func _ready():
	randomize()
	for index in range(16):
		var wave = TextureRect.new()
		wave.texture = waterSprites[randi() % waterSprites.size()]
		wave.mouse_filter = Control.MOUSE_FILTER_STOP
		wave.rect_position = Vector2(64 * index, 0)
		$Water.add_child(wave)


func AddDuck(duck):
	var index = randi() % $Paths.get_child_count()
	var path = $Paths.get_child(index)
	path.add_child(duck)


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
