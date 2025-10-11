class_name PlayerState extends LimboState

@export var debug : bool = false

@onready var player_reference : player = self.get_parent().get_parent()


func set_state(state: PlayerState):
	player_reference.state_machine.change_active_state(state)

#func _ready() -> void:
	#if parentStateMachine and parentStateMachine is PlayerStateMachine:
		#player_reference = parentStateMachine.player_reference
