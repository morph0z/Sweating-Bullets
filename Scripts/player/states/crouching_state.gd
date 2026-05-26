extends PlayerState


func _update(delta: float) -> void:
	player_reference.camera.update_camera_height(delta, true, 0)

	velocity_handling(delta)

	can_side_step()
	var canStand = (!(Input.is_action_pressed("LeftShiftCrouch"))) and (player_reference.is_on_floor()) and (!(player_reference.crouch_check.is_colliding()))
	if canStand: set_state(player_reference.idle)
	
	can_jump(0.5)

func _enter() -> void: player_reference.crouch()
