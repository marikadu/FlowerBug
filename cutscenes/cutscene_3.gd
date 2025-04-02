extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer2
@onready var continue_sprite: AnimatedSprite2D = $Camera2D/CanContinue/ContinueSprite
@onready var continue_animation_player: AnimationPlayer = $Camera2D/CanContinue/ContinueAnimationPlayer


var slide: int = 0

# what if I add the feature of manually turning the pages/pannels
func _ready() -> void:
	animation_player.play("cutscene3")
	await get_tree().create_timer(0.3998).timeout
	#await get_tree().process_frame
	animation_player.pause()
	slide += 1
	_can_continue()
	print("paused animation, slide: ", slide)
	
	if Global.unlocked_levels < 4 : # unlocking level 4
		Global.unlocked_levels = 4
		print("unlocked level 4!")
	else:
		print("you already have level 4 unlocked")
	
	
	AudioManager.rain_sound.volume_db = -30.0
	AudioManager.rain_play()
	await get_tree().create_timer(0.4).timeout
	AudioManager.rain_sound.volume_db = -25.0
	await get_tree().create_timer(0.4).timeout
	AudioManager.rain_sound.volume_db = -23.0
	
	#await get_tree().create_timer(3.4).timeout
	#$Camera2D.apply_shake()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		match slide:
			1:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "start", "bird")
				slide += 1
				await get_tree().create_timer(0.8).timeout
				AudioManager.angry_bird_play()
			
			2:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "bird", "bird_drop")
				#await get_tree().create_timer(0.8).timeout
				#$Camera2D.apply_shake()
				slide += 1
			3:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "bird_drop", "bird_fly")
				slide += 1
				
			4:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "bird_fly", "beetle")
				slide += 1
				
				
			5:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "beetle", "beetle_flies")
				slide += 1
				
			6:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "beetle_flies", "drop1")
				slide += 1
				
			7:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop1", "drop2")
				slide += 1
				
				
			8:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop2", "drop3")
				slide += 1
				
				AudioManager.water_drop_play()
				
				# fading out the sound
				AudioManager.rain_sound.volume_db = -24.0
				await get_tree().create_timer(0.4).timeout
				AudioManager.rain_sound.volume_db = -30.0
				await get_tree().create_timer(0.4).timeout
				AudioManager.empty_play()
				AudioManager.rain_sound.volume_db = -40.0
				
				
			9:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop3", "drop4")
				slide += 1
				
			10:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop4", "drop5")
				slide += 1
				
			11:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop5", "drop6")
				slide += 1
				
			12:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop6", "drop7")
				slide += 1
				
			13:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop7", "drop8")
				slide += 1
				
			14:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop8", "drop9")
				slide += 1
				await get_tree().create_timer(1.3).timeout
				$Camera2D.apply_shake()
				
				AudioManager.rain_sound.volume_db = -30.0
				#AudioManager.rain_play()
				await get_tree().create_timer(0.4).timeout
				AudioManager.rain_sound.volume_db = -25.0
				await get_tree().create_timer(0.4).timeout
				AudioManager.rain_sound.volume_db = -23.0
				
				
			15:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop9", "fell")
				slide += 1
				
			16:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "fell", "hide")
				slide += 1
				
			17:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "hide", "hide2")
				slide += 1
				
			18:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "hide2", "leaf1")
				slide += 1
				
			19:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf1", "leaf2")
				slide += 1
				
			20:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf2", "leaf3")
				slide += 1
				
			21:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf3", "leaf4")
				slide += 1
				
			22:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf4", "leaf5")
				slide += 1
				
			23:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf5", "morning1")
				slide += 1
				
			24:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "morning1", "morning2")
				slide += 1
				
			25:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "morning2", "morning3")
				slide += 1
				
			26:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "morning3", "morning4")
				slide += 1
				
			27: # end of the cutscene
				print("paused animation, slide: ", slide)
				if not Global.paint_was_washed_off:
					Global.paint_was_washed_off = true
				Transition.transition()
				await Transition.on_transition_finished
				get_tree().change_scene_to_file("res://levels/level_4.tscn")
				
				
func _can_continue():
	await get_tree().create_timer(0.2).timeout
	continue_animation_player.play("can_continue") # show the mouse
	await get_tree().create_timer(0.2).timeout
	continue_sprite.play("click")
	
func _hide_mouse_indicator():
	continue_animation_player.play("hide")
