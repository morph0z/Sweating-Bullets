extends PlayerState


func _update(delta: float) -> void:
	player_reference.camera.update_camera_height(delta, false, 0)
	if Input.is_action_just_pressed("QQuickStepLeft"):
		player_reference.sideStepLeft()
	if Input.is_action_just_pressed("EQuickStepRight"):
		player_reference.sideStepRight()
	if not Input.is_action_pressed("ControlSprint"):
		set_state(player_reference.walking)
		
	if Input.is_action_just_pressed("LeftShiftCrouch") and player_reference.is_on_floor():
		set_state(player_reference.sliding)
		
	if Input.is_action_just_pressed("SpaceJump") and player_reference.is_on_floor():
		player_reference.jump(1.5)
		set_state(player_reference.airborne)
		
func _enter() -> void:
	player_reference.sprint()
