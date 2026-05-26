class_name playerSoundComponent
extends AudioStreamPlayer3D 

##Foot step sound variants.
@export var footstep_sounds: Array[AudioStreamWAV]

##Sound for the wall jump action.
@export var wall_jump:AudioStreamWAV

func footstep():
	stream = footstep_sounds.pick_random()
	pitch_scale = randf_range(0.9, 1.1)
	play()
	
func jump():
	stream = wall_jump
	pitch_scale = randf_range(0.8, 1.2)
	play()
