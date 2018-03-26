extends Node2D


export(String) var Text = "1"
export(Vector2) var Offset = Vector2(64, 32)


func _ready():
	$Tip/Box/Label.text = Text


func ShowTooltip():
	$Mover.interpolate_property($Tip, "scale", Vector2(0.1, 0.1), Vector2(1, 1), .4, Tween.TRANS_QUART, Tween.EASE_IN)
	$Mover.interpolate_property($Tip, "position", Vector2(0, 0), Offset, .4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Mover.start()


func _process(delta):
	var b = $Line.global_position
	var a = $Tip.global_position
	var dir = (a - b)
	$Line.region_rect.size = Vector2(round(dir.length()) + 3, 3)
	$Line.rotation = dir.angle()

