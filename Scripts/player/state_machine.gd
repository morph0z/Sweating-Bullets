class_name PlayerStateMachine extends LimboHSM

@export var debug : bool = false
@export_category("References")
@export var player_reference: player


#
#func _process(delta: float) -> void:
	#if player_reference:
		#player_reference.state_machine.set_expression_property("Player Velocity", player_reference.velocity)
		#player_reference.state_machine.set_expression_property("Player Hitting Head", player_reference.crouch_check.is_colliding())
		#player_reference.state_machine.set_expression_property("Looking At: ", player_reference.interaction_raycast.current_object)
