class_name lazer_sight_ray extends RayCast3D

signal EntityInSight(entity:entityClass)

func _process(_delta: float) -> void:
	if not is_colliding(): return
	if get_collider() is not entityClass: return
	EntityInSight.emit(get_collider())
