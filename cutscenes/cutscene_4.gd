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
	
	animation_player.play("cutscene4")
	await get_tree().create_timer(0.4651, false).timeout
	animation_player.pause()
	slide += 1
	_can_continue()
	print("paused animation, slide: ", slide)
	
	if Global.unlocked_levels < 5 : # Unlocking level 5, infinite mode
		Global.unlocked_levels = 5
		print("unlocked level 5!")
	else:
		print("you already have level 5 unlocked")
		
	AudioManager.cutscene_start()

func _physics_process(_delta: float) -> void:
	if can_next_slide and Input.is_action_just_pressed("eat"):
		match slide:
			1:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "morning1", "morning2")
				slide += 1
				await get_tree().create_timer(1.5, false).timeout
				AudioManager.door_opening()
				await get_tree().create_timer(0.4, false).timeout
				_can_continue()
			
			2:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "morning2", "door1")
				slide += 1
				await get_tree().create_timer(2.5, false).timeout
				_can_continue()
			3:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "door1", "door2")
				slide += 1
				await get_tree().create_timer(2.4, false).timeout
				_can_continue()
				
			4:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "door2", "sleepy1")
				slide += 1
				await get_tree().create_timer(1.8, false).timeout
				_can_continue()
				
				
			5:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "sleepy1", "sleepy2")
				slide += 1
				await get_tree().create_timer(1.3, false).timeout
				_can_continue()
				
			6:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "sleepy2", "sleepy3")
				slide += 1
				await get_tree().create_timer(0.7, false).timeout
				AudioManager.play_notices()
				await get_tree().create_timer(0.7, false).timeout
				_can_continue()
				
			7:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "sleepy3", "office")
				slide += 1
				await get_tree().create_timer(1.9, false).timeout
				_can_continue()
				
			8:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "office", "hug1")
				slide += 1
				await get_tree().create_timer(1.6, false).timeout
				AudioManager.collect_pollen() # Hug sound
				await get_tree().create_timer(1.8, false).timeout
				_can_continue()
				
			9:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "hug1", "hug2")
				slide += 1
				await get_tree().create_timer(2.3, false).timeout
				_can_continue()
				
			10:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "hug2", "end1")
				slide += 1
				await get_tree().create_timer(2.2, false).timeout
				_can_continue()
				
			11:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "end1", "end2")
				slide += 1
				await get_tree().create_timer(2.9, false).timeout
				_can_continue()
				
			12:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "end2", "end3")
				slide += 1
				await get_tree().create_timer(2.5, false).timeout
				_can_continue()
				
			13: # end of the cutscene
				print("paused animation, slide: ", slide)
				Transition.transition()
				await Transition.on_transition_finished
				get_tree().change_scene_to_file("res://menus/WinMenu.tscn")


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
