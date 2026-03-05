@abstract
class_name item extends RigidBody3D

var connectedToPlayer:bool = false

@export var selected:bool = false
var held:bool = false

signal pickedUp(selfItem:item)
signal dropped(selfItem:item)

func _on_player_use_item() -> void: 
	if !is_selected(): return
	use_item()

func _on_player_use_item_secondary() -> void: 
	if !is_selected(): return
	use_item_secondary()

@abstract func use_item()

@abstract func use_item_secondary()

func connect_on_use_item(player_inp:player):
	if (connectedToPlayer): return
	player_inp.connect("UseItem", _on_player_use_item)
	player_inp.connect("UseItemSecondary", _on_player_use_item_secondary)
	connectedToPlayer = true

func _ready() -> void:
	if (get_parent() is heldItemComponent):
		var heldItem:heldItemComponent = get_parent()
		connect_on_use_item(heldItem.player_ref)
		initilize_holding(heldItem.player_ref)
		
	if (get_parent() is not heldItemComponent):
		initilize_dropped(false)

func pick_item_up(player_inp:player) -> void:
	self.reparent(player_inp.held_items)
	connect_on_use_item(player_inp)
	initilize_holding(player_inp)
	pickedUp.emit(self)
	
@export var item_collison_layer:int = 3
func initilize_dropped(should_emit_signal:bool) -> void:
	held = false
	set_collision_layer_value(item_collison_layer, true)
	freeze = false
	sleeping = false
	select()
	if should_emit_signal: dropped.emit(self)

var player_ref:player
func initilize_holding(player_inp:player) -> void:
	player_ref = player_inp
	held = true
	set_collision_layer_value(item_collison_layer, false)
	freeze = true
	position = Vector3.ZERO
	rotation = Vector3(0, deg_to_rad(-90), 0)
	
func is_selected() -> bool: return selected

func select() -> void: 
	selected = true
	show()

func deselect() -> void:
	selected = false
	hide()
	
func is_held() -> bool: return held
