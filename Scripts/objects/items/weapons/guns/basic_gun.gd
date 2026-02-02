extends gun
const BASIC_BULLET = preload("res://Scenes/objects/weapons/Ammo/BasicBullet.tscn")
@onready var shoot_point: Marker3D = $ShootPoint
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func use_item() -> void:
	var newBullet = BASIC_BULLET.instantiate()
	newBullet.position = shoot_point.global_position
	newBullet.rotation = shoot_point.global_rotation
	get_tree().get_root().add_child(newBullet)
