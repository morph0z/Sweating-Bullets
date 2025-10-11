class_name cameraEffects extends Camera3D
@export_category("References")
@export var playerReference: player

@export_category("Effects")
@export var enable_tilt: bool = true
@export var enable_fov_effects: bool = true

@export_category("Kick & Recoil Settings")
@export var run_pitch:float = 0.1
@export var run_roll:float = 0.25
@export var max_pitch:float = 3.0
@export var max_roll:float = 2.5

@export_category("Fov Settings")
@export var fov_inc:float = 3
@export var fov_min:float = 60
@export var fov_max:float = 120

func _process(delta: float) -> void:
	calculate_view_offset(delta)
	calculate_fov_effect(delta)
	
func calculate_view_offset(_delta:float):
	if not playerReference:
		return
	
	var velocity = playerReference.velocity*1.5
	var angles = Vector3.ZERO
	if enable_tilt:
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		
		var forward_dot = velocity.dot(forward)
		var forward_tilt = clampf(forward_dot*deg_to_rad(run_pitch), deg_to_rad(-max_pitch), deg_to_rad(max_pitch))
		angles.x += forward_tilt
		
		var right_dot = velocity.dot(right)
		var side_tilt = clampf(right_dot*deg_to_rad(run_roll), deg_to_rad(-max_roll), deg_to_rad(max_roll))
		angles.z -= side_tilt
	rotation = angles

func calculate_fov_effect(_delta:float):
	if not playerReference:
		return
	
	var velocity = playerReference.velocity
	var forward = global_transform.basis.z
	var newFovClamped:float
	if enable_fov_effects:
		var newFov = ((velocity.dot(forward))*-5)+fov_min
		newFovClamped = clampf(newFov, fov_min, fov_max)
	fov = newFovClamped
