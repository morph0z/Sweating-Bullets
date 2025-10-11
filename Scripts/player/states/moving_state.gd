extends PlayerState


func _update(_delta: float) -> void:
	if player_reference._input_dir.length() == 0 and player_reference.velocity.length() < 0.5:
		set_state(player_reference.idle)
	if player_reference._input_dir != Vector2.ZERO:
		set_state(player_reference.walking)
	if not player_reference.is_on_floor():
		set_state(player_reference.airborne)
