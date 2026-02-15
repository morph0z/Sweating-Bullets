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
@export var tilt_speed:float = 0.6

@export_category("Fov Settings")
@export var fov_inc:float = 0.3
@export var fov_min:float = 60
@export var fov_max:float = 120

@export_category("Wall Run")
@export var wallrun_tilt:float = 10
@export var wallrun_tilt_time:float = 0.2

@export_category("Slide")
@export var slide_tilt:float = 5
@export var slide_tilt_time:float = 0.1

var enable_effects:bool = true

func _process(delta: float) -> void:
	if enable_effects:
		calculate_view_offset(delta)
		calculate_fov_effect(delta)
		calculate_wallrun_tilt(delta)
		calculate_slide_tilt(delta)
	
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
	rotation = lerp(rotation, angles, tilt_speed)

func calculate_fov_effect(_delta:float):
	if not playerReference:
		return
	
	var velocity = playerReference.velocity
	var forward = global_transform.basis.z
	var newFovClamped:float
	if enable_fov_effects:
		var newFov = ((velocity.dot(forward))*-5)+fov_min
		newFovClamped = clampf(newFov, fov_min, fov_max)
	fov = lerp(fov, newFovClamped, fov_inc)

var resetWallTiltOnce:bool = false
func calculate_wallrun_tilt(_delta:float):
	if not playerReference: return

	if playerReference.state_machine.get_active_state().name == "WallRunning":
		resetWallTiltOnce = false
		var wallTiltTween:Tween = create_tween()
		wallTiltTween.set_ease(Tween.EASE_IN_OUT)
		wallTiltTween.set_trans(Tween.TRANS_CUBIC)
		if playerReference.get_wall_normal().x != 0:
			wallTiltTween.tween_property(self, "rotation_degrees", Vector3(0,0,wallrun_tilt)*-playerReference.get_wall_normal().normalized().x * playerReference.transform.basis, wallrun_tilt_time)
		elif playerReference.get_wall_normal().z != 0:
			wallTiltTween.tween_property(self, "rotation_degrees", Vector3(0,0,wallrun_tilt)*-playerReference.get_wall_normal().normalized().z * playerReference.transform.basis.x, wallrun_tilt_time)
			
	if playerReference.state_machine.get_active_state().name != "WallRunning":
		if !resetWallTiltOnce:
			var wallTiltTween:Tween = create_tween()
			wallTiltTween.set_ease(Tween.EASE_IN_OUT)
			wallTiltTween.set_trans(Tween.TRANS_CUBIC)
			wallTiltTween.tween_property(self, "rotation_degrees", Vector3.ZERO, wallrun_tilt_time)
			resetWallTiltOnce = true

var resetSlideTiltOnce:bool = false
func calculate_slide_tilt(_delta:float):
	if not playerReference:
		return

	if playerReference.state_machine.get_active_state().name == "Sliding":
		resetSlideTiltOnce = false
		var slideTiltTween:Tween = create_tween()
		slideTiltTween.set_ease(Tween.EASE_IN_OUT)
		slideTiltTween.set_trans(Tween.TRANS_CUBIC)
		slideTiltTween.tween_property(self, "rotation_degrees", Vector3(slide_tilt/5,0,slide_tilt), slide_tilt_time)
			
	if playerReference.state_machine.get_active_state().name != "Sliding":
		if !resetSlideTiltOnce:
			var slideTiltTween:Tween = create_tween()
			slideTiltTween.set_ease(Tween.EASE_IN_OUT)
			slideTiltTween.set_trans(Tween.TRANS_CUBIC)
			slideTiltTween.tween_property(self, "rotation_degrees", Vector3.ZERO, slide_tilt_time)
			resetSlideTiltOnce = true
		
