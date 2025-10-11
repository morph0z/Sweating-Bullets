class_name gunClass extends RigidBody3D
const BASIC_BULLET = preload("res://Scenes/objects/weapons/Ammo/BasicBullet.tscn")
@onready var playerReference = get_tree().get_root().get_child(1).get_node("Player")
@export var hitboxComponentReference: hitboxComponent
@onready var UseItem:Signal
@onready var shoot_point: Marker3D = $shootPoint


@onready var OnUseItemLam = func _on_use_item():
	if get_parent().name == "HeldItem":
			var newBullet = BASIC_BULLET.instantiate()
			newBullet.position = shoot_point.global_position
			newBullet.rotation = shoot_point.global_rotation
			get_tree().get_root().add_child(newBullet)
		
func _ready() -> void:
	if playerReference is player:
		UseItem = playerReference.UseItem
		UseItem.connect(OnUseItemLam)
	
func _on_pick_up_box_area_entered(area: Area3D) -> void:
	if area.name == "PickUpItemBox":
		var canBePickedUp = area.get_parent().held_item.get_children().size() == 0
		if canBePickedUp:
			reparent(area.get_parent().held_item)
			rotation = Vector3.ZERO
			position = Vector3.ZERO
	
	if area is hurtboxComponent:
		if !(area.get_parent().get_parent() is player):
			OnUseItemLam.call()
