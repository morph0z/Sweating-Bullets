class_name hitboxComponent extends Area3D

##Damage done by the hitbox.
@export var damage_dealt:int
##The attack instance of the hitbox.
var _attack = Attack.new()

##Sets the attack damage of the hitbox.
func set_attack_damage(amount:int): _attack.attack_damage = amount

func _ready() -> void: set_attack_damage(damage_dealt)

##Called when an area hits the hitbox
func _on_area_entered(area: Area3D) -> void:
	if area is not hurtboxComponent: return
	var hurtbox:hurtboxComponent = area
	hurtbox.healthComponent_reference.damage(_attack)
	print(hurtbox.healthComponent_reference.HEALTH)
