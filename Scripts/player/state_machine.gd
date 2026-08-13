class_name PlayerStateMachine extends LimboHSM

##Enable debug viewing.
@export var debug : bool = false
@export_category("References")
##The player reference.
@export var player_reference: player

func _ready() -> void: _initialize_state_machine()

##Prepairs the state machine.
func _initialize_state_machine():
	initial_state = $Idle
	initialize(self)
	set_active(true)

#func _on_active_state_changed(current: LimboState, previous: LimboState) -> void:
	#print("{Last state: " + str(previous) +"\nNew state: " + str(current) + "}\n")
