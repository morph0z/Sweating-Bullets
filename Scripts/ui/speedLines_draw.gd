extends CanvasLayer
@export var playerRefrence:player

@export var speed_effect_color_rect:ColorRect

func _process(_delta: float) -> void:
	calculate_line_scale()
	
func apply_effect(value:float) -> void:
	speed_effect_color_rect.material.set_shader_parameter('effect_power', abs(value))

func calculate_line_scale():
	var ForwardVelocity = playerRefrence.velocity * (playerRefrence.transform.basis * Vector3(0, 0, 1)).normalized()/15
	apply_effect(clampf(-ForwardVelocity.dot(Vector3(1,0,1)), 0, 1))
