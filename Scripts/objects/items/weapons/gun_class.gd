@abstract
class_name gun extends item

var BASIC_BULLET:PackedScene
@export var shoot_point:Marker3D
@export var lazer_sight:lazer_sight_ray

@abstract
func shoot(bullet:PackedScene)

@abstract
func throwHit(bullet:PackedScene, thing_hit)

func create_bullet(scene:PackedScene, damage:int):
	var newBullet:bulletClass = scene.instantiate()
	newBullet.damage_dealt = damage
	newBullet.position = shoot_point.global_position
	newBullet.rotation = shoot_point.global_rotation
	get_tree().get_root().add_child(newBullet)

@abstract
func override_bullet()

func _ready() -> void:
	override_bullet()
	for i in get_children():
		if i is not hitboxComponent: continue
		i.connect("body_entered", body_entered)

func body_entered(body:Node3D) -> void:
	throwHit(BASIC_BULLET, body)
