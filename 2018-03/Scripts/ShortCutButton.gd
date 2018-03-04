extends Area2D


signal button_up
signal button_down
signal pressed

export(ShortCut) var shortcut
export(Texture) var normal
export(Texture) var pressed
export(Shape2D) var mask

var buttonClickEvent


func _ready():
	buttonClickEvent = InputEventMouseButton.new()
	buttonClickEvent.button_index = BUTTON_LEFT
	SetFrameTexture(normal, "normal")
	SetFrameTexture(pressed, "pressed")
	$Shape.shape = mask


func SetFrameTexture(texture, animation):
	var frames = $Sprite.frames
	if frames.has_animation(animation):
		frames.clear(animation)
	else:
		frames.add_animation(animation)
	frames.add_frame(animation, texture)


func _input(event):
	if shortcut:
		if event.action_match(shortcut.shortcut):
			HandleEvent(event)


func _on_area_input_event(viewport, event, shape_idx):
	if event.action_match(buttonClickEvent):
		HandleEvent(event)


func HandleEvent(event):
	if !event.is_echo():
		if event.is_pressed():
			if $Sprite.animation == "pressed":
				return
			$Sprite.animation = "pressed"
			emit_signal("button_down")
			emit_signal("pressed")
		else:
			if $Sprite.animation == "normal":
				return
			$Sprite.animation = "normal"
			emit_signal("button_up")

