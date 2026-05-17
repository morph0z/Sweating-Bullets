class_name ui_bar
extends Label

@export var filledImage:Sprite2D
var maxFill:float = 1
var minFill:float = 0

var lastAmount:float
var fillAmount:float

func update() -> void:
	assert(filledImage != null, "Set the filled image!")
	
	var bar_tween = get_tree().create_tween()
	bar_tween.set_ease(Tween.EASE_OUT)
	bar_tween.set_trans(Tween.TRANS_QUAD)
	bar_tween.tween_method(setCrop, lastAmount, fillAmount, 0.5)

func setCrop(value:float):
	assert(filledImage != null, "Set the filled image!")

	var img_material:ShaderMaterial = filledImage.material
	img_material.set_shader_parameter("percentage", value)
