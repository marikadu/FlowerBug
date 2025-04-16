extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_sprite: AnimatedSprite2D = $Camera2D/CanContinue/ContinueSprite
@onready var continue_animation_player: AnimationPlayer = $Camera2D/CanContinue/ContinueAnimationPlayer

var slide: int = 0
# Restricting the player from 
# skipping to the next side
# unless the animation is over
var can_next_slide: bool = false


func _ready() -> void:
	Global.current_scene_name = 0 # Level = cutscene
	
	if Engine.time_scale < 1.0:
		Engine.time_scale = 1.0
	
	animation_player.play("start_2")
	await get_tree().create_timer(2.4801, false).timeout # False means that during the pause the timer stops
	animation_player.pause()
	slide += 1
	_can_continue()
	print("paused animation, slide: ", slide)
	
	if Global.unlocked_levels < 2 : # Unlocking level 2
		Global.unlocked_levels = 2
		print("unlocked level 2!")
	else:
		print("you already have level 2 unlocked")
		
	AudioManager.cutscene_start()


func _physics_process(_delta: float) -> void:
	if can_next_slide:
		if Input.is_action_just_pressed("eat"):
			match slide:
				1:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "hit_tree", "hit_tree_end")
					# Apply camera shake for better visuals
					await get_tree().create_timer(0.7, false).timeout
					$Camera2D.apply_shake()
					slide += 1
					AudioManager.play_hit()
					await get_tree().create_timer(0.6, false).timeout
					_can_continue()
					
				
				2:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "hit_tree_end", "angry")
					slide += 1
					await get_tree().create_timer(3.2, false).timeout
					_can_continue()
					#
				3:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "angry", "discovered_tree")
					await get_tree().create_timer(0.6, false).timeout
					AudioManager.play_notices()
					slide += 1
					await get_tree().create_timer(1.6, false).timeout
					_can_continue()
					
				4:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "discovered_tree", "entering_tree")
					slide += 1
					await get_tree().create_timer(1.3, false).timeout
					_can_continue()
					
				5:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "entering_tree", "family_1")
					slide += 1
					await get_tree().create_timer(2.0, false).timeout
					_can_continue()
					
				6:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "family_1", "see_family_2")
					slide += 1
					await get_tree().create_timer(2.1, false).timeout
					_can_continue()
					
				7:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "see_family_2", "family_2")
					slide += 1
					await get_tree().create_timer(3.0, false).timeout
					AudioManager.play_eating()
					await get_tree().create_timer(0.2, false).timeout
					_can_continue()
					
				8:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "family_2", "distracted")
					slide += 1
					await get_tree().create_timer(1.6, false).timeout
					_can_continue()
					
				9:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "distracted", "shake")
					slide += 1
					await get_tree().create_timer(1.9, false).timeout
					_can_continue()
					
				10:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("start_2", "shake", "leave")
					slide += 1
					await get_tree().create_timer(1.9, false).timeout
					_can_continue()
					
				11: # End of the cutscene
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					
					Transition.transition()
					await Transition.on_transition_finished
					get_tree().change_scene_to_file("res://levels/level_2.tscn")


	
func _can_continue():
	await get_tree().create_timer(0.2, false).timeout
	continue_animation_player.play("can_continue") # Show the indicator
	await get_tree().create_timer(0.2, false).timeout
	continue_sprite.play("click")
	can_next_slide = true
	
func _hide_mouse_indicator():
	continue_animation_player.play("hide")
	can_next_slide = false


func _on_skip_cutscene_pressed() -> void:
	$CanvasLayer/Pause.hide()
	get_tree().paused = false
	
	await get_tree().process_frame # Wait a frame
	
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_2.tscn")
