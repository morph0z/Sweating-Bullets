class_name fearComponent extends Node

##Reference to the player.
@export var player_ref:player
##The maximum amount of fear that can be held.
@export var max_fear:float
##The current fear value that is held.
@export var fear_value:float

@export var fear_abilities:Array[fearAbility]

func _ready() -> void:
	for fear_ability in fear_abilities:
		fear_ability.initilize_fear(player_ref, self)

##Emitted when the amount of fear held is changed.
signal fearChanged(amount: int)

##Returns the current amount of fear.
func get_fear_amount() -> float: return fear_value

##Reduces the fear by a given amount.
func changeFear(amount:int):
	fearChanged.emit(-amount)
	fear_value -= amount

func _input(event: InputEvent) -> void:
	for fear_ability in fear_abilities:
		if event.is_action_pressed(fear_ability.keyBind):
			if (fear_value < fear_ability.fearCost): return
			changeFear(fear_ability.fearCost)
			fear_ability.do_ability()
