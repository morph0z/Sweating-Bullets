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

#func _ready() -> void:
	#if parentStateMachine and parentStateMachine is PlayerStateMachine:
		#player_reference = parentStateMachine.player_reference
