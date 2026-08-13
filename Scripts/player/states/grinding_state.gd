extends PlayerState

@export var base_grind_speed:float = 20
@export var get_off_force:float = 2

var pre_velocity:Vector3

var the_rail:rail
var the_grind_node:railNode 


func _enter() -> void:
	if player_reference.cur_rail == null: set_state(player_reference.airborne)
	
	pre_velocity = player_reference.velocity
	the_rail = player_reference.cur_rail
	
	the_grind_node = find_nearest_rail_follower(player_reference.global_position, the_rail)
	the_grind_node.forward = is_facing_same_direction(the_grind_node)
	
	the_rail.done_grinding.connect(reached_rail_end)

var find_one_nearest:bool = false
func _update(delta: float) -> void:
	cancel_velocity()
	player_reference.velocity = Vector3.ZERO
	start_grinding(delta)
	visual_effect_overrides(delta)
	
	if Input.is_action_just_pressed("SpaceJump"): eject_from_rail()

func visual_effect_overrides(delta:float) -> void:
	var velocity_influence_binary:float = remap(pre_velocity.length(), 0, 30, 0, 1)
	var velocity_influence_raw:float = clamp(pre_velocity.length(), 0, 20)
	
	player_reference.camera_effects.calculate_fov_effect_override(100 + velocity_influence_raw, 0.3)
	player_reference.speed_lines_effect.override = true
	
	player_reference.speed_lines_effect.apply_effect(0.2 + velocity_influence_binary)
	
	player_reference.camera_effects.continuous_positional_cam_shake(delta, 3 + velocity_influence_binary)
	player_reference.camera_effects.continuous_rotational_cam_shake(delta, 5 + velocity_influence_binary*2)

func eject_from_rail() -> void:
	the_grind_node.grinding = false
	player_reference.speed_lines_effect.override = false
	the_grind_node.progress_ratio = the_grind_node.init_progress_ratio
	
	find_one_nearest = false
	jump(get_off_force)
	set_state(player_reference.airborne)
	
	#(pre_velocity * 1.2) 
	var velocity_return_with_bonus:Vector3 = ((the_grind_node.speed/2) * -player_reference.transform.basis.z)
	
	player_reference.velocity += velocity_return_with_bonus
	
	the_rail.done_grinding.disconnect(reached_rail_end)

func start_grinding(delta):
	the_grind_node.grinding = true
	
	var grinding_speed_from_vel:float = (round(pre_velocity.length()/2)+1)
	the_grind_node.speed = base_grind_speed + grinding_speed_from_vel
	
	player_reference.position = \
		lerp(player_reference.position, Vector3(the_grind_node.position.x,\
												the_grind_node.position.y + 1.8,\
												the_grind_node.position.z),\
		delta*30)

func find_nearest_rail_follower(player_position, rail_node) -> railNode:
	var nearest_node:railNode = null
	var min_distance = INF
	for node in rail_node.get_children(): if node is railNode:
		var distance = player_position.distance_to(node.global_transform.origin)
		if distance < min_distance:
			min_distance = distance
			nearest_node = node
	return nearest_node

func is_facing_same_direction(path_follow: PathFollow3D) -> bool:
	var player_forward = -player_reference.global_transform.basis.z.normalized()
	var path_follow_forward = -path_follow.global_transform.basis.z.normalized()
	var dot_product = player_forward.dot(path_follow_forward)
	const THRESHOLD = 0.5
	return abs(dot_product - 1.0) < THRESHOLD

func reached_rail_end() -> void:
	eject_from_rail()

func _exit() -> void:
	player_reference.camera_effects.reset_camera_transforms()
