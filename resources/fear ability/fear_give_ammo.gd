extends fearAbility
class_name ammo_fear

##The amount of ammo that is given when fear is used to get ammo.
@export var ammo_increase:int

func do_ability() -> void: give_ammo()
	
##Gives ammo.
func give_ammo() -> void: player_ref.ammo_handler.increase_ammo(ammo_increase)
