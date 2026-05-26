class_name PlayerState extends LimboState

@export var debug : bool = false

@export var machine : PlayerStateMachine
@onready var player_reference : player = machine.player_reference

func set_state(state: PlayerState):
	player_reference.state_machine.change_active_state(state)

func jump(force: float) -> void:
	player_reference.sound_component.jump()
	player_reference.apply_force(player_reference.jump_velocity*force, Vector3.UP)
	await get_root().get_tree().create_timer(0.1).timeout
	set_state(player_reference.airborne)

func cancel_velocity() -> void:
	player_reference.sprint_modifier = 0
	player_reference._wanted_velocity = Vector3.ZERO
	player_reference.current_velocity = Vector2.ZERO

func velocity_handling(_delta:float):
	var wanted_velocity:Vector3 = player_reference._wanted_velocity
	var velocity:Vector3 = player_reference.velocity
	if round(wanted_velocity.length()) >= round(velocity.length()):
		player_reference.velocity = velocity.move_toward(wanted_velocity, player_reference.acceleration)
	if round(wanted_velocity.length()) < round(velocity.length()):
		player_reference.velocity = velocity.move_toward(wanted_velocity, player_reference.deceleration)
	if (0 < round(velocity.length())) and (round(wanted_velocity.length()) == 0):
		player_reference.velocity = velocity.move_toward(wanted_velocity, player_reference.deceleration)

##This function is added to update fuctions of states that you can side step in.
func can_side_step():
	if Input.is_action_just_pressed("QQuickStepLeft"): player_reference.sideStepLeft()
	if Input.is_action_just_pressed("EQuickStepRight"): player_reference.sideStepRight()

##This function is added to update fuctions of states that you can sprint in.
func can_sprint(): 	if Input.is_action_pressed("ControlSprint"): set_state(player_reference.sprinting)

##This function is added to update fuctions of states that you can stop sprinting in.
func can_stop_sprinting(): if not Input.is_action_pressed("ControlSprint"):
	set_state(player_reference.walking)
	cancel_velocity()

func can_slide(): if Input.is_action_just_pressed("LeftShiftCrouch") and player_reference.is_on_floor(): set_state(player_reference.sliding)

##This function is added to update fuctions of states that you can jump in.
func can_jump(force:float): if Input.is_action_just_pressed("SpaceJump") and player_reference.is_on_floor():
	jump(force)
	set_state(player_reference.airborne)

##This function is added to update fuctions of states that you can crouch in.
func can_crouch(): if Input.is_action_pressed("LeftShiftCrouch") and player_reference.is_on_floor(): set_state(player_reference.crouching)

##This function is added to update fuctions of states that you can be moving without input in.
func can_move_without_input():
	var isMovingButNotInputing = player_reference._input_dir == Vector2.ZERO and player_reference.velocity != Vector3.ZERO
	if isMovingButNotInputing: set_state(player_reference.moving)

##This function is added to update fuctions of states that you can be idle in.
func can_be_idle():
	var isNotMoving = player_reference._input_dir == Vector2.ZERO and player_reference.velocity == Vector3.ZERO
	if isNotMoving: set_state(player_reference.idle)
