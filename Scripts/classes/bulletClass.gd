class_name bulletClass extends hitboxComponent

##Speed of the bullet.
@export var SPEED: int = 20
##The max distance the bullet can travel.
@export var RANGE: int = 1000
##The current distance the bullet has traveled.
var distanceTraveled: int
##The vector direction of the bullet.
var direction:Vector3
##The overide of the bullet's direction. (Can be used for bounce)
var direction_overide:Vector3

func _physics_process(delta: float) -> void:
	#var direction = Vector2.RIGHT.rotated(rotation)
	
	#Direction moves forward relative to self
	direction = -transform.basis.x
	#Applies direction overide if not equal to zero
	if direction_overide != Vector3.ZERO: direction = direction_overide
	
	#Moves bullet
	self.position += direction * SPEED * delta
	distanceTraveled += 1
	
	#Destroys bullet when passes range
	if distanceTraveled > RANGE: queue_free()

##When the bullet enters a body.
func _on_body_entered(body: Node3D) -> void:
	#If the body that is entered is an entity, then the entity is damaged.
	if ((body is entityClass) and (body != null)):
		var attack = Attack.new()
		attack.attack_damage = damage_dealt
		attack.attack_position = self.position
		body.hurtBox.healthComponent_reference.damage(attack)
	
	#The bullet is destroyed after
	queue_free()
