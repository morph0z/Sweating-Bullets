@icon("res://addons/Audio System/headphonesIcon.svg")
extends Node

#region audio groups
##Creates an audio group for similar types of audio to be added to. e.g SFX, MUSIC etc.
func create_audio_group(group_name:StringName) -> void:
	var new_group:AudioGroup = AudioGroup.new()
	
	new_group.name = group_name.to_snake_case().to_upper()
	add_child(new_group)
	new_group.bus_index = _new_audio_bus(new_group.name)

##Removes an existing audio group. Returns an error if the audio group trying to be removed doesn't exist.
func destroy_audio_group(group_name:StringName) -> void:
	var audio_type:AudioGroup = get_node(NodePath(group_name.to_snake_case().to_upper()))
	assert(audio_type, "Group doesn't exist!")
	
	_destroy_audio_bus(audio_type.bus_index)
	audio_type.queue_free()

##Returns the audio group node of the given group_name.
func get_audio_group(group_name:StringName) -> AudioGroup:
	for i in get_children():
		if i is AudioGroup and i.name == group_name.to_snake_case().to_upper():
			return i
	return null
#endregion

#region bus management
func _new_audio_bus(bus_name:StringName, bus_index:int = -1) -> int:
	var index:int = bus_index
	if bus_index == -1: index = AudioServer.bus_count
	
	AudioServer.add_bus(index)
	AudioServer.set_bus_name(index, bus_name)
	
	return index

func add_bus_effect(bus_index:int, effect:AudioEffect) -> void: AudioServer.add_bus_effect(bus_index, effect)

func _destroy_audio_bus(bus_index:int) -> void: AudioServer.remove_bus(bus_index)
#endregion

#region adding audio
##Not meant to be used outside.
func _add_audio(audio_name:StringName, audio_group:AudioGroup, audio_file:StringName, player, audio_volume:float = 0.5, audio_pitch:float = 1) -> Variant:
	assert(audio_group, "Group doesn't exist!")
	
	var audio = player.new()
	audio.name = audio_name.to_pascal_case()
	audio.stream = load(audio_file)
	audio.volume_db = linear_to_db(audio_volume)
	audio.pitch_scale = audio_pitch
	
	audio.bus = audio_group.name
	
	return audio

##Adds an AudioStreamPlayer to an audio group. For ui audio mostly.
func add_universal_audio(audio_name:StringName, audio_group:AudioGroup, audio_file:StringName, audio_volume:float = 0.5, audio_pitch:float = 1) -> void:
	var audio:AudioStreamPlayer = _add_audio(audio_name, audio_group, audio_file, AudioStreamPlayer, audio_volume, audio_pitch)
	audio_group.add_child(audio)

##Adds AudioStreamPlayers from a folder for batch audio adding.
func add_audio_from_folder(audio_group:AudioGroup, folder_path:StringName, player, audio_volume:float = 0.5, audio_pitch:float = 1) -> void:
	for i in DirAccess.get_files_at(folder_path):
		if i.contains(".import"): continue
		if !(i.contains(".wav") or i.contains(".mp3") or i.contains(".ogg")): continue
		var audio = _add_audio(i.split(".")[0], audio_group, folder_path + i, player, audio_volume, audio_pitch)
		audio_group.add_child(audio)

##Adds an AudioStreamPlayer2D to an audio group. For 2d game audio.
func add_2d_audio(audio_name:StringName, audio_group:AudioGroup, audio_file:StringName, audio_volume:float = 0.5, audio_pitch:float = 1,\
				  audio_max_distance:float = 2000, audio_attenuation:float = 1, audio_panning_strength:float = 1, audio_locational_position:Vector2 = Vector2(0,0)) -> void:
	
	var audio:AudioStreamPlayer2D = _add_audio(audio_name, audio_group, audio_file, AudioStreamPlayer2D, audio_volume, audio_pitch)
	
	audio.max_distance = audio_max_distance
	audio.attenuation = audio_attenuation
	audio.global_position = audio_locational_position
	audio.panning_strength = audio_panning_strength
	
	audio_group.add_child(audio)

##Adds an AudioStreamPlayer3D to an audio group. For 3d game audio. (P.s max volume is in Db!)
func add_3d_audio(audio_name:StringName, audio_group:AudioGroup, audio_file:StringName, audio_volume:float = 0.5, audio_pitch:float = 1,\
				  audio_attenuation_model:AudioStreamPlayer3D.AttenuationModel = AudioStreamPlayer3D.AttenuationModel.ATTENUATION_INVERSE_DISTANCE,\
				  audio_unit_size:float = 10, audio_max_volume:float = 3, audio_max_distance:float = 0, audio_panning_strength:float = 1, audio_locational_position:Vector3 = Vector3(0,0,0)) -> void:
	
	var audio:AudioStreamPlayer3D = _add_audio(audio_name, audio_group, audio_file, AudioStreamPlayer3D, audio_volume, audio_pitch)
	audio.attenuation_model = audio_attenuation_model
	audio.unit_size = audio_unit_size
	audio.max_db = audio_max_volume
	audio.max_distance = audio_max_distance
	audio.panning_strength = audio_panning_strength
	audio.global_position = audio_locational_position
	audio_group.add_child(audio)
