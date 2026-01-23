class_name bulletClass extends hitboxComponent

@export var SPEED: int = 20
@export var RANGE: int = 1000
var distanceTraveled: int
var direction:Vector3

func _physics_process(delta: float) -> void:
	#var direction = Vector2.RIGHT.rotated(rotation)
	direction = -transform.basis.x
	self.position += direction * SPEED * delta
	distanceTraveled += 1
	if distanceTraveled > RANGE:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body is CSGBox3D:
		if !body.is_in_group("BulletCanBounce"):
			queue_free()
		elif body.is_in_group("BulletCanBounce"):
			direction = direction.bounce(direction)
