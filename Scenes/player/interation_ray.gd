class_name interation_ray extends ShapeCast3D
@onready var check_timer: Timer = $CheckTimer

signal ItemInSight(itemSeen:item)

func _process(_delta: float) -> void:
	if not is_colliding(): return
	if get_collider(0) is not item: return
	ItemInSight.emit(get_collider(0))
