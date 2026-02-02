class_name item extends RigidBody3D

func _on_player_use_item() -> void:
	use_item()

func use_item() -> void:
	assert(false, "Please override this function... Jamal, yeah thats right I know your name, I also know where you live, so be careful.")
	
func pick_item_up(player_ref:player) -> void:
	if !(player_ref.held_item.get_children().size() == 0): return
	self.reparent(player_ref.held_item)
	initilize_holding()
	
func initilize_holding() -> void:
	freeze = true
	set_collision_layer_value(2, false)
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	
