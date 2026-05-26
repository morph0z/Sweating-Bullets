class_name heldItemComponent extends Node3D
##Refrence to the player.
@export var player_ref:player

@export_group("Settings")
##The maximum amount of items that can be held total.
@export var max_items_held:int = 3

@export_group("Config")
##The index of the item that is currently being selected.
@export var current_selected_item:int
##The array of items all being held.
@export var items_held:Array[item]

##Emitted when any item in items_held is dropped.
signal anyItemDropped(itemDropped:item)
##Emitted when any item is added to items_held.
signal anyItemPickedUp(itemPickedUp:item)
##Emitted when the currently selected item is switched to something else.
signal itemSwitched()

##This function updates the item index that is selected to be actually selected.
func update_selection() -> void:
	for held_item in items_held:
		if items_held.find(held_item) == current_selected_item-1: held_item.select() 
		if items_held.find(held_item) != current_selected_item-1: held_item.deselect() 

##The value of going back in the list relative to current_selected_item.
var back_one_item:int = 2
func _input(event: InputEvent) -> void:
	update_selection()
	
	if event.is_action_pressed("ScrollWeaponUp"):
		if Global.does_element_exist_at_index(items_held, current_selected_item):
			current_selected_item += 1
		itemSwitched.emit()
			
	if event.is_action_pressed("ScrollWeaponDown"):
		if Global.does_element_exist_at_index(items_held, current_selected_item-back_one_item):
			current_selected_item -= 1
		itemSwitched.emit()

	update_selection()

func _ready() -> void:
	#Adds every item that is a child to the items_held
	for itemChild:item in get_children(): 
		items_held.append(itemChild)
		connect_item_dropping(itemChild)

##Called when an item is dropped.
func _on_item_dropped(itemDropped:item) -> void:
	update_selection()
	var last_item_held_id:int = items_held.find(itemDropped)
	items_held.remove_at(items_held.find(itemDropped))
	if Global.does_element_exist_at_index(items_held, last_item_held_id + 1): current_selected_item = last_item_held_id + 2
	elif Global.does_element_exist_at_index(items_held, last_item_held_id): current_selected_item = last_item_held_id + 1
	elif Global.does_element_exist_at_index(items_held, last_item_held_id - 1): current_selected_item = last_item_held_id
	anyItemDropped.emit(itemDropped)
	update_selection()

#func _on_player_item_thrown(thrownItem: item) -> void: _on_item_dropped(thrownItem)

func connect_item_dropping(connected: item) -> void: connected.connect("dropped", _on_item_dropped, 4)

##Sets the currently selected item to an item using the index.
func set_selected_item(selectItemIndex:int) -> void:
	#Sets it to current selected item
	current_selected_item = selectItemIndex + 1
	update_selection()
	#Diselects anything thats not it.
	for itemHeld:item in get_children():
		if get_children().find(itemHeld) != selectItemIndex: itemHeld.deselect()

##Gets the currently selected item.
func get_selected_item() -> item:
	for held_item in items_held:
		if items_held.find(held_item) == current_selected_item-1: return held_item
	return null

	#for item_held in items_held: if item_held.is_selected(): return item_held
	#return null

##Picks up an item.
func pick_item_up(pickedItem:item) -> void:
	pickedItem.reparent(self)
	pickedItem.connect_on_use_item(player_ref)
	pickedItem.initilize_holding(player_ref)
	#Adds to list
	items_held.append(pickedItem)
	#Sets it to current selected item
	set_selected_item(items_held.find(pickedItem))
	anyItemPickedUp.emit(pickedItem)

	if (items_held.size() > max_items_held):
		#Removes first item.
		set_selected_item(0)
		player_ref.throwItem(1)
		#Sets the selected item to the new item.
		set_selected_item(items_held.find(pickedItem))

func _on_interation_ray_item_in_sight(itemSeen: item) -> void:
	if Input.is_action_just_pressed("EnterThrow"):
		pick_item_up(itemSeen)
		connect_item_dropping(itemSeen)
