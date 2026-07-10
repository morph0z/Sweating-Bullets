class_name animationComponent
extends Node

@export_group("References")
##The reference to the player.
@export var player_reference: player
##The reference to the animation tree.
@export var animationTree: AnimationTree
##The reference to the animation player.
@export var animationPlayer: AnimationPlayer

@export_group("Settings")
##Wether or not the arm animations are active.
@export var armAnimationActive:bool = true

##The current state of the player.
@onready var activeState:PlayerState = player_reference.state_machine.get_active_state()

enum GunSizeState{
	SmallGun=0,
	LargeGun=1
}

enum GunHoldingState{
	None=0,
	Held=1,
}

enum MovementState{
	Idle=0,
	Sprinting=1,
	InAir=2,
	Sliding=3
}

var MovementStateVectorPoints:Array[Vector2] = [
	Vector2(0,0),
	Vector2(1,1),
	Vector2(0,1),
	Vector2(2,0)
]

var currentMovementState:MovementState = MovementState.Idle
var currentMovementVector:Vector2 = MovementStateVectorPoints[currentMovementState]

var currentGunHolding:float = GunHoldingState.None
var currentGunSize:float = GunSizeState.SmallGun

var currentShooting:bool = false

##Updates the animation tree with new values.
func update_animTree():
	animationTree["parameters/Movement/blend_position"] = currentMovementVector
	animationTree["parameters/HoldingGun/blend_amount"] = currentGunHolding
	animationTree["parameters/GunSize/blend_amount"] = currentGunSize
	
	animationTree["parameters/SmallGun/blend_position"] = int(currentShooting)
	animationTree["parameters/LargeGun/blend_position"] = int(currentShooting)

func set_movementAnimation(animation:MovementState, speed:float = 0.2):
	var movementAnimationTween:Tween = get_tree().create_tween()
	movementAnimationTween.tween_property(self, "currentMovementVector", MovementStateVectorPoints[animation], speed)

func set_holdingAnimation(holding:int, large_small:int):
	var holdingAnimationTween:Tween = get_tree().create_tween()
	#currentGunHolding = holding
	holdingAnimationTween.tween_property(self, "currentGunHolding", holding, 0.2)
	holdingAnimationTween.tween_property(self, "currentGunSize", large_small, 0.2)
	#print(currentGunHolding)

##Changes the animation based on the players current state.
func handle_animation(_delta:float):
	var wallRunAniBool:bool = (activeState == player_reference.wallRunning) or (activeState == player_reference.sliding)
	var sprintAniBool:bool = (activeState == player_reference.sprinting)
	var airAniBool:bool = (activeState == player_reference.airborne)
	var idleAniBool:bool = (activeState == player_reference.walking) or (activeState == player_reference.moving) or (activeState == player_reference.crouching) or (activeState == player_reference.idle)
	
	var isHoldingItem:bool = player_reference.held_items.get_selected_item() != null

	if wallRunAniBool: set_movementAnimation(MovementState.Sliding)
	elif idleAniBool: set_movementAnimation(MovementState.Idle)
	elif sprintAniBool: set_movementAnimation(MovementState.Sprinting)
	elif airAniBool: set_movementAnimation(MovementState.InAir)


	if isHoldingItem:
		var heldItem:item = player_reference.held_items.get_selected_item()
		if heldItem.is_in_group("SmallGun"): set_holdingAnimation(GunHoldingState.Held, GunSizeState.SmallGun)
		if heldItem.is_in_group("LargeGun"): set_holdingAnimation(GunHoldingState.Held, GunSizeState.LargeGun)
	#TODO: Add throwing animation
	if !isHoldingItem: set_holdingAnimation(GunHoldingState.None, GunSizeState.SmallGun)
		
func _process(delta: float) -> void:
	if !armAnimationActive: return
	update_animTree()
	handle_animation(delta)

func _on_limbo_hsm_active_state_changed(current: LimboState, _previous: LimboState) -> void:
	activeState = current
