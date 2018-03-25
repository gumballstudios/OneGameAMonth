extends Node2D


var projectileIndex = 0


func _ready():
	ConnectProjectiles()
	ChooseProjectile()


func Reset():
	for projectile in $SubProjectiles.get_children():
		projectile.Reset()


func ConnectProjectiles():
	for projectile in $SubProjectiles.get_children():
		projectile.connect("finished", self, "_on_projectile_finished")


func ChooseProjectile():
	projectileIndex = randi() % $SubProjectiles.get_child_count()


func Tick():
	var projectile = $SubProjectiles.get_child(projectileIndex)
	projectile.Tick()


func _on_projectile_finished():
	ChooseProjectile()