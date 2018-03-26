extends Node2D


func _ready():
	pass


func Reset():
	for projectile in $Container.get_children():
		projectile.Reset()


func Tick(count):
	var index = count % $Container.get_child_count()
	var projectile = $Container.get_child(index)
	projectile.Tick()


