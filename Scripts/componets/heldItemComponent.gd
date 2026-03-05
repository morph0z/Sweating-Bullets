class_name heldItemComponent extends Node3D
@export var player_ref:player

@export var current_selected_item:int
@export var items_held:Array[item]

func update_selection() -> void:
	for held_item in items_held:
		if items_held.find(held_item) == current_selected_item-1: held_item.select() 
		if items_held.find(held_item) != current_selected_item-1: held_item.deselect() 

var back_one_item:int = 2
func _input(event: InputEvent) -> void:
	update_selection()
	
	if event.is_action_pressed("ScrollWeaponUp"):
		if Global.does_element_exist_at_index(items_held, current_selected_item):
			current_selected_item += 1
	if event.is_action_pressed("ScrollWeaponDown"): 
		if Global.does_element_exist_at_index(items_held, current_selected_item-back_one_item):
			current_selected_item -= 1
	
	update_selection()

func _ready() -> void:
	for itemChild:item in get_children(): 
		items_held.append(itemChild)
		connect_item(itemChild)
		
	for node in get_tree().get_root().get_children():
		if node is level: for thing in node.get_children():
			if thing is item: connect_item(thing)

func _on_item_picked_up(itemPicked:item) -> void:
	items_held.append(itemPicked)
	current_selected_item = items_held.find(itemPicked) + 1
	update_selection()
	for itemHeld:item in get_children():
		if itemHeld != itemPicked:
			itemHeld.deselect()

func _on_item_dropped(itemDropped:item) -> void:
	update_selection()
	var last_item_held_id:int = items_held.find(itemDropped)
	items_held.remove_at(items_held.find(itemDropped))
	if Global.does_element_exist_at_index(items_held, last_item_held_id + 1): current_selected_item = last_item_held_id + 2
	elif Global.does_element_exist_at_index(items_held, last_item_held_id): current_selected_item = last_item_held_id + 1
	elif Global.does_element_exist_at_index(items_held, last_item_held_id - 1): current_selected_item = last_item_held_id
	update_selection()

#func _on_player_item_thrown(thrownItem: item) -> void: _on_item_dropped(thrownItem)

func connect_item(connected: item):
	connected.connect("pickedUp", _on_item_picked_up)
	connected.connect("dropped", _on_item_dropped)

func get_selected_item() -> item:
	for item_held in items_held: if item_held.is_selected(): return item_held
	return null
