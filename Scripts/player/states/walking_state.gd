extends PlayerState

func _update(delta: float) -> void:
	player_reference._wanted_velocity.x = clampf(player_reference._wanted_velocity.x, -player_reference.default_speed, player_reference.default_speed)
	player_reference._wanted_velocity.z = clampf(player_reference._wanted_velocity.z, -player_reference.default_speed, player_reference.default_speed)
	velocity_handling(delta)
	player_reference.camera.update_camera_height(delta, false, 0)
	
	can_side_step()
	can_sprint()
	
	can_move_without_input()
	can_be_idle()
	
	can_crouch()
	can_jump(1)

#func _on_walk_sound_timeout() -> void: if self.is_active(): player_reference.sound_component.footstep()
