extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer2
@onready var continue_sprite: AnimatedSprite2D = $Camera2D/CanContinue/ContinueSprite
@onready var continue_animation_player: AnimationPlayer = $Camera2D/CanContinue/ContinueAnimationPlayer


var slide: int = 0

# what if I add the feature of manually turning the pages/pannels
func _ready() -> void:
	Global.current_scene_name = 0 # level = cutscene
	
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
		
	AudioManager.cutscene_start()
	
	# start rain
	AudioManager.rain_sound.volume_db = -30.0
	AudioManager.rain_play()
	await get_tree().create_timer(0.4).timeout
	AudioManager.rain_sound.volume_db = -25.0
	await get_tree().create_timer(0.4).timeout
	AudioManager.rain_sound.volume_db = -23.0


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		match slide:
			1:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "start", "bird")
				slide += 1
				await get_tree().create_timer(0.8).timeout
				AudioManager.angry_bird_play()
				await get_tree().create_timer(0.4).timeout
				_can_continue()
			
			2:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "bird", "bird_drop")
				await get_tree().create_timer(0.8).timeout
				_can_continue()
			3:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "bird_drop", "bird_fly")
				await get_tree().create_timer(1.8).timeout
				_can_continue()
				
			4:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "bird_fly", "beetle")
				await get_tree().create_timer(1.0).timeout
				_can_continue()
				
				
			5:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "beetle", "beetle_flies")
				await get_tree().create_timer(2.4).timeout
				_can_continue()
				
			6:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "beetle_flies", "drop1")
				await get_tree().create_timer(0.7).timeout
				_can_continue()
				
			7:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop1", "drop2")
				await get_tree().create_timer(1.6).timeout
				_can_continue()
				
				
			8:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop2", "drop3")
				AudioManager.water_drop_play()
				
				# fading out the sound
				AudioManager.rain_sound.volume_db = -24.0
				await get_tree().create_timer(0.4).timeout
				AudioManager.rain_sound.volume_db = -30.0
				await get_tree().create_timer(0.4).timeout
				AudioManager.empty_play()
				AudioManager.rain_sound.volume_db = -40.0
				
				await get_tree().create_timer(0.5).timeout
				_can_continue()
				
				
			9:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop3", "drop4")
				await get_tree().create_timer(1.6).timeout
				_can_continue()
				
			10:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop4", "drop5")
				await get_tree().create_timer(1.9).timeout
				_can_continue()
				
			11:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop5", "drop6")
				await get_tree().create_timer(2.3).timeout
				_can_continue()
				
			12:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop6", "drop7")
				await get_tree().create_timer(1.6).timeout
				_can_continue()
				
			13:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop7", "drop8")
				await get_tree().create_timer(1.4).timeout
				_can_continue()
				
			14:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop8", "drop9")
				
				await get_tree().create_timer(1.3).timeout
				$Camera2D.apply_shake()
				AudioManager.play_hit()
				
				AudioManager.rain_sound.volume_db = -30.0
				await get_tree().create_timer(0.4).timeout
				AudioManager.rain_sound.volume_db = -25.0
				await get_tree().create_timer(0.4).timeout
				AudioManager.rain_sound.volume_db = -23.0
				
				await get_tree().create_timer(0.2).timeout
				_can_continue()
				
				
			15:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "drop9", "fell")
				await get_tree().create_timer(1.7).timeout
				_can_continue()
				
			16:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "fell", "hide")
				await get_tree().create_timer(0.9).timeout
				_can_continue()
				
			17:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "hide", "hide2")
				await get_tree().create_timer(0.9).timeout
				_can_continue()
				
			18:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "hide2", "leaf1")
				await get_tree().create_timer(0.9).timeout
				_can_continue()
				
			19:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf1", "leaf2")
				await get_tree().create_timer(0.9).timeout
				_can_continue()
				
			20:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf2", "leaf3")
				await get_tree().create_timer(0.9).timeout
				_can_continue()
				
			21:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf3", "leaf4")
				await get_tree().create_timer(1.0).timeout
				_can_continue()
				
			22:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf4", "leaf5")
				await get_tree().create_timer(1.9).timeout
				_can_continue()
				
			23:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "leaf5", "morning1")
				await get_tree().create_timer(1.8).timeout
				_can_continue()
				
			24:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "morning1", "morning2")
				await get_tree().create_timer(1.8).timeout
				_can_continue()
				
			25:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "morning2", "morning3")
				await get_tree().create_timer(1.8).timeout
				_can_continue()
				
			26:
				_hide_mouse_indicator()
				slide += 1
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene3", "morning3", "morning4")
				await get_tree().create_timer(3.5).timeout
				_can_continue()
				
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
