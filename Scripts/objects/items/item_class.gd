@abstract
class_name item extends RigidBody3D

var connectedToPlayer:bool = false

func _on_player_use_item() -> void: 
	use_item()
	print("yo0")

@abstract
func use_item()

func connect_on_use_item(player_ref:player):
	if (connectedToPlayer): return
	player_ref.connect("UseItem", _on_player_use_item)
	connectedToPlayer = true

func _ready() -> void:
	if !(get_parent() is heldItemComponent): return
	var heldItem:heldItemComponent = get_parent()
	connect_on_use_item(heldItem.player_ref)

func pick_item_up(player_ref:player) -> void:
	if !(player_ref.held_item.get_children().size() == 0): return
	self.reparent(player_ref.held_item)
	connect_on_use_item(player_ref)
	initilize_holding()
	
func initilize_holding() -> void:
	freeze = true
	set_collision_layer_value(2, false)
	position = Vector3.ZERO
	rotation = Vector3(0, deg_to_rad(-90), 0)
	
