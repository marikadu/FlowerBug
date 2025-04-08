extends Control


func _ready() -> void:
	$MusicCheckBox.button_pressed = Global.is_music_mute # responding whether the music is toggled on or off
	$SoundCheckBox.button_pressed = Global.is_sound_mute


func _on_music_check_box_toggled(toggled_on: bool) -> void:
	Global.is_music_mute = toggled_on # saving the state of the toggle button
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), toggled_on)
	##for debugging
	#if toggled_on:
		#print("muted")
	#else:
		#print("not muted")


func _on_sound_check_box_toggled(toggled_on: bool) -> void:
	Global.is_sound_mute = toggled_on # saving the state of the toggle button
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), toggled_on)
	#if toggled_on:
		#print("muted")
	#else:
		#print("not muted")
