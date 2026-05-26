class_name entityClass extends CharacterBody3D
##The hurtbox of the entity.
@export var hurtBox:hurtboxComponent

@warning_ignore("unused_signal")
##Emitted when the item is used by the entity.
signal UseItem

@warning_ignore("unused_signal")
##Emitted when the secondary is used by the entity.
signal UseItemSecondary
