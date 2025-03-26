extends Control

# main menu


func _on_play_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_1.tscn")


func _on_exit_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().quit()
