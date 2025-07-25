extends Control

@onready var pause_menu: Control = $"."


func _ready() -> void:
	pause_menu.hide()


func _process(_delta: float) -> void:
	# Do not trigger pause when game over or win
	if not (Global.is_game_over or Global.is_game_won):
		# If not in the paused state and pressed esc
		if Input.is_action_just_pressed("pause") and get_tree().paused == false:
			pause()
			
		# If in the paused state and pressed esc 
		elif Input.is_action_just_pressed("pause") and get_tree().paused:
			resume()


func resume():
	pause_menu.hide()
	if not Events.flashback_playing: # If the flashback cutscene is not playing
		get_tree().paused = false
	
func pause():
	pause_menu.show()
	get_tree().paused = true


func _on_main_menu_pressed() -> void:
	resume()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://menus/MainMenu.tscn")


func _on_resume_pressed() -> void:
	resume()
