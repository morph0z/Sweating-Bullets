extends Control
@onready var label: Label = $Label
@export var player: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = str(player.state_machine.get_active_state())
