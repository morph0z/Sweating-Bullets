class_name healthComponent extends Node

@export var Entity: entityClass
@export var HEALTH: int = 100

var intital_health: float

signal healthChanged(amount: int)

var isDead = false

func _ready() -> void: intital_health = HEALTH

func damage(attack: Attack):
	HEALTH -= attack.attack_damage
	healthChanged.emit(-attack.attack_damage)
	if HEALTH >= 0: return
	dead()

func dead():
	HEALTH = 0
	if Entity is not player:
		Entity.queue_free()
		return
	isDead = true
