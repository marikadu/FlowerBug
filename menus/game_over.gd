extends ColorRect


func _ready() -> void:
	pass


func _on_try_again_mouse_entered() -> void:
	#AudioManager.play_button_hover()
	pass


func _on_main_menu_button_mouse_entered() -> void:
	#AudioManager.play_button_hover()
	pass
	


func _on_main_menu_pressed() -> void:
	Global.is_game_over = false
	get_tree().change_scene_to_file("res://menus/MainMenu.tscn")


func _on_retry_pressed() -> void:
	Global.is_game_over = false
	# loading the same level
	get_tree().reload_current_scene()
