extends PlayerState


# Called when the node enters the scene tree for the first time.
func _update(delta: float) -> void:
	player_reference.velocity += (player_reference.get_gravity() * delta)*0.2
	if player_reference.is_on_floor():
		set_state(player_reference.sprinting)
	if !player_reference.is_on_wall():
		set_state(player_reference.airborne)
	if Input.is_action_just_pressed("SpaceJump"):
		player_reference.wallJump()
		set_state(player_reference.airborne)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _enter() -> void:
	player_reference.wallRun()
	
