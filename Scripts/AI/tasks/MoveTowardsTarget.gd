@tool
extends BTAction

# Task parameters.
@export var target_var: StringName = &"target"

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.


# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String: return "MoveTowardsTarget ( "+ target_var +" )"


# Called to initialize the task.
func _setup() -> void:
	pass


# Called when the task is entered.
func _enter() -> void:
	pass


# Called when the task is exited.
func _exit() -> void:
	pass


# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_var)
	if not is_instance_valid(target): return FAILURE
	
	
	move_toward(agent.global_position.x, target.global_position.x, delta)
	move_toward(agent.global_position.z, target.global_position.z, delta)
	
	return SUCCESS


# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
