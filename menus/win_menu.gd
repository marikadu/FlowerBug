extends Control


func _on_main_menu_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://menus/MainMenu.tscn")
