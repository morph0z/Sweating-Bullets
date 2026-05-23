@abstract
class_name gun extends item

##The bullet scene
const BULLET = preload("uid://ba2om0p2jq4u")

@export_group("refrences")
##The marker point that the bullet shoots from.
@export var shoot_point:Marker3D
##The spark effect after shooting.
@export var sparks:CPUParticles3D
##The ammo shell falling out partical effect.
@export var ammo_fall_effect:CPUParticles3D

@export_group("gun settings")
##The sound made when a bullet is shot.
@export var shoot_sound:AudioStreamPlayer3D
##The sound made when ammo is "lacking".
@export var empty_sound:AudioStreamPlayer3D
##If the weapon fires while left click is held.
@export var automatic:bool
##The length of the cooldown after each shot.
@export var shoot_cooldown:float = 0.8
##The damage of each bullet shot.
@export var gun_damage:int = 10
##The amount of bullets it costs to shoot.
@export var bullets_amount_use:int = 1

##True if ammo amount is equal to zero, or if ammo amount is less then the cost to shoot.
var is_blank:bool

func _ready() -> void:
	super()
	initilize_timer(shoot_cooldown)

var shoot_timer:Timer
##The initilization of the gun's cooldown timer.
func initilize_timer(time:float):
	#Creates timer for shooting cooldown
	shoot_timer = Timer.new()
	shoot_timer.wait_time = time
	shoot_timer.autostart = false
	shoot_timer.one_shot = true
	
	add_child(shoot_timer)

##The base function for both the "shoot" and "buck shot" functions.
func shoot_setup(shooting_function:Callable):
	var player_ref:player
	if (entity_ref is player): player_ref = entity_ref
	else: 
		play_effects()
		shooting_function.call()
		return
	
	is_blank = player_ref.ammo_handler.get_ammo_amount() <= 0 || player_ref.ammo_handler.get_ammo_amount() < bullets_amount_use
	
	#Doesn't shoot is cooldown is active
	if shoot_timer.time_left != 0: return
	
	play_effects()
	
	#Function doesn't run if ammo amount is equal to zero.
	#Function doesn't run if ammo amount is less then the cost to shoot.
	if is_blank: return
	
	if automatic:
		#Keeps shooting if key is held
		while automatic && Input.is_action_pressed("LeftClickSelect") && is_selected() && is_held():
			shooting_function.call()
			play_effects()
			#Reduces the amount of bullets used by the amount of bullets used
			if player_ref is player: player_ref.ammo_handler.reduce_ammo(bullets_amount_use)
			shoot_timer.start()
			await shoot_timer.timeout
		shoot_timer.start()
	else:
		#Shoots only once
		play_effects()
		shooting_function.call()
		#Reduces the amount of bullets used by the amount of bullets used
		if player_ref is player: player_ref.ammo_handler.reduce_ammo(bullets_amount_use)
		shoot_timer.start()


##Shoots a single bullet.
func shoot(bullet:PackedScene): shoot_setup(func(): create_bullet(bullet, gun_damage))

##Shoots multiple bullets like a shot gun.
func buck_shot(bullet:PackedScene, bullet_amount:int, spread:float):
	shoot_setup(func(): 
					for i in range(bullet_amount):
						var created_bullet:bulletClass = create_bullet(bullet, gun_damage)
						var spread_amount:float = 10 * spread
						var random_vector:Vector3 = Vector3(randf_range(-spread_amount/10, spread_amount/10),randf_range(-spread_amount/10, spread_amount/10),randf_range(-spread_amount/10, spread_amount/10))
						created_bullet.direction_overide = (-global_transform.basis.x + random_vector)/10
						)

#@abstract
#func throwHit(bullet:PackedScene, thing_hit)

##Activates particle and sound effects.
func play_effects() -> void:
	if (!is_blank):
		#Particle effects
		ammo_fall_effect.emitting = true
		sparks.emitting = true
		
		#Sound effects
		shoot_sound.pitch_scale = randf_range(0.9, 1.1)
		shoot_sound.play()
	#No blank sounds yet
	#else:
		#empty_sound.pitch_scale = randf_range(0.9, 1.1)
		#empty_sound.play()
		

##The initilization of the bullet when shot
func create_bullet(scene:PackedScene, damage:int) -> bulletClass:
	#Instanciates new bullet
	var newBullet:bulletClass = scene.instantiate()
	newBullet.damage_dealt = damage
	newBullet.position = self.shoot_point.global_position
	newBullet.rotation = self.shoot_point.global_rotation
	self.get_tree().get_root().add_child(newBullet)
	return newBullet
	
#TODO: REWORKING GUN THROW HIT BOUNCE
	#for i in get_children():
		#if i is not hitboxComponent: continue
		#i.connect("body_entered", body_entered)
		
#func body_entered(body:Node3D) -> void: self.throwHit(BASIC_BULLET, body)
