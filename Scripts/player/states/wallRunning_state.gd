extends PlayerState

var alreadyWallJumped:bool = false
# Called when the node enters the scene tree for the first time.
func _update(delta: float) -> void:
	player_reference.velocity.y += (player_reference.get_gravity().y * delta)*0.2
	if player_reference.is_on_floor():
		set_state(player_reference.sprinting)
	if !player_reference.is_on_wall():
		set_state(player_reference.airborne)
	if Input.is_action_just_pressed("SpaceJump"):
		alreadyWallJumped = true
		set_state(player_reference.airborne)
		player_reference.wallJump()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _enter() -> void:
	player_reference.wallRun()

func _exit() -> void:
	await get_tree().create_timer(0.4).timeout
	alreadyWallJumped = false
