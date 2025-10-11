class_name hitboxComponent extends Area3D

@export var damage_dealt:int
var _attack = Attack.new()

func _ready() -> void:
	_attack.attack_damage = damage_dealt



func _on_area_entered(area: Area3D) -> void:
	if area is hurtboxComponent:
		area.healthComponent_reference.damage(_attack)
		print("PAIN")
