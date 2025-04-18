extends Control


func _ready() -> void:
	$MusicCheckBox.button_pressed = Global.is_music_mute # Responding whether the music is toggled on or off
	$SoundCheckBox.button_pressed = Global.is_sound_mute


func _on_music_check_box_toggled(toggled_on: bool) -> void:
	Global.is_music_mute = toggled_on # Saving the state of the toggle button
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), toggled_on)
	## For debugging
	#if toggled_on:
		#print("Music muted")
	#else:
		#print("Music not muted")


func _on_sound_check_box_toggled(toggled_on: bool) -> void:
	Global.is_sound_mute = toggled_on # Saving the state of the toggle button
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), toggled_on)
	#if toggled_on:
		#print("SFX muted")
	#else:
		#print("SFX not muted")
