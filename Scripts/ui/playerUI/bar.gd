class_name ui_bar
extends Label

##The full version of the bar.
@export var filledImage:Sprite2D
##Maximum fill.
var maxFill:float = 1
##Minimum fill.
var minFill:float = 0

##The previous value of the bar.
var lastAmount:float
##The current value of the bar.
var fillAmount:float

##Updates the bars visuals.
func update() -> void:
	assert(filledImage != null, "Set the filled image!")
	
	var bar_tween = get_tree().create_tween()
	bar_tween.set_ease(Tween.EASE_OUT)
	bar_tween.set_trans(Tween.TRANS_QUAD)
	bar_tween.tween_method(setCrop, lastAmount, fillAmount, 0.5)

##Sets the crop off the bar.
func setCrop(value:float):
	assert(filledImage != null, "Set the filled image!")

	var img_material:ShaderMaterial = filledImage.material
	img_material.set_shader_parameter("percentage", value)
