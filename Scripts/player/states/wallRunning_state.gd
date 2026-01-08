extends PlayerState

var alreadyWallJumped:bool = false
var wall_normal:Vector3
var wall_tangent:Vector3

var jump_force = 6.0
var push_force = 5.0
# Called when the node enters the scene tree for the first time.
func _update(_delta: float) -> void:
	wall_normal = player_reference.get_wall_normal()
	wall_tangent = wall_normal.cross(Vector3.UP).normalized()
	
	if wall_tangent.dot(player_reference.velocity) < 0:
		wall_tangent = -wall_tangent
	
	player_reference.velocity += wall_tangent * 10 * player_reference.transform.basis

	if Input.is_action_just_pressed("SpaceJump"):
		wall_jump()
		set_state(player_reference.airborne)
	if player_reference.is_on_floor():
		set_state(player_reference.sprinting)
	if !player_reference.is_on_wall():
		set_state(player_reference.airborne)

func wall_jump():
	player_reference.velocity = Vector3(0,0 ,100)

func _enter() -> void:
	player_reference.wallRun()

func _exit() -> void:
	await get_tree().create_timer(0.4).timeout
	alreadyWallJumped = false
