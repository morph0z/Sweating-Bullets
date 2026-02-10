class_name hitboxComponent extends Area3D

@export var damage_dealt:int
var _attack = Attack.new()

func set_attack_damage(amount:int): _attack.attack_damage = amount

func _ready() -> void: set_attack_damage(damage_dealt)

func _on_area_entered(area: Area3D) -> void:
	if area is not hurtboxComponent: return
	var hurtbox:hurtboxComponent = area
	hurtbox.healthComponent_reference.damage(_attack)
	print(hurtbox.healthComponent_reference.HEALTH)
