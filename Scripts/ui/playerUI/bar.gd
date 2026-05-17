class_name ui_bar
extends Control

@export var filledImage:Sprite2D
var maxFill:float = 1
var minFill:float = 0

var fillAmount:float

func update() -> void:
	var img_material = filledImage.material
	if img_material is ShaderMaterial:
		img_material.set_shader_parameter("shader_paramater/Percentage", 0.5)
		print(img_material.get_shader_parameter("shader_paramater/Percentage"))
