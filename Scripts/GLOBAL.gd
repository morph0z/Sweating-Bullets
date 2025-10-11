class_name GameManager extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("EscapePause"):
		get_tree().quit()
	if event.is_action_pressed("F2ReloadScene"):
		get_tree().reload_current_scene()