#endregion

#region managing audio
##Returns an array with the audioStreamPlayer as the first value, and the type of audioStreamPlayer as the second value.
func get_audio(audio_name:StringName, audio_group:AudioGroup) -> Array:
	var arr:Array
	var audio = get_node(NodePath(str(audio_group.name + "/" + audio_name)))
	assert(audio, "Audio doesn't exist!")
	
	arr.append(audio)
	arr.append(audio.get_class())
	return arr

##Plays an audio.
func play_audio(audio_name:StringName, audio_group:AudioGroup, play_position:float = 0) -> void:
	var audio = get_node(NodePath(str(audio_group.name + "/" + audio_name)))
	assert(audio, "Audio doesn't exist!")

	assert(get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer2D"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer3D",\
	"Audio must be an AudioStreamPlayer!")
	
	audio.play(play_position)

func play_audio_random(audio_names:Array[StringName], audio_group:AudioGroup,\
					   pitch_range:Vector2 = Vector2(0.9, 1.1), volume_range:Vector2 = Vector2(0.4, 0.6)) -> void:
	
	for i in audio_names:
		var audio = get_node(NodePath(str(audio_group.name + "/" + i)))
		assert(audio, "Audio doesn't exist!")
	
	var random_audio:AudioStreamPlayer = get_node(NodePath(str(audio_group.name + "/" + audio_names.pick_random())))
	random_audio.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	random_audio.volume_linear = randf_range(volume_range.x, volume_range.y)
	
	random_audio.play()

##Stops the audio from playing.
func stop_audio(audio_name:StringName, audio_group:AudioGroup) -> void:
	var audio = get_node(NodePath(str(audio_group.name + "/" + audio_name)))
	assert(audio, "Audio doesn't exist!")
	
	assert(get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer2D"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer3D",\
	"Audio must be an AudioStreamPlayer!")
	
	audio.stop()

#region dynamic audio management
func fade_audio_in(audio_name:StringName, audio_group:AudioGroup, play_position:float = 0,\
				   starting_volume:float = 0, ending_volume:float = 0.5, fade_in_speed = 0.3):
	
	var audio = get_node(NodePath(str(audio_group.name + "/" + audio_name.to_pascal_case())))
	assert(audio, "Audio doesn't exist!")
	
	assert(get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer2D"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer3D",\
	"Audio must be an AudioStreamPlayer!")
	
	audio.volume_linear = starting_volume
	audio.play(play_position)
	var tween_volume:Tween = get_tree().create_tween()
	tween_volume.tween_property(audio, "volume_linear", ending_volume, fade_in_speed)
	
func fade_audio_out(audio_name:StringName, audio_group:AudioGroup,\
				   ending_volume:float = 0.5, fade_out_speed = 0.3):
	
	var audio = get_node(NodePath(str(audio_group.name + "/" + audio_name.to_pascal_case())))
	assert(audio, "Audio doesn't exist!")
	
	assert(get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer2D"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer3D",\
	"Audio must be an AudioStreamPlayer!")
	
	var tween_volume:Tween = get_tree().create_tween()
	tween_volume.tween_property(audio, "volume_linear", ending_volume, fade_out_speed)
	
	await tween_volume.finished
	audio.stop()

func layer_audio(audio_name:StringName, audio_group:AudioGroup, layer_on:StringName):
	var audio = get_node(NodePath(str(audio_group.name + "/" + audio_name)))
	assert(audio, "Audio doesn't exist!")
	
	var bottom_audio = get_node(NodePath(str(audio_group.name + "/" + layer_on)))
	assert(audio, "Audio doesn't exist!")
	
	assert(get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer2D"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer3D",\
	"Audio must be an AudioStreamPlayer!")
	
	assert(get_audio(bottom_audio.name, audio_group)[1] == "AudioStreamPlayer"\
	or get_audio(bottom_audio.name, audio_group)[1] == "AudioStreamPlayer2D"\
	or get_audio(bottom_audio.name, audio_group)[1] == "AudioStreamPlayer3D",\
	"Audio must be an AudioStreamPlayer!")
	
	audio.play(bottom_audio.get_playback_position())
#endregion

##Removes an audio from existance.
func remove_audio(audio_name:StringName, audio_group:AudioGroup) -> void:
	var audio := get_node(NodePath(str(audio_group.name + "/" + audio_name)))
	assert(audio, "Audio doesn't exist!")
	
	assert(get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer2D"\
	or get_audio(audio.name, audio_group)[1] == "AudioStreamPlayer3D",\
	"Audio must be an AudioStreamPlayer!")
	
	audio.queue_free()
#endregion
