extends Control


@onready var pause_menu: Control = $"."


func _ready() -> void:
	pause_menu.hide()


func _process(_delta: float) -> void:
	# do not trigger pause when game over or win
	if not (Global.is_game_over or Global.is_game_won):
		# if not in the paused state and pressed esc
		if Input.is_action_just_pressed("pause") and get_tree().paused == false:
			pause()
			
		# if in the paused state and pressed esc 
		elif Input.is_action_just_pressed("pause") and get_tree().paused:
			resume()


func resume():
	pause_menu.hide()
	#Events.resume_game.emit()
	if not Events.flashback_playing:
		get_tree().paused = false
	
func pause():
	pause_menu.show()
	get_tree().paused = true


func _on_main_menu_pressed() -> void:
	if Engine.time_scale < 1.0:
		Engine.time_scale = 1.0
	resume()
	print("to the main menu")
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://menus/MainMenu.tscn")


func _on_resume_pressed() -> void:
	resume()
