extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer2
@onready var continue_sprite: AnimatedSprite2D = $Camera2D/CanContinue/ContinueSprite
@onready var continue_animation_player: AnimationPlayer = $Camera2D/CanContinue/ContinueAnimationPlayer


var slide: int = 0

# what if I add the feature of manually turning the pages/pannels
func _ready() -> void:
	Global.current_scene_name = 0 # level = cutscene
	
	animation_player.play("cutscene_2")
	await get_tree().create_timer(0.1333).timeout
	animation_player.pause()
	slide += 1
	_can_continue()
	print("paused animation, slide: ", slide)
	
	if Global.unlocked_levels < 3 : # unlocking level 3
		Global.unlocked_levels = 3
		print("unlocked level 3!")
	else:
		print("you already have level 3 unlocked")
	
	
	AudioManager.cutscene_start()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		match slide:
			1:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "start1", "start2")
				slide += 1
				await get_tree().create_timer(0.4).timeout
				_can_continue()
			
			2:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "start2", "into_bee")
				await get_tree().create_timer(0.8).timeout
				$Camera2D.apply_shake()
				AudioManager.play_hit()
				slide += 1
				await get_tree().create_timer(0.4).timeout
				_can_continue()
			3:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "into_bee", "no_pollen")
				slide += 1
				await get_tree().create_timer(0.6).timeout
				_can_continue()
				
			4:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "no_pollen", "is_sorry")
				slide += 1
				await get_tree().create_timer(0.4).timeout
				_can_continue()
				
			5:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "is_sorry", "notices")
				await get_tree().create_timer(0.3).timeout
				AudioManager.play_notices()
				slide += 1
				await get_tree().create_timer(0.3).timeout
				_can_continue()
				
			6:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "notices", "angry_bee")
				await get_tree().create_timer(0.5).timeout
				$Camera2D.apply_shake()
				AudioManager.angry_bee()
				slide += 1
				await get_tree().create_timer(0.7).timeout
				_can_continue()
				
			7:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "angry_bee", "hat1")
				slide += 1
				await get_tree().create_timer(2.8).timeout
				_can_continue()
				
			8:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "hat1", "hat2")
				slide += 1
				await get_tree().create_timer(2.9).timeout
				_can_continue()
				
			9:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "hat2", "grandma_bee")
				slide += 1
				await get_tree().create_timer(2.5).timeout
				_can_continue()
				
			10:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "grandma_bee", "honey1")
				slide += 1
				await get_tree().create_timer(1.7).timeout
				_can_continue()
				
			11:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "honey1", "honey2")
				slide += 1
				await get_tree().create_timer(2.3).timeout
				_can_continue()
				
			12:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "honey2", "honey3")
				slide += 1
				await get_tree().create_timer(2.0).timeout
				AudioManager.play_notices()
				await get_tree().create_timer(0.8).timeout
				_can_continue()
				
			13:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "honey3", "end")
				slide += 1
				await get_tree().create_timer(3.6).timeout
				_can_continue()
				
			14: # end of the cutscene
				print("paused animation, slide: ", slide)
				Transition.transition()
				await Transition.on_transition_finished
				get_tree().change_scene_to_file("res://levels/level_3.tscn")


func _can_continue():
	await get_tree().create_timer(0.2).timeout
	continue_animation_player.play("can_continue") # show the mouse
	await get_tree().create_timer(0.2).timeout
	continue_sprite.play("click")
	
func _hide_mouse_indicator():
	continue_animation_player.play("hide")
