class_name animationComponent
extends Node
@export var player_reference: player
@export var animationTree: AnimationTree
@export var animationPlayer: AnimationPlayer

@export var armAnimationActive:bool = true

@export var sprintAniValue:float
@export var airbornAniValue:float
@export var wallrunRAniValue:float
@export var wallrunLAniValue:float

@export var animationBlendSpeed:float = 15

@onready var activeState:PlayerState = player_reference.state_machine.get_active_state()

func holdItem(itemType:item):
	if itemType is gun:
		animationPlayer.play("holdGun")

func update_animTree():
	animationTree["parameters/Sprint/blend_amount"] = sprintAniValue
	animationTree["parameters/Airbourn/blend_amount"] = airbornAniValue
	animationTree["parameters/WallRunRight/blend_amount"] = wallrunRAniValue
	animationTree["parameters/WallRunLeft/blend_amount"] = wallrunLAniValue

func handle_animation(delta:float):
	var wallRunAniBool:bool = (activeState == player_reference.wallRunning) or (activeState == player_reference.sliding)
	var idleAniBool:bool = (activeState == player_reference.walking) or (activeState == player_reference.moving) or (activeState == player_reference.crouching) or (activeState == player_reference.standing)
	if  idleAniBool:
		sprintAniValue = lerpf(sprintAniValue, 0, animationBlendSpeed*delta)
		wallrunRAniValue = lerpf(wallrunRAniValue, 0, animationBlendSpeed*delta)
		airbornAniValue = lerpf(airbornAniValue, 0, animationBlendSpeed*delta)
	if activeState == player_reference.sprinting:
		sprintAniValue = lerpf(sprintAniValue, 1, animationBlendSpeed*delta)
		wallrunRAniValue = lerpf(wallrunRAniValue, 0, animationBlendSpeed*delta)
		airbornAniValue = lerpf(airbornAniValue, 0, animationBlendSpeed*delta)
	if activeState == player_reference.airborne:
		sprintAniValue = lerpf(sprintAniValue, 0, animationBlendSpeed*delta)
		wallrunRAniValue = lerpf(wallrunRAniValue, 0, animationBlendSpeed*delta)
		airbornAniValue = lerpf(airbornAniValue, 1, animationBlendSpeed*delta)
	if wallRunAniBool:
		sprintAniValue = lerpf(sprintAniValue, 0, animationBlendSpeed*delta)
		wallrunRAniValue = lerpf(wallrunRAniValue, 1, animationBlendSpeed*delta)
		airbornAniValue = lerpf(airbornAniValue, 0, animationBlendSpeed*delta)
		
func _process(delta: float) -> void:
	match player_reference.held_items.get_child_count():
		1:
			armAnimationActive = false
			player_reference.camera.arms.hide()
		0:
			armAnimationActive = true
			player_reference.camera.arms.show()
		
	activeState = player_reference.state_machine.get_active_state()
	if armAnimationActive:
		update_animTree()
		handle_animation(delta)
