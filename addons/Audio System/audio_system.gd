@tool
@icon("res://addons/Audio System/headphonesIcon.svg")
extends EditorPlugin

func _enable_plugin() -> void:
	add_autoload_singleton("AudioSystem", "res://addons/Audio System/audio_system.tscn")

func _disable_plugin() -> void: 
	remove_autoload_singleton("AudioSystem")
