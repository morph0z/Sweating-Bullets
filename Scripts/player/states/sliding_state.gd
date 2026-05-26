extends PlayerState

##How long the slide is active for in seconds.
@export var slidingLength:float = 0.5
##The amount of slides. Slowing down the slide over time to reduce spam.
var amountOfSlides:int = 0
##Emitted when done sliding.
signal doneSliding
##The cooldown before the amount of slides reset, allowing for a full power slide next.
@onready var sliding_cooldown: Timer = $"Sliding Cooldown"

func _enter() -> void:
	#machine.animationPlayer.play("WallRun")
	player_reference.crouchPostureCollision(true)
	player_reference.apply_force(player_reference.slide_velocity/(amountOfSlides+1), -player_reference.transform.basis.z)
	amountOfSlides += 1
	
	sliding_cooldown.start(slidingLength*2)
	
	await get_tree().create_timer(slidingLength).timeout
	var canStand = (!(Input.is_action_pressed("LeftShiftCrouch"))) and (player_reference.is_on_floor()) and (!(player_reference.crouch_check.is_colliding()))
	if canStand: set_state(player_reference.sprinting)
	elif !canStand: set_state(player_reference.crouching)
	
func _update(delta: float) -> void:
	player_reference.camera.update_camera_height(delta, true, 1)
	can_side_step()
	
	if Input.is_action_just_pressed("SpaceJump"):
		await doneSliding
		jump(1)

func _exit() -> void: doneSliding.emit()

func _on_sliding_cooldown_timeout() -> void: amountOfSlides = 0
