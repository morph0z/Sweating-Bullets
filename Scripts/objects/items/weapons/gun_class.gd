@abstract
class_name gun extends item

var BASIC_BULLET:PackedScene
@export_group("refrences")
@export var shoot_point:Marker3D
@export var lazer_sight:lazer_sight_ray
@export var sparks:AnimatedSprite3D
@export var ammo_fall_effect:CPUParticles3D
@export_group("gun settings")
@export var shoot_sound:AudioStreamPlayer3D
@export var automatic:bool
@export var shoot_timer:Timer

func shoot(bullet:PackedScene):
	match automatic:
		true:
			while automatic && Input.is_action_pressed("LeftClickSelect") && is_selected() && is_held():
				create_bullet(bullet, 10)
				shoot_timer.start()
				await shoot_timer.timeout
		false:
			if !shoot_timer.time_left == 0: return
			create_bullet(bullet, 10)
			shoot_timer.start()

@abstract
func throwHit(bullet:PackedScene, thing_hit)

func create_bullet(scene:PackedScene, damage:int):
	var newBullet:bulletClass = scene.instantiate()
	newBullet.damage_dealt = damage
	newBullet.position = self.shoot_point.global_position
	newBullet.rotation = self.shoot_point.global_rotation
	self.get_tree().get_root().add_child(newBullet)
	ammo_fall_effect.emitting = true
	shoot_sound.pitch_scale = randf_range(0.9, 1.1)
	shoot_sound.play()
	sparks.play()

@abstract
func override_bullet()

func _ready() -> void:
	super()
	override_bullet()
	for i in get_children():
		if i is not hitboxComponent: continue
		i.connect("body_entered", body_entered)

func body_entered(body:Node3D) -> void: self.throwHit(BASIC_BULLET, body)
