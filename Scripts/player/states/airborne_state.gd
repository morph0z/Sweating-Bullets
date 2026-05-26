extends PlayerState

##If the player has already done one quickstep in the air to the left.
var quickStepLeftOnce:bool = false
##If the player has already done one quickstep in the air to the right.
var quickStepRightOnce:bool = false

##The velocity of airstrafing.
var airStrafeVelocity:float = 0.1

## Can surf steeper ramps if this is higher, makes it easier to stick and bhop.
@export var air_cap := 0.85 
@export var air_accel := 800.0
@export var air_move_speed := 500.0

##Emitted when ground is touched.
signal touchedGround

func _update(_delta: float) -> void:
	if Input.is_action_just_pressed("QQuickStepLeft"):
		if !quickStepLeftOnce:
			player_reference.sideStepLeft()
			quickStepLeftOnce = true
	if Input.is_action_just_pressed("EQuickStepRight"):
		if !quickStepRightOnce:
			player_reference.sideStepRight()
			quickStepRightOnce = true
	
	velocity_handling(_delta)

	if player_reference.is_on_floor():
		if Input.is_action_pressed("LeftShiftCrouch"): set_state(player_reference.sliding)
		#OP Bunny hopping DO NOT ENABLE
		#elif Input.is_action_pressed("SpaceJump"): jump(1)
		else: set_state(player_reference.idle)

	if player_reference.is_on_wall():
		if !player_reference.wallRunning.alreadyWallJumped:
			await get_tree().create_timer(0.2).timeout
			set_state(player_reference.wallRunning)
			cancel_velocity()

	if Input.is_action_just_pressed("ZStomp"): stomp(5, false)
	if Input.is_action_just_pressed("XCancelStomp"): stomp(5, true)

func _exit() -> void:
	touchedGround.emit()
	quickStepLeftOnce = false
	quickStepRightOnce = false

func _enter() -> void: player_reference.feelingGravity = true
	
func velocity_handling(_delta:float):
	if player_reference.canMove:
		var hori_vel = Vector3(player_reference.velocity.x, 0, player_reference.velocity.z)
		var wish_dir := Vector3(player_reference._input_dir.x, 0.0, player_reference._input_dir.y).normalized()
		wish_dir = player_reference.camera.global_transform.basis * wish_dir
		wish_dir.y = 0.0
		wish_dir = wish_dir.normalized()
		
		const AIR_ACCEL := 3.0
		const AIR_MAX_SPEED := 10.0
		
		var current_speed := hori_vel.dot(wish_dir)
		var add_speed := AIR_MAX_SPEED - current_speed

		if add_speed <= 0.0: return

		var accel_speed := AIR_ACCEL * AIR_MAX_SPEED * _delta
		accel_speed = min(accel_speed, add_speed)

		hori_vel += wish_dir * accel_speed

		player_reference.velocity.x = hori_vel.x
		player_reference.velocity.z = hori_vel.z
	
func stomp(force: float, cancelLaunch:bool) -> void:
	var previousVel = Vector3(player_reference.velocity.x, 0, player_reference.velocity.z)
	player_reference.velocity = Vector3.ZERO
	player_reference._wanted_velocity = Vector3.ZERO
	player_reference.camera_effects.enable_effects = false
	player_reference.velocity.y = -50*force
	player_reference.canMove = false

	await get_tree().create_timer(1).timeout
	player_reference.canMove = true
	player_reference.camera_effects.enable_effects = true
		
	if !cancelLaunch:
		var speed := previousVel.length()
		var forwards = -player_reference.transform.basis.z.normalized()
		player_reference.velocity = forwards * speed
