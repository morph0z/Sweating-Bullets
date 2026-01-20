extends PlayerState


func _update(delta: float) -> void:
	player_reference.camera.update_camera_height(delta, true, 0)

	velocity_handling(delta)

	if Input.is_action_just_pressed("QQuickStepLeft"):
		player_reference.sideStepLeft()
	if Input.is_action_just_pressed("EQuickStepRight"):
		player_reference.sideStepRight()
	var canStand = (!(Input.is_action_pressed("LeftShiftCrouch"))) and (player_reference.is_on_floor()) and (!(player_reference.crouch_check.is_colliding()))
	if canStand:
		set_state(player_reference.standing)
	if Input.is_action_just_pressed("SpaceJump") and player_reference.is_on_floor():
		jump(0.5)
		set_state(player_reference.airborne)

func _enter() -> void:
	machine.animationPlayer.play("Walk")
	player_reference.crouch()
