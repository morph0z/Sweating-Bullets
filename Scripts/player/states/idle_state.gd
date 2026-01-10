extends PlayerState

func _update(_delta: float) -> void:
	velocity_handling(_delta)
	if Input.is_action_just_pressed("QQuickStepLeft"):
		player_reference.sideStepLeft()
	if Input.is_action_just_pressed("EQuickStepRight"):
		player_reference.sideStepRight()
	if player_reference and player_reference._input_dir.length() > 0:
		set_state(player_reference.moving)
	else:
		set_state(player_reference.standing)
