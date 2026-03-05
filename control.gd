extends Control
@onready var label: Label = $Label
@export var playerRef: player
@export var debug: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if debug:
		label.text = "<" + str(playerRef.state_machine.get_active_state()) +"
		 <Health = "+str(playerRef.health_component.HEALTH)+">
		 <Fps: "+str(Engine.get_frames_per_second())+">
		 <Velocity:"+str(round(playerRef.velocity.length()))+">
		 <Wanted Velocity:"+str(round(playerRef._wanted_velocity.length()))+">
		 <Amount Of Slides:"+str(round(playerRef.sliding.amountOfSlides))+">
		 <Current Item Id:"+str(playerRef.held_items.current_selected_item)+">
		 <Ammo amount:"+str(playerRef.ammo_handler.get_ammo_amount())+">"
	elif !debug:
		label.text = ""
