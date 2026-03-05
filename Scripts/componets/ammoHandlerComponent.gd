class_name ammoHandlerComponent extends Node

@export var max_ammo_amount:int
@export var ammo_amount:int

func reduce_ammo(amount): 
	cap_ammo()
	ammo_amount -= amount

func increase_ammo(amount):
	cap_ammo() 
	ammo_amount += amount

func get_ammo_amount() -> int: return ammo_amount

func cap_ammo():
	var min_ammo = 0
	ammo_amount = clampi(ammo_amount, min_ammo, max_ammo_amount)
