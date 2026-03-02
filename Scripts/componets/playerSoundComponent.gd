class_name playerSoundComponent
extends AudioStreamPlayer3D 

@export var footstep_1:AudioStreamWAV
@export var footstep_2:AudioStreamWAV
@export var footstep_3:AudioStreamWAV
@export var footstep_4:AudioStreamWAV

@export var wall_jump:AudioStreamWAV


# Called when the node enters the scene tree for the first time.
func footstep():
	var footstep_sounds: Array[AudioStreamWAV]
	footstep_sounds.append(footstep_1)
	footstep_sounds.append(footstep_2)
	footstep_sounds.append(footstep_3)
	footstep_sounds.append(footstep_4)
	
	stream = footstep_sounds.pick_random()
	pitch_scale = randf_range(0.9, 1.1)
	play()
	

func jump():
	stream = wall_jump
	pitch_scale = randf_range(0.8, 1.2)
	play()
