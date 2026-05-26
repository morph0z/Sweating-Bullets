extends PlayerState

func _update(delta: float) -> void:
	velocity_handling(delta)
	can_side_step()
	player_reference.camera.update_camera_height(delta, false, 0)
	
	can_crouch()
	can_jump(1)
	
	if player_reference and player_reference._input_dir.length() > 0:
		set_state(player_reference.moving)

func _enter() -> void:
	player_reference.crouch_modifier = 0.0
	player_reference.sprint_modifier = 0
	player_reference.crouchPostureCollision(false)
	#machine.animationPlayer.play("Walk")
