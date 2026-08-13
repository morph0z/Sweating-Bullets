class_name GameManager extends Node

func _ready() -> void:
	init_audio_groups()

func init_audio_groups() -> void:
	AudioSystem.create_audio_group("SFX")
	AudioSystem.create_audio_group("Music")
	AudioSystem.create_audio_group("Ambient")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("EscapePause"): get_tree().quit()
	if event.is_action_pressed("F2ReloadScene"): get_tree().reload_current_scene()

##Checks if an item is in an array.
func does_element_exist(array: Array, element: Object) -> bool:
	if array.is_empty(): return false
	for i in array: if i == element: return true
	return false

##Checks if an element exists at a given index.
func does_element_exist_at_index(array: Array, index: int) -> bool:
	if array.is_empty(): return false
	for i in array: if array.find(i) == index:
		if i != null: return true
		if i == null: return false
	return false
