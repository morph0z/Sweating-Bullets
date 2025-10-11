extends PlayerState

func _update(_delta: float) -> void:
	if player_reference and player_reference._input_dir.length() > 0:
		set_state(player_reference.moving)
	else:
		set_state(player_reference.standing)
