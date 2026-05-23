class_name camPivotClass extends Node3D

@export_category("References")
##The player refrence.
@export var player_reference : player
##The refrence to the mouse input handler.
@export var component_mouse_capture_reference : mouseCaptureComponent
##The refrence to the player's arm rig.
@export var arms: Node3D


@export_category("Camera Settings")
@export_group("Camera Tilt")
##The max amount of down rotation.
@export_range(-90, -60) var tilt_lower_limit : int = -90
##The max amount of up rotation.
@export_range(60, 90) var tilt_upper_limit : int = 90

@export_group("Crouch Vertical Movement")
##The amount of camera offset when crouching.
@export var crouch_offset : float = 0.0
##The speed at which the crouch moves down.
@export var crouch_speed : float = 10

##Rotation vector
var _rotation : Vector3
##Uhhhhh ... It does ..  Something? Definately lerp related though.
var incDelta: float
##The default hight of the camera.
const DEFAULT_HEIGHT : float = 0.5

func _process(_delta: float) -> void:
	update_camera_rotation(component_mouse_capture_reference._mouse_input)

##Updates the camera rotation every frame.
func update_camera_rotation(input: Vector2) -> void:
	#Adds mouse position to the rotation.
	_rotation.x += input.y
	_rotation.y += input.x
	#Clamps the rotation between the limits.
	_rotation.x = clamp(_rotation.x, deg_to_rad(tilt_lower_limit), deg_to_rad(tilt_upper_limit))
	
	#MATH
	var _player_rotation = Vector3(0.0,_rotation.y,0.0)
	var _camera_rotation = Vector3(_rotation.x,0.0,0.0)
	
	transform.basis = Basis.from_euler(_camera_rotation)
	player_reference.update_rotation(_player_rotation)
	
	rotation.z = 0.0

##Updates the camera height when it's changed.
func update_camera_height(delta: float, down: bool, extrapolate:float) -> void:
	#Responsible for smooth camera movement up and down.
	incDelta = move_toward(clampf(incDelta, 0, 1), int(down), delta*crouch_speed)
	position.y = lerp(DEFAULT_HEIGHT, crouch_offset, incDelta+extrapolate)
