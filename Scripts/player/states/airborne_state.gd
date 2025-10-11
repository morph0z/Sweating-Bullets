extends PlayerState


func _update(_delta: float) -> void:
	if player_reference.is_on_floor():
		set_state(player_reference.idle)
	if player_reference.is_on_wall():
		set_state(player_reference.wallRunning)
	if Input.is_action_pressed("ZStomp"):
		player_reference.stomp(5)
	
func _enter() -> void:
	player_reference.feelingGravity = true
