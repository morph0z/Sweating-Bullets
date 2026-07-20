class_name player extends entityClass

##Enable debug viewing.
@export var debug : bool = false
@export_category("References")
##Reference to the camera pivot.
@export var camera : camPivotClass
##Reference to the camera effects.
@export var camera_effects : cameraEffects
##Reference to the state machine.
@export var state_machine : LimboHSM 
##Reference to the standing collision shape.
@export var standing_collision : CollisionShape3D
##Reference to the crouching collision shape.
@export var crouching_collision : CollisionShape3D
##Reference to the check if the player can stand up.
@export var crouch_check : ShapeCast3D
##Reference to the interaction ray cast.
@export var interaction_raycast : ShapeCast3D
##Reference to the sound component.
@export var sound_component : playerSoundComponent
##Reference to the sound component. 
@export var held_items:heldItemComponent
##Reference to the left ray cast.
@export var leftCast: ShapeCast3D
##Reference to the right ray cast.
@export var rightCast: ShapeCast3D

@export_category("Components")
##Reference to the ammo handler.
@export var ammo_handler:ammoHandlerComponent
##Reference to the fear handler.
@export var fear_handler:fearComponent

@export_category("Movement Settings")
@export_group("Easing")
##How long it takes to speed up to max speed. 
@export var acceleration : float = 0.2
##How long it takes to slow down to zero speed. 
@export var deceleration : float = 3
@export_group("Speed")
##The max speed under normal circumstances.
@export var default_speed : float = 7.0
##The speed increase that is added when sprinting.
@export var sprint_speed : float = 3.0
##The speed decrease that is added when crouching.
@export var crouch_speed : float = -5.0
##The speed increase that is added when sliding.
@export var slide_velocity : float = 10
@export_category("Jump Settings")
##The power of a normal jump.
@export var jump_velocity : float = 5
##The power of a wall jump.
@export var wall_jump_velocity : float = 20
@export_category("Side Step")
##The distance stepped to the side when side stepping.
@export var side_step_distance : float = 10

@export_category("Player States")
@export_group("Movement")
##The state when the player is moving with no input.
@export var moving: PlayerState
##The state when the player is in the air.
@export var airborne: PlayerState
##The state when the player is walking.
@export var walking: PlayerState
##The state when the player is sprinting,
@export var sprinting: PlayerState
##The state when the player is crouching.
@export var crouching: PlayerState
##The state when the player is doing a slide.
@export var sliding: PlayerState
@export_group("Non-Movement")
##The state when the player is doing nothing.
@export var idle: PlayerState
##The state when the player is wall running.
@export var wallRunning: PlayerState

@export_category("Components")
##Reference to the health component.
@export var health_component: healthComponent

##The direction of the controler input.
var _input_dir : Vector2 = Vector2.ZERO
##The current velocity of the player.
var current_velocity:Vector2
##The direction the player is moving in.
var direction:Vector3
##The velocity that the current velocity is trying to reach.
var _wanted_velocity : Vector3 = Vector3.ZERO

##Changes to the sprint speed.
var sprint_modifier : float = 0.0
##Changes to the crouch speed.
var crouch_modifier : float = 0.0
##The total current speed.
var speed : float = 0.0
##The direction of the side step.
var side_step_dir:int = 0

##If the player is experiencing gravity.
var feelingGravity : bool = true

##If the player is able to move or not.
var canMove:bool = true

##Emitted when the player throws an item.
signal ItemThrown(thrownItem:item)
var throwingCharge:float = 0

func _ready() -> void: _initialize_state_machine()

##Prepairs the state machine.
func _initialize_state_machine():
	state_machine.initial_state = idle
	state_machine.initialize(self)
	state_machine.set_active(true)

var isChargingThrow:bool = false
func _input(event: InputEvent) -> void:
	var canUseItem = (event.is_action_pressed("LeftClickSelect") and held_items.get_children().size() != 0)
	if canUseItem: UseItem.emit()
	var canUseItemSecondary = (event.is_action_pressed("RightClickSelect") and held_items.get_children().size() != 0)
	if canUseItemSecondary: UseItemSecondary.emit()
	var chargeThrow = (event.is_action_pressed("EnterThrow") and !held_items.get_children().is_empty() and !interaction_raycast.is_colliding())
	var throwRelease = (event.is_action_released("EnterThrow") and !held_items.get_children().is_empty() and !interaction_raycast.is_colliding())
	
	if chargeThrow: isChargingThrow = true
	if (throwRelease and throwingCharge >= 1): 
		isChargingThrow = false
		throwItem(throwingCharge)
		throwingCharge = 0

func _process(_delta: float) -> void: 
	charging_throw()
	
func charging_throw() -> void:
	if !isChargingThrow: return
	await get_tree().create_timer(0.5).timeout
	throwingCharge += 1
	print(throwingCharge)

func _physics_process(delta: float) -> void:
	if (not is_on_floor()) and feelingGravity: apply_force(delta, get_gravity())
	
	if canMove: 
		var speed_modifier = sprint_modifier + crouch_modifier
		speed = default_speed + speed_modifier

		_input_dir = Input.get_vector("ALeft", "DRight", "WForward", "SBackward")
		current_velocity = Vector2(_wanted_velocity.x, _wanted_velocity.z)
		direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()

		if direction: current_velocity = Vector2(direction.x, direction.z) * speed
		else: current_velocity = Vector2.ZERO

		_wanted_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)

	move_and_slide()

func update_rotation(rotation_input) -> void: global_transform.basis = Basis.from_euler(rotation_input)

##Changes the collision shape for the player to be shorter or heigher, depending on arg "active".
func crouchPostureCollision(active:bool) -> void:
	standing_collision.disabled = active
	crouching_collision.disabled = !active

##Sets the player to crouching.
func crouch() -> void:
	crouch_modifier = crouch_speed
	crouchPostureCollision(true)

#region Apply Force
##Applies a force to the player.
func apply_force(force:float, direction_applied:Variant):
	match typeof(direction_applied):
		TYPE_VECTOR2: _apply_force_vec2(force, direction_applied)
		TYPE_VECTOR3: _apply_force_vec3(force, direction_applied)

##If apply force arg "direction_applied" is vector2.
func _apply_force_vec2(force: float, direction_applied:Vector2) -> void:
	velocity += force*Vector3(direction_applied.x, 0 , direction_applied.y)

##If apply force arg "direction_applied" is vector3.
func _apply_force_vec3(force: float, direction_applied:Vector3) -> void:
	velocity += force*direction_applied
#endregion

##Activates a side step to the right.
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

##Activates a side step to the left.
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

##Throws the currently held item.
func throwItem(force:float) -> void:
	var itemThrown:item
	var itemThrownIndex:int
	for itemHeld:item in held_items.get_children(): if itemHeld.is_selected(): 
		itemThrownIndex = held_items.get_children().find(itemHeld)
		itemThrown = itemHeld
	if (!(itemThrown is item) or !(itemThrown.is_selected())): return
	itemThrown.initilize_dropped(true)
	for node in get_tree().get_root().get_children(): if node is level: itemThrown.reparent(node)
	itemThrown.apply_impulse(transform.basis*Vector3(0,force,-force))
	itemThrown.angular_velocity = transform.basis * Vector3(-10*force,0,0)
	
	var nextItem:item
	if !held_items.get_children().is_empty():
		for itemHeld in held_items.get_children(): nextItem = held_items.get_children()[itemThrownIndex-1]
		nextItem.select()
	
	set_collision_layer_value(3, true)
	await get_tree().create_timer(0.1).timeout
	set_collision_layer_value(3, false)
	
	ItemThrown.emit(itemThrown)
