class_name railNode
extends PathFollow3D

signal reached_end
signal reached_start

var end_threshold:float = 0.01

var speed:float = 10

@onready var forward = true
var grinding = false
var init_progress_ratio:float

func set_up() -> void:
	init_progress_ratio = progress_ratio

func _process(delta: float) -> void:
	if !grinding: return
	
	if forward: progress += speed * delta
	elif !forward: progress -= speed * delta
	
	if progress_ratio >= 1 - (end_threshold * 0.1): reached_end.emit()
	if progress_ratio <= 0 + (end_threshold * 0.1): reached_start.emit()
