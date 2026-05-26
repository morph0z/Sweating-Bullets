extends PlayerState


func _update(delta: float) -> void:
	player_reference.camera.update_camera_height(delta, false, 0)
	player_reference.crouchPostureCollision(false)
	
	velocity_handling(delta)
	
	if player_reference.is_on_wall(): cancel_velocity()
	
	can_side_step()
	can_stop_sprinting()
	
	can_slide()
	
	can_jump(1.5)

func _enter() -> void: player_reference.sprint_modifier = player_reference.sprint_speed

func _exit() -> void:
	var notSpeeding:bool = player_reference.state_machine.get_active_state().name == "Walking" or player_reference.state_machine.get_active_state().name == "Moving" or player_reference.state_machine.get_active_state().name == "Crouching"
	if notSpeeding: cancel_velocity()

func _on_sprint_sound_timeout() -> void: if self.is_active(): player_reference.sound_component.footstep()
