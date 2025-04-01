extends Control


var sound_has_played = false
var text_has_faded = false


func _ready() -> void:
	$VideoStreamPlayer.play() # playing an animation
	Transition.transition() # playing transition effect
	Transition.animation_player.speed_scale -= 0.2 # lowering the speed of the animation
	Transition.animation_player.play("fade_out")
	await Transition.on_transition_finished

	
func _process(_delta: float) -> void:
	await get_tree().create_timer(2.1).timeout
	if not sound_has_played: # playing a sound for the better effect
		AudioManager.collect_pollen()
		sound_has_played = true
		
	if not text_has_faded: # fading out the text
		await get_tree().create_timer(1.1).timeout
		$Label/AnimationPlayer.play("fade_out")
		text_has_faded = true


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://menus/MainMenu.tscn") # transitioning to the main menu
