class_name animationComponent
extends Node

@export_group("References")
##The reference to the player.
@export var player_reference: player
##The reference to the animation tree.
@export var animationTree: AnimationTree
##The reference to the animation player.
@export var animationPlayer: AnimationPlayer

##Wether or not the arm animations are active.
@export var armAnimationActive:bool = true

##The value of the sprint animation mixing.
@export var sprintAniValue:float
##The value of the airbourn animation mixing.
@export var airbornAniValue:float
##The value of the wall run right animation mixing.
@export var wallrunRAniValue:float
##The value of the wall run left animation mixing.
@export var wallrunLAniValue:float
##The value of the hold item animation mixing.
@export var holdItemAniValue:float

##The speed of the animation blending into another.
@export var animationBlendSpeed:float = 15

##The current state of the player.
@onready var activeState:PlayerState = player_reference.state_machine.get_active_state()

##Plays an animation for any held item types.
func holdItem(itemType:item):
	if itemType is gun: animationPlayer.play("holdPistol")

##Updates the animation tree with new values.
func update_animTree():
	animationTree["parameters/Sprint/blend_amount"] = sprintAniValue
	animationTree["parameters/Airbourn/blend_amount"] = airbornAniValue
	animationTree["parameters/WallRunRight/blend_amount"] = wallrunRAniValue
	animationTree["parameters/WallRunLeft/blend_amount"] = wallrunLAniValue
	animationTree["parameters/HoldItem/blend_amount"] = holdItemAniValue

##Changes the animation based on the players current state.
func handle_animation(delta:float):
	var wallRunAniBool:bool = (activeState == player_reference.wallRunning) or (activeState == player_reference.sliding)
	var idleAniBool:bool = (activeState == player_reference.walking) or (activeState == player_reference.moving) or (activeState == player_reference.crouching) or (activeState == player_reference.idle)
	var isHoldingItem:bool = player_reference.held_items.get_selected_item() != null
	var blendingSpeed:float = animationBlendSpeed*delta
	if  idleAniBool:
		sprintAniValue = lerpf(sprintAniValue, 0, blendingSpeed)
		wallrunRAniValue = lerpf(wallrunRAniValue, 0, blendingSpeed)
		airbornAniValue = lerpf(airbornAniValue, 0, blendingSpeed)
	if activeState == player_reference.sprinting:
		sprintAniValue = lerpf(sprintAniValue, 1, blendingSpeed)
		wallrunRAniValue = lerpf(wallrunRAniValue, 0, blendingSpeed)
		airbornAniValue = lerpf(airbornAniValue, 0, blendingSpeed)
	if activeState == player_reference.airborne:
		sprintAniValue = lerpf(sprintAniValue, 0, blendingSpeed)
		wallrunRAniValue = lerpf(wallrunRAniValue, 0, blendingSpeed)
		airbornAniValue = lerpf(airbornAniValue, 1, blendingSpeed)
	if wallRunAniBool:
		sprintAniValue = lerpf(sprintAniValue, 0, blendingSpeed)
		wallrunRAniValue = lerpf(wallrunRAniValue, 1, blendingSpeed)
		airbornAniValue = lerpf(airbornAniValue, 0, blendingSpeed)
	if isHoldingItem:
		holdItemAniValue = lerpf(holdItemAniValue, 1, blendingSpeed)
		
		var heldItem = player_reference.held_items.get_selected_item()
		if heldItem is pistol: animationTree["parameters/HoldingItem/blend_position"] = Vector2(1, 0)
		if heldItem is shot_gun: animationTree["parameters/HoldingItem/blend_position"] = Vector2(0, 0)
	#TODO: Add throwing animation
	if !isHoldingItem: holdItemAniValue = lerpf(holdItemAniValue, 0, blendingSpeed/5)
		
func _process(delta: float) -> void:
	#match player_reference.held_items.get_child_count():
		#1:
			#armAnimationActive = false
			#player_reference.camera.arms.hide()
		#0:
			#armAnimationActive = true
			#player_reference.camera.arms.show()
			
			
	activeState = player_reference.state_machine.get_active_state()
	if armAnimationActive:
		update_animTree()
		handle_animation(delta)
