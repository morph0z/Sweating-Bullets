extends Resource
class_name fearAbility

var player_ref:player
var fear_comp:fearComponent

@export var keyBind:StringName
@export var fearCost:int

func initilize_fear(player_reference:player, fear_component:fearComponent) -> void:
	player_ref = player_reference
	fear_comp = fear_component

func do_ability() -> void:
	assert(false, "Dont use the base one. It does nothing!")
