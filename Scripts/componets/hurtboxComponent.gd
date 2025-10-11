class_name hurtboxComponent extends Area3D

@export var healthComponent_reference:healthComponent

#func _process(_delta: float) -> void:
	#print(healthComponent_reference.HEALTH)
