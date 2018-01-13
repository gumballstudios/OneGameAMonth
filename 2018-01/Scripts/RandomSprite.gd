extends AnimatedSprite


func _ready():
	randomize()
	var frame = randi() % get_sprite_frames().get_frame_count("default")
	set_frame(frame)

