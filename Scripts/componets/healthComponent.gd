class_name healthComponent extends Node

##The refrence to the entity using the health.
@export var Entity: entityClass
##The amount of health the entity currently has.
@export var HEALTH: int = 100

##The initial amount of health that is had.
var intital_health: float

##Emitted when the health is changed.
signal healthChanged(amount: int)

##Are you dumb?
var isDead = false

func _ready() -> void: intital_health = HEALTH

##Reduces the health and does other stuff (Not yet) taking in an attack class as an arg.
func damage(attack: Attack) -> void:
	HEALTH -= attack.attack_damage
	healthChanged.emit(-attack.attack_damage)
	if HEALTH >= 0: return
	dead()

##Destroys the entity.
func dead() -> void:
	HEALTH = 0
	if Entity is not player:
		Entity.queue_free()
		return
	isDead = true
