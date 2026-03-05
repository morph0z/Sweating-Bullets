class_name enemy extends entityClass
@export var hurtbox:hurtboxComponent
@export var view_range:Area3D
@export var Be_Tree_Player:BTPlayer

var player_ref:player

func _ready() -> void: view_range.connect("body_entered", on_body_entered)
	
func on_body_entered(body:Node3D) -> void:
	if !(body is player): return
	player_ref = body
	Be_Tree_Player.blackboard.set_var("player_ref", player_ref)
