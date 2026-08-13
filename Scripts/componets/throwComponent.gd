extends Node
class_name throwComponent

@export var player_ref:player
@export var held_items:heldItemComponent
@export var interaction_raycast:ShapeCast3D

@export var throw_keybind:StringName = &"EnterThrow"
@export var throw_strength:float = 5

##Emitted when the player throws an item.
signal ItemThrown(thrownItem:item)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(throw_keybind): throwItem(throw_strength)

##Throws the currently held item.
func throwItem(force:float) -> void:
	var itemThrown:item
	var itemThrownIndex:int
	for itemHeld:item in held_items.get_children(): if itemHeld.is_selected(): 
		itemThrownIndex = held_items.get_children().find(itemHeld)
		itemThrown = itemHeld
	if (!(itemThrown is item) or !(itemThrown.is_selected())): return
	itemThrown.initilize_dropped(true)
	for node in get_tree().get_root().get_children(): if node is level: itemThrown.reparent(node)
	
	itemThrown.apply_impulse(player_ref.transform.basis *\
							 player_ref.camera.transform.basis *\
							 Vector3(0,force*0.1,-force))
	itemThrown.angular_velocity = player_ref.transform.basis * Vector3(-10*force,0,0)
	
	var nextItem:item
	if !held_items.get_children().is_empty():
		for itemHeld in held_items.get_children(): nextItem = held_items.get_children()[itemThrownIndex-1]
		nextItem.select()
	
	player_ref.set_collision_layer_value(3, true)
	await get_tree().create_timer(0.1).timeout
	player_ref.set_collision_layer_value(3, false)
	
	ItemThrown.emit(itemThrown)
