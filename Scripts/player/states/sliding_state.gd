extends PlayerState

func _enter() -> void:
	player_reference.slide()
	await get_tree().create_timer(0.5).timeout
	var canStand = (!(Input.is_action_pressed("LeftShiftCrouch"))) and (player_reference.is_on_floor()) and (!(player_reference.crouch_check.is_colliding()))
	if canStand:
		set_state(player_reference.sprinting)
	elif !canStand:
		set_state(player_reference.crouching)
	
func _exit() -> void:
	player_reference.currentlySliding = false
	
func _update(delta: float) -> void:
	player_reference.camera.update_camera_height(delta, true, 1)
