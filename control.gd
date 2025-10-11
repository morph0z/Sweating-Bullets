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
		label.text = str(playerRef.state_machine.get_active_state()) +" <Health = "+str(playerRef.health_component.HEALTH)+">  <Fps: "+str(Engine.get_frames_per_second())+">"
	elif !debug:
		label.text = ""
