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
@export var empty_sound:AudioStreamPlayer3D
@export var automatic:bool
@export var shoot_timer:Timer
@export var gun_damage:int = 10

func shoot(bullet:PackedScene):
	if player_ref.ammo_handler.get_ammo_amount() <= 0: return
	match automatic:
		true:
			if !shoot_timer.time_left == 0: return
			while automatic && Input.is_action_pressed("LeftClickSelect") && is_selected() && is_held():
				create_bullet(bullet, gun_damage)
				shoot_timer.start()
				play_effects()
				await shoot_timer.timeout
			shoot_timer.start()
		false:
			if !shoot_timer.time_left == 0: return
			create_bullet(bullet, gun_damage)
			shoot_timer.start()
	play_effects()

func buck_shot(bullet:PackedScene, bullet_amount:int, spread:float, is_automatic:bool = false, input:StringName = "LeftClickSelect"):
	if player_ref.ammo_handler.get_ammo_amount() <= 0: return
	var spread_amount:float = 10 * spread
	match is_automatic:
		true:
			if !shoot_timer.time_left == 0: return
			while is_automatic && Input.is_action_pressed(input) && is_selected() && is_held():
				for i in range(bullet_amount):
					var created_bullet:bulletClass = create_bullet(bullet, gun_damage)
					var random_vector:Vector3 = Vector3(randf_range(-spread_amount/10, spread_amount/10),randf_range(-spread_amount/10, spread_amount/10),randf_range(-spread_amount/10, spread_amount/10))
					created_bullet.direction_overide = (-global_transform.basis.x + random_vector)/10
				shoot_timer.start()
				play_effects()
				await shoot_timer.timeout
			shoot_timer.start()
		false:
			if !shoot_timer.time_left == 0: return
			for i in range(bullet_amount):
				var created_bullet:bulletClass = create_bullet(bullet, gun_damage)
				var random_vector:Vector3 = Vector3(randf_range(-spread_amount/10, spread_amount/10),randf_range(-spread_amount/10, spread_amount/10),randf_range(-spread_amount/10, spread_amount/10))
				created_bullet.direction_overide = (-global_transform.basis.x + random_vector)/10
			shoot_timer.start()
			play_effects()

@abstract
func throwHit(bullet:PackedScene, thing_hit)

func play_effects() -> void:
	ammo_fall_effect.emitting = true
	shoot_sound.pitch_scale = randf_range(0.9, 1.1)
	shoot_sound.play()
	sparks.play()

func create_bullet(scene:PackedScene, damage:int) -> bulletClass:
	if player_ref is player: player_ref.ammo_handler.reduce_ammo(1)
	var newBullet:bulletClass = scene.instantiate()
	newBullet.damage_dealt = damage
	newBullet.position = self.shoot_point.global_position
	newBullet.rotation = self.shoot_point.global_rotation
	self.get_tree().get_root().add_child(newBullet)
	return newBullet

@abstract
func override_bullet()

func _ready() -> void:
	super()
	override_bullet()
	for i in get_children():
		if i is not hitboxComponent: continue
		i.connect("body_entered", body_entered)

func body_entered(body:Node3D) -> void: self.throwHit(BASIC_BULLET, body)
