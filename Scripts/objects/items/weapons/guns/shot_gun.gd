extends gun
class_name shot_gun

func use_item() -> void: buck_shot(BULLET, 5, 0.1)

func use_item_secondary() -> void: print("TODO: add a synergetic secondary")

#func throwHit(bullet:PackedScene, thing_hit:Node3D):
	#if thing_hit is not enemy: return
	#linear_velocity = linear_velocity*-1
	#await lazer_sight.EntityInSight
	#shoot(bullet)
