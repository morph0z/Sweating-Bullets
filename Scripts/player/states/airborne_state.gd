extends PlayerState

var quickStepLeftOnce:bool = false
var quickStepRightOnce:bool = false
func _update(_delta: float) -> void:
	if Input.is_action_just_pressed("QQuickStepLeft"):
		if !quickStepLeftOnce:
			player_reference.sideStepLeft()
			quickStepLeftOnce = true
	if Input.is_action_just_pressed("EQuickStepRight"):
		if !quickStepRightOnce:
			player_reference.sideStepRight()
			quickStepRightOnce = true
	if player_reference.is_on_floor():
		set_state(player_reference.idle)
		quickStepLeftOnce = false
		quickStepRightOnce = false
	if player_reference.is_on_wall():
		#print(player_reference.wallRunning.alreadyWallJumped)
		if !player_reference.wallRunning.alreadyWallJumped:
			set_state(player_reference.wallRunning)
	if Input.is_action_pressed("ZStomp"):
		player_reference.stomp(5)
	
func _enter() -> void:
	player_reference.feelingGravity = true
