class_name player extends CharacterBody3D

@export var debug : bool = false
@export_category("References")
@export var camera : camPivotClass
@export var camera_effects : cameraEffects
@export var state_machine : LimboHSM 
@export var standing_collision : CollisionShape3D
@export var crouching_collision : CollisionShape3D
@export var crouch_check : ShapeCast3D
@export var interaction_raycast : RayCast3D
@onready var held_item: Node3D = $CamPiviot/Camera3D/HoldingPoint/HeldItem
@onready var leftCast: ShapeCast3D = $SideStepCasts/Left
@onready var rightCast: ShapeCast3D = $SideStepCasts/Right

@export_category("Movement Settings")
@export_group("Easing")
@export var acceleration : float = 0.2
@export var deceleration : float = 0.5
@export_group("Speed")
@export var default_speed : float = 7.0
@export var sprint_speed : float = 3.0
@export var crouch_speed : float = -5.0
@export_category("Jump Settings")
@export var jump_velocity : float = 5
@export var slide_velocity : float = 2
@export var wall_jump_velocity : float = 20
@export_category("Side Step")
@export var side_step_distance : float = 10


#region states
@onready var base: PlayerState = $LimboHSM/Base
@onready var idle: LimboState = $LimboHSM/Idle
@onready var standing: LimboState = $LimboHSM/Standing
@onready var wallRunning: LimboState = $LimboHSM/WallRunning
@onready var sprinting: LimboState = $LimboHSM/Sprinting
@onready var crouching: LimboState = $LimboHSM/Crouching
@onready var walking: LimboState = $LimboHSM/Walking
@onready var moving: LimboState = $LimboHSM/Moving
@onready var airborne: LimboState = $LimboHSM/Airborne
@onready var sliding: LimboState = $LimboHSM/Sliding
#endregion

@export_category("Components")
@export var health_component: healthComponent

var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var sprint_modifier : float = 0.0
var crouch_modifier : float = 0.0
var speed : float = 0.0
var side_step_dir:int = 0

var feelingGravity : bool = true
var currentlySliding : bool = false
var currentlyWallJumping : bool = false

signal UseItem

func _ready() -> void:
	_initialize_state_machine()

func _initialize_state_machine():
	state_machine.initial_state = idle
	state_machine.initialize(self)
	state_machine.set_active(true)

func _input(event: InputEvent) -> void:
	var canUseItem = (event.is_action("LeftClickSelect") and held_item.get_children().size() == 1)
	if canUseItem:
		UseItem.emit()
		
	var canThrow = (event.is_action_pressed("EnterThrow") and held_item.get_children().size() == 1)
	if canThrow:
		throwItem(1)

func _physics_process(delta: float) -> void:
	if (not is_on_floor()) and feelingGravity:
		velocity += get_gravity() * delta
		
	var speed_modifier = sprint_modifier + crouch_modifier
	speed = default_speed + speed_modifier
	
	_input_dir = Input.get_vector("ALeft", "DRight", "WForward", "SBackward")
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration)
	
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)
	
	if !currentlySliding and !currentlyWallJumping:
		velocity = _movement_velocity
	elif currentlySliding:
		velocity.x = _movement_velocity.x * slide_velocity
		velocity.z = _movement_velocity.z * slide_velocity
	elif currentlyWallJumping:
		velocity += get_wall_normal() * wall_jump_velocity
		velocity.y += jump_velocity/8
	if held_item.get_children().size() == 1:
		var item = held_item.get_child(0)
		item.freeze = true
	
	move_and_slide()

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)

func crouchPostureCollision(active:bool) -> void:
	standing_collision.disabled = active
	crouching_collision.disabled = !active

func sprint() -> void:
	sprint_modifier = sprint_speed
	crouchPostureCollision(false)
	
func walk() -> void:
	sprint_modifier = 0.0

func stand() -> void:
	crouch_modifier = 0.0
	crouchPostureCollision(false)
	
func crouch() -> void:
	crouch_modifier = crouch_speed
	crouchPostureCollision(true)

func jump(force: float) -> void:
	velocity.y += jump_velocity*force
	
func wallJump() -> void:
	currentlyWallJumping = true
	await get_tree().create_timer(0.1).timeout
	currentlyWallJumping = false
	
func slide() -> void:
	currentlySliding = true
	crouchPostureCollision(true)

func wallRun() -> void:
	feelingGravity = false
	velocity.y = 0

func stomp(force: float) -> void:
	velocity.y = -10*force

func sideStepRight() -> void:
	var sideStepTween:Tween = get_tree().create_tween()
	sideStepTween.set_ease(Tween.EASE_OUT)
	sideStepTween.set_trans(Tween.TRANS_EXPO)
	side_step_dir = 1
	sideStepTween.tween_property(self, "position", position + ((Vector3(side_step_distance,0,0) * transform.basis.inverse())), 0.2).from_current()
	if rightCast.is_colliding():
		sideStepTween.stop()
		side_step_dir = 0
	await sideStepTween.finished
	side_step_dir = 0

func sideStepLeft() -> void:
	var sideStepTween:Tween = get_tree().create_tween()
	sideStepTween.set_ease(Tween.EASE_OUT)
	sideStepTween.set_trans(Tween.TRANS_EXPO)
	side_step_dir = -1
	sideStepTween.tween_property(self, "position", position + ((Vector3(-side_step_distance,0,0) * transform.basis.inverse())), 0.2).from_current()
	if leftCast.is_colliding():
		sideStepTween.stop()
		side_step_dir = 0
	await sideStepTween.finished
	side_step_dir = 0

func throwItem(force) -> void:
	var item = held_item.get_child(0)
	item.freeze = false
	item.apply_impulse(transform.basis*Vector3(0,0.5*force,-force))
	item.apply_torque(transform.basis*Vector3(-20,0,0))
	item.reparent(get_tree().get_root().get_child(1))
