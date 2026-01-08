extends PlayerState

##In Seconds
@export var slidingLength:float = 0.5

func _enter() -> void:
	player_reference.crouchPostureCollision(true)
	player_reference.velocity.x += player_reference._movement_velocity.x * player_reference.slide_velocity
	player_reference.velocity.z += player_reference._movement_velocity.z * player_reference.slide_velocity
	await get_tree().create_timer(slidingLength).timeout
	var canStand = (!(Input.is_action_pressed("LeftShiftCrouch"))) and (player_reference.is_on_floor()) and (!(player_reference.crouch_check.is_colliding()))
	if canStand:
		set_state(player_reference.sprinting)
	elif !canStand:
		set_state(player_reference.crouching)
	
func _update(delta: float) -> void:
	player_reference.camera.update_camera_height(delta, true, 1)
	if Input.is_action_just_pressed("QQuickStepLeft"):
		player_reference.sideStepLeft()
	if Input.is_action_just_pressed("EQuickStepRight"):
		player_reference.sideStepRight()
