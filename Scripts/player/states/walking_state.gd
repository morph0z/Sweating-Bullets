extends PlayerState


func _update(delta: float) -> void:
	player_reference._wanted_velocity.x = clampf(player_reference._wanted_velocity.x, -player_reference.default_speed, player_reference.default_speed)
	player_reference._wanted_velocity.z = clampf(player_reference._wanted_velocity.z, -player_reference.default_speed, player_reference.default_speed)
	velocity_handling(delta)
	
	var isMovingButNotInputing = player_reference._input_dir == Vector2.ZERO and player_reference.velocity != Vector3.ZERO
	var isNotMoving = player_reference._input_dir == Vector2.ZERO and player_reference.velocity == Vector3.ZERO
	
	player_reference.camera.update_camera_height(delta, false, 0)
	if Input.is_action_just_pressed("QQuickStepLeft"):
		player_reference.sideStepLeft()
	if Input.is_action_just_pressed("EQuickStepRight"):
		player_reference.sideStepRight()
	if Input.is_action_pressed("ControlSprint"):
		set_state(player_reference.sprinting)
	if isMovingButNotInputing:
		set_state(player_reference.moving)
	elif isNotMoving:
		set_state(player_reference.idle)
		
	if Input.is_action_pressed("LeftShiftCrouch") and player_reference.is_on_floor():
		set_state(player_reference.crouching)
	if Input.is_action_just_pressed("SpaceJump") and player_reference.is_on_floor():
		jump(1)
		set_state(player_reference.airborne)

#func _enter() -> void:
	#machine.animationPlayer.play("Walk")
