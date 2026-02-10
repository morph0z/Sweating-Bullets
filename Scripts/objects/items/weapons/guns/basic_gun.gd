extends gun
# Called when the node enters the scene tree for the first time.

func override_bullet() -> void: BASIC_BULLET = preload("res://Scenes/objects/weapons/Ammo/BasicBullet.tscn")

func shoot(bullet:PackedScene) -> void: create_bullet(bullet, 10)

func use_item() -> void: shoot(BASIC_BULLET)

func throwHit(bullet:PackedScene, thing_hit:Node3D):
	if thing_hit is not enemy: return
	linear_velocity = linear_velocity*-1
	await lazer_sight.EntityInSight
	shoot(bullet)
