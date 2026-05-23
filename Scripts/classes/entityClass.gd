class_name entityClass extends CharacterBody3D
##The hurtbox of the entity.
@export var hurtBox:hurtboxComponent

##Emitted when the item is used by the entity.
signal UseItem
##Emitted when the secondary is used by the entity.
signal UseItemSecondary
