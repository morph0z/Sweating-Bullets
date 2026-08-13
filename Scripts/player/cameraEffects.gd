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

var pre_position:Vector3
var pre_rotation:Vector3
func _ready() -> void: 
	pre_position = position
	pre_rotation = rotation

func _process(delta: float) -> void:
	if enable_effects:
		calculate_view_offset(delta)
		calculate_fov_effect(delta)
		calculate_wallrun_tilt(delta)
		calculate_slide_tilt(delta)
		calculate_camera_shake_effects(delta)

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

var fov_override:bool = false
func calculate_fov_effect(_delta:float):
	if fov_override: return
	if not playerReference:
		return
	
	var velocity = playerReference.velocity
	var forward = global_transform.basis.z
	var newFovClamped:float
	
	if !enable_fov_effects: return
	var newFov = ((velocity.dot(forward))*-5)+fov_min
	newFovClamped = clampf(newFov, fov_min, fov_max)
	fov = lerp(fov, newFovClamped, fov_inc)

func calculate_fov_effect_override(new_fov:float, change_speed:float = 0.3, min_fov:float = fov_min, max_fov:float = fov_max):
	fov_override = true
	
	if not playerReference and enable_effects:
		return

	var newFovClamped:float
	if enable_fov_effects:
		var newFov = new_fov
		newFovClamped = clampf(newFov, min_fov, max_fov)
	
	var fov_tween:Tween = get_tree().create_tween()
	fov_tween.tween_property(self, "fov", newFovClamped, change_speed)
	await fov_tween.finished
	
	fov_override = false

var resetWallTiltOnce:bool = false
func calculate_wallrun_tilt(_delta:float):
	if not playerReference: return
	
	var wallNormal:Vector3 = playerReference.get_wall_normal().normalized().round()
	
	var wallTiltCalc:Vector3 
	
	if playerReference.state_machine.get_active_state().name == "WallRunning":
		resetWallTiltOnce = false
		
		var wallTiltTween:Tween = create_tween()
		wallTiltTween.set_ease(Tween.EASE_IN_OUT)
		wallTiltTween.set_trans(Tween.TRANS_CUBIC)

		if (wallNormal.z != 0) and (wallNormal.x == 0): 
			wallTiltCalc = (Vector3(wallrun_tilt,0,wallrun_tilt) * wallNormal) * -playerReference.basis.x 
		elif (wallNormal.x != 0) and (wallNormal.z == 0): 
			wallTiltCalc = (Vector3(wallrun_tilt,0,wallrun_tilt) * wallNormal).rotated(Vector3.UP, deg_to_rad(90)) * playerReference.basis.z
		elif (wallNormal.z != 0) and (wallNormal.x != 0):
			wallTiltCalc = Vector3(wallrun_tilt,0,wallrun_tilt) * wallNormal.rotated(Vector3.UP, deg_to_rad(90))
		
		if playerReference.is_on_wall_only():
			wallTiltTween.tween_property(self, "rotation_degrees",
			wallTiltCalc, wallrun_tilt_time)
		#if playerReference.get_wall_normal().z != 0:
		#	wallTiltTween.tween_property(self, "rotation_degrees", Vector3(0,0,wallrun_tilt)*-playerReference.get_wall_normal().normalized().z * playerReference.transform.basis, wallrun_tilt_time)
	#print("Wall Normal: " + str(wallNormal) + " || Tilt Calc: " + str(wallTiltCalc) + " || IsOnWall: " + str(playerReference.is_on_wall_only()))
	
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

func reset_camera_transforms():
	position = pre_position
	rotation = pre_rotation

func calculate_camera_shake_effects(delta:float):
	var velocity = playerReference.velocity
	
	if !(velocity.length() >= 25): return
	continuous_positional_cam_shake(delta, clampf(velocity.length(), 0, 3))
	continuous_rotational_cam_shake(delta, clampf(velocity.length(), 0, 6))

func continuous_positional_cam_shake(delta:float, strength:float, speed:float = 0.2) -> void:
	var strength_reduced:float = strength/10
	
	position = lerp(position, position + \
	Vector3(
		randf_range(-strength_reduced, strength_reduced),
		randf_range(-strength_reduced, strength_reduced), 0 ),
		delta)
	
	await get_tree().create_timer(speed).timeout
	position = lerp(position, pre_position, delta)

func continuous_rotational_cam_shake(delta:float, strength:float, speed:float = 0.2) -> void:
	var strength_reduced:float = strength/10
	
	rotation = lerp(rotation, rotation + \
	Vector3(
		0, randf_range(-strength_reduced, strength_reduced),
		randf_range(-strength_reduced, strength_reduced)),
		delta)
	
	await get_tree().create_timer(speed).timeout
	rotation = lerp(rotation, pre_rotation, delta)
