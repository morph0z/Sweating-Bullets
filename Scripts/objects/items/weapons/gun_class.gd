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
	newBullet.position = self.shoot_point.global_position
	newBullet.rotation = self.shoot_point.global_rotation
	self.get_tree().get_root().add_child(newBullet)

@abstract
func override_bullet()

func _ready() -> void:
	super()
	override_bullet()
	for i in get_children():
		if i is not hitboxComponent: continue
		i.connect("body_entered", body_entered)

func body_entered(body:Node3D) -> void:
	self.throwHit(BASIC_BULLET, body)
