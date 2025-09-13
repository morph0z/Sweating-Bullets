extends CharacterBody3D

#region ChildNodes
@onready var cam_piviot: Node3D = $CamPiviot
@onready var camera: Camera3D = $CamPiviot/Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: LimboHSM = $LimboHSM
#endregion

#region States
@onready var idle_state: LimboState = $LimboHSM/Idle
@onready var walking_state: LimboState = $LimboHSM/Walking
@onready var falling_state: LimboState = $LimboHSM/Falling
@onready var sprinting_state: LimboState = $LimboHSM/Sprinting
@onready var crouching_state: LimboState = $LimboHSM/Crouching
@onready var sliding_state: LimboState = $LimboHSM/Sliding

#endregion

#region Settings
@export var camSensitivity = 0.005
@export var OriginalSPEED = 5.0
#endregion

#region Variables
var SPEED = OriginalSPEED
const JUMP_VELOCITY = 4.5
var StompStregnth = -40
var QuickStepStregnth = 40
var isSprinting = false
var isCrouching = false
var isSliding = false
#endregion

func _ready() -> void:
	_initialize_state_machine()

func _unhandled_input(event: InputEvent) -> void:
#region EscapeMouseMode
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("EscapePause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#endregion

#region CameraCode
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			cam_piviot.rotate_y(-event.relative.x * camSensitivity)
			camera.rotate_x(-event.relative.y * camSensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
#endregion

func _input(event: InputEvent) -> void:
#region Stomp
	if event.is_action_pressed("ZStomp"):
		velocity.y = StompStregnth
		#NOTE add damage on hitting the ground which scales with hight
#endregion

#region Sprinting
	if event.is_action_pressed("ControlSprint"):
		SPEED += 8.0
		isSprinting = true
	elif event.is_action_released("ControlSprint"):
		SPEED = OriginalSPEED
		isSprinting = false
#endregion

func _physics_process(delta: float) -> void:
#region Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
#endregion

#region Jump
	# Handle jump.
	if Input.is_action_pressed("SpaceJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY*((abs((velocity.x+velocity.z)*0.1))+1)
#endregion

#region DirectionalMovement
	var input_dir := Input.get_vector("ALeft", "DRight", "WForward", "SBackward")
	var direction := (cam_piviot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !isSliding:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	#region Walking/Sprinting/CrouchingState
		if !isSprinting and !isCrouching and !isSliding:
			state_machine.change_active_state(walking_state)
		elif isSprinting:
			state_machine.change_active_state(sprinting_state)
		elif isCrouching:
			state_machine.change_active_state(crouching_state)
	#endregion
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	#region Idle/FallingState
		if is_on_floor():
			state_machine.change_active_state(idle_state)
		elif !is_on_floor():
			state_machine.change_active_state(falling_state)
	#endregion

#endregion

#region QuickStep
	var CameraRelative := (cam_piviot.transform.basis * Vector3(1, 0, 0)).normalized()
	if Input.is_action_just_pressed("QQuickStepLeft"):
		velocity.x -= CameraRelative.x * QuickStepStregnth
		velocity.z -= CameraRelative.z * QuickStepStregnth
	elif Input.is_action_just_pressed("EQuickStepRight"):
		velocity.x += CameraRelative.x * QuickStepStregnth
		velocity.z += CameraRelative.z * QuickStepStregnth
#endregion

#region Crouching/Sliding
	if Input.is_action_just_pressed("LeftShiftCrouch"):
		if !isSprinting:
			animation_player.play("Crouch")
			SPEED -= 3.0
			isCrouching = true
		elif isSprinting:
			slide(100)
	elif Input.is_action_just_released("LeftShiftCrouch"):
		animation_player.play("RESET")
		SPEED = OriginalSPEED
		isCrouching = false
		isSliding = false
#endregion
	move_and_slide()

func _initialize_state_machine():
	state_machine.initial_state = idle_state
	state_machine.initialize(self)
	state_machine.set_active(true)

func slide(slideStrength):
	isSliding = true
	var CameraRelative := (cam_piviot.transform.basis * Vector3(0, 0, -1)).normalized()
	velocity.x = slideStrength*CameraRelative.x
	velocity.z = slideStrength*CameraRelative.z
