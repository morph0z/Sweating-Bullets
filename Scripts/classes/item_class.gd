@abstract
class_name item extends RigidBody3D

##True when the signals are conneted to the player.
var connectedToPlayer:bool = false

##The mesh of the item.
@export var mesh:MeshInstance3D

##True if the player is currently holding the item actively.
@export var selected:bool = false
##True if the player has the item in their inventory.
var held:bool = false

##Emitted when the item is picked up.
signal pickedUp(selfItem:item)
##Emitted when the item is dropped.
signal dropped(selfItem:item)

##Called when the player uses the item.
func _on_player_use_item() -> void: 
	#Function doesn't run if item is not selected.
	if !is_selected(): return
	use_item()

##Called when the player uses the item's secondary.
func _on_player_use_item_secondary() -> void: 
	#Function doesn't run if item is not selected.
	if !is_selected(): return
	use_item_secondary()

##The function of the item when used.
@abstract func use_item()

##The secondary function of the item when used.
@abstract func use_item_secondary()

##Connects the signals to the player.
func connect_on_use_item(entity:entityClass):
	if (connectedToPlayer): return
	entity.connect("UseItem", _on_player_use_item)
	entity.connect("UseItemSecondary", _on_player_use_item_secondary)
	connectedToPlayer = true

func _ready() -> void:
	if (get_parent() is heldItemComponent):
		var heldItem:heldItemComponent = get_parent()
		connect_on_use_item(heldItem.entity_ref)
		initilize_holding(heldItem.entity_ref)
		
	if (get_parent() is not heldItemComponent): initilize_dropped(false)

##Called when item is picked up.
func pick_item_up(player_inp:player) -> void:
	self.reparent(player_inp.held_items)
	connect_on_use_item(player_inp)
	initilize_holding(player_inp)
	pickedUp.emit(self)

##The collison layer for the item. (set to three because the collision mask for the item pickup shapecast is also 3)
@export var item_collison_layer:int = 3
func initilize_dropped(should_emit_signal:bool) -> void:
	held = false
	set_collision_layer_value(item_collison_layer, true)
	freeze = false
	sleeping = false
	select()
	if should_emit_signal: dropped.emit(self)

##The refrence to the entity holding the item.
var entity_ref:entityClass
##Called whenever the item is held.
func initilize_holding(entity:entityClass) -> void:
	entity_ref = entity
	held = true
	set_collision_layer_value(item_collison_layer, false)
	freeze = true
	position = Vector3.ZERO
	rotation = Vector3(0, deg_to_rad(-90), 0)

##Returns whether or not the item is currently selected.
func is_selected() -> bool: return selected

##Sets the item to being selected. 
func select() -> void: 
	selected = true
	show()

##Sets the item to being not selected. 
func deselect() -> void:
	selected = false
	hide()

##Returns whether or not the item is currently held.
func is_held() -> bool: return held
