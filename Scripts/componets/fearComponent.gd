class_name fearComponent extends Node

##Reference to the player.
@export var player_ref:player
##The maximum amount of fear that can be held.
@export var max_fear:float
##The current fear value that is held.
@export var fear_value:float

##The amount of ammo that is given when fear is used to get ammo.
@export var ammo_increase:int

@export_category("Use Values")
##The cost of fear that must be used to get ammo.
@export var ammo_give_cost:int

##Emitted when the amount of fear held is changed.
signal fearChanged(amount: int)

##Returns the current amount of fear.
func get_fear_amount() -> float: return fear_value

##Gives ammo.
func give_ammo() -> void: 
	player_ref.ammo_handler.increase_ammo(ammo_increase)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("CFearUseA"):
		if (fear_value < ammo_give_cost): return
		changeFear(ammo_give_cost)
		give_ammo()

##Reduces the fear by a given amount.
func changeFear(amount:int):
	fearChanged.emit(-amount)
	fear_value -= amount
