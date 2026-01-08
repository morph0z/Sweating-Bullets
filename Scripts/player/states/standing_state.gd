extends PlayerState


func _update(delta: float) -> void:
	if Input.is_action_just_pressed("QQuickStepLeft"):
		player_reference.sideStepLeft()
	if Input.is_action_just_pressed("EQuickStepRight"):
		player_reference.sideStepRight()
	player_reference.camera.update_camera_height(delta, false, 0)
	
	if Input.is_action_pressed("LeftShiftCrouch") and player_reference.is_on_floor():
		set_state(player_reference.crouching)
	if player_reference and player_reference._input_dir.length() > 0:
		set_state(player_reference.moving)
		
	if Input.is_action_just_pressed("SpaceJump") and player_reference.is_on_floor():
		player_reference.jump(1)
		set_state(player_reference.airborne)
		
func _enter() -> void:
	player_reference.crouch_modifier = 0.0
	player_reference.sprint_modifier = 0
	player_reference.crouchPostureCollision(false)
