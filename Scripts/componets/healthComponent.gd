class_name healthComponent extends Node

@export var Entity: Node3D
@export var StateMachine: LimboHSM
@export var HEALTH: int = 100

var isDead = false

func damage(attack: Attack):
	HEALTH -= attack.attack_damage
	if HEALTH >= 0: return
	dead()

func dead():
	HEALTH = 0
	if Entity is not player: return
	isDead = true
