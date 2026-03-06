class_name fearComponent extends Node

@export var player_ref:player
@export var max_fear:float
@export var fear_value:float

@export var ammo_increase:int

@export_category("Use Values")
@export var ammo_give_cost:int

func get_fear_amount() -> float: return fear_value

func give_ammo() -> void: player_ref.ammo_handler.increase_ammo(ammo_increase)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("CAmmoInc"): 
		if (fear_value < ammo_give_cost): return
		fear_value -= ammo_give_cost
		give_ammo()
