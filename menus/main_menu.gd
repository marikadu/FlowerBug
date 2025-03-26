extends Control

# main menu


func _on_play_pressed() -> void:
	if not Global.has_started_the_game:
		Global.has_completed_the_game = true
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://levels/level_1.tscn")

	else:
		print("has started the game: to the level selection screen")
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://menus/LevelSelection.tscn")


func _on_exit_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().quit()
