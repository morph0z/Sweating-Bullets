extends PlayerState

var alreadyWallJumped:bool = false

var jump_force = 7.0
var push_force = 15.0
# Called when the node enters the scene tree for the first time.
func _update(_delta: float) -> void:
	#velocity_handling(_delta)
	player_reference.feelingGravity = false
	player_reference.direction = -player_reference.get_wall_normal() * player_reference.speed
	if player_reference.is_on_floor(): set_state(player_reference.sprinting)
	if !player_reference.is_on_wall(): set_state(player_reference.airborne)
	if !Input.is_action_just_pressed("SpaceJump"): return
	wall_jump()
	set_state(player_reference.airborne)

func wall_jump():
	player_reference.sound_component.jump()
	player_reference.apply_force(push_force, player_reference.get_wall_normal())
	player_reference.apply_force(jump_force, Vector3.UP)

func _enter() -> void:
	player_reference.feelingGravity = false
	player_reference.velocity.y = 0

func _exit() -> void:
	await get_tree().create_timer(0.1).timeout
	alreadyWallJumped = false
