extends CanvasLayer


var maxShots = 3 setget SetMaxShots, GetMaxShots
var shots = 3 setget SetShots, GetShots

var bulletSprites = [
	preload("res://Sprites/Hud/icon_bullet_empty_short.png"),
	preload("res://Sprites/Hud/icon_bullet_gold_short.png")
]


func _ready():
	pass


func GetMaxShots():
	return maxShots


func SetMaxShots(value):
	maxShots = value
	UpdateBulletDisplay()


func GetShots():
	return shots


func SetShots(value):
	if value > maxShots:
		return
	
	shots = value
	UpdateBulletDisplay()


func UpdateBulletDisplay():
	while $Bullets.get_child_count() < maxShots:
		var bullet = TextureRect.new()
		$Bullets.add_child(bullet)
	
	while $Bullets.get_child_count() > maxShots:
		var bullet = $Bullets.get_child(0)
		$Bullets.remove_child(bullet)
		bullet.queue_free()
	
	for bullet in $Bullets.get_children():
		bullet.texture = bulletSprites[int(bullet.get_index() < shots)]