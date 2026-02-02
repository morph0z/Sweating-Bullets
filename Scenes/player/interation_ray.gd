class_name interation_ray extends RayCast3D
@onready var check_timer: Timer = $CheckTimer

signal ItemInSight(itemSeen:item)

func _process(delta: float) -> void:
	if is_colliding():
		if get_collider() is item:
			ItemInSight.emit(get_collider())
