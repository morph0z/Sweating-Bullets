class_name bulletClass extends hitboxComponent

@export var SPEED: int = 20
@export var RANGE: int = 1000
var distanceTraveled: int
var direction:Vector3
var direction_overide:Vector3

func _physics_process(delta: float) -> void:
	#var direction = Vector2.RIGHT.rotated(rotation)
	direction = -transform.basis.x
	if direction_overide != Vector3.ZERO: direction = direction_overide
	
	self.position += direction * SPEED * delta
	distanceTraveled += 1
	if distanceTraveled > RANGE:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if ((body is entityClass) and (body != null)):
		var attack = Attack.new()
		attack.attack_damage = damage_dealt
		print("yo " + str(damage_dealt))
		attack.attack_position = self.position
		body.hurtBox.healthComponent_reference.damage(attack)

	queue_free()
