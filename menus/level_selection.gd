extends Control


# Level 1
func _on_morning_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_1.tscn")


# Level 2
func _on_noon_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_2.tscn")


# Level 3
func _on_evening_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_3.tscn")


# Level 4
func _on_dawn_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_4.tscn")


# Level "main", infinite mode
func _on_infinite_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/main.tscn")


func _on_back_pressed() -> void:
	pass # Replace with function body.
