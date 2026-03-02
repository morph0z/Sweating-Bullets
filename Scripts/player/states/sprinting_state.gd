extends PlayerState


func _update(delta: float) -> void:
	player_reference.camera.update_camera_height(delta, false, 0)
	player_reference.crouchPostureCollision(false)
	
	velocity_handling(delta)
	
	if player_reference.is_on_wall():
		cancel_velocity()
	
	if Input.is_action_just_pressed("QQuickStepLeft"):
		player_reference.sideStepLeft()
	if Input.is_action_just_pressed("EQuickStepRight"):
		player_reference.sideStepRight()
	if not Input.is_action_pressed("ControlSprint"):
		set_state(player_reference.walking)
		
	if Input.is_action_just_pressed("LeftShiftCrouch") and player_reference.is_on_floor():
		set_state(player_reference.sliding)
		
	if Input.is_action_just_pressed("SpaceJump") and player_reference.is_on_floor():
		jump(1.5)
		set_state(player_reference.airborne)

func _enter() -> void:
	#machine.animationPlayer.play("Sprint")
	player_reference.sprint_modifier = player_reference.sprint_speed

func _exit() -> void:
	var notSpeeding:bool = player_reference.state_machine.get_active_state().name == "Walking" or player_reference.state_machine.get_active_state().name == "Moving" or player_reference.state_machine.get_active_state().name == "Crouching"
	if notSpeeding:
		#_reset_sprint_modifier()
		cancel_velocity()

func _reset_sprint_modifier():
	player_reference.sprint_modifier -= player_reference.sprint_speed


func _on_sprint_sound_timeout() -> void:
	if self.is_active(): player_reference.sound_component.footstep()
