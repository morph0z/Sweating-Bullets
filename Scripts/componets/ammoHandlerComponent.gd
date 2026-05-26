class_name ammoHandlerComponent extends Node

##The maximum amount of ammo that can be held total.
@export var max_ammo_amount:int = 20
##The current value of ammo held.
@export var ammo_amount:int

##Reduces the ammo amount by a certain amount.
func reduce_ammo(amount): 
	cap_ammo()
	ammo_amount -= amount

##Increases the ammo amount by a certain amount.
func increase_ammo(amount):
	ammo_amount += amount
	cap_ammo() 

##Gets the amount of ammo held.
func get_ammo_amount() -> int: return ammo_amount

##Caps the ammo between 0 and the maximum ammo amount.
func cap_ammo():
	var min_ammo = 0
	ammo_amount = clampi(ammo_amount, min_ammo, max_ammo_amount)
