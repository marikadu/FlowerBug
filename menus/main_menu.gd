extends Control

@onready var player_logo: AnimationPlayer = $AnimationPlayerLogo
@onready var player_beetle: AnimationPlayer = $AnimationPlayerBeetle
@onready var player_bird: AnimationPlayer = $AnimationPlayerBird

# main menu

func _ready() -> void:
	player_logo.play("Logo")
	player_beetle.play("beetle")
	player_bird.play("bird")
	
	if Global.paint_was_washed_off: # if the paint is washed off due to the story
		$Beetle.play("no_paint")
	else:
		$Beetle.play("with_paint")


func _on_play_pressed() -> void:
	if not Global.has_started_the_game:
		Global.has_started_the_game = true
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://levels/level_1.tscn")

	else:
		#print("has started the game: to the level selection screen")
		#Transition.transition()
		#await Transition.on_transition_finished
		#get_tree().change_scene_to_file("res://menus/LevelSelection.tscn")
		$AnimationPlayerCamera.play("camera")


func _on_exit_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().quit()
