extends ColorRect


func _ready() -> void:
	pass


func _on_main_menu_pressed() -> void:
	Global.is_game_over = false
	get_tree().change_scene_to_file("res://menus/MainMenu.tscn")


func _on_retry_pressed() -> void:
	Global.is_game_over = false
	# Loading the same level
	get_tree().reload_current_scene()
