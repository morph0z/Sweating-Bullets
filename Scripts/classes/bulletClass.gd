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

func _on_body_entered(_body: Node3D) -> void:
	queue_free()
