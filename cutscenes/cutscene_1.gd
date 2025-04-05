extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_sprite: AnimatedSprite2D = $Camera2D/CanContinue/ContinueSprite
@onready var continue_animation_player: AnimationPlayer = $Camera2D/CanContinue/ContinueAnimationPlayer

var slide: int = 0


func _ready() -> void:
	if Engine.time_scale < 1.0:
		Engine.time_scale = 1.0
	
	animation_player.play("start_2")
	await get_tree().create_timer(2.4801).timeout
	animation_player.pause()
	slide += 1
	_can_continue()
	print("paused animation, slide: ", slide)
	
	if Global.unlocked_levels < 2 : # unlocking level 2
		Global.unlocked_levels = 2
		print("unlocked level 2!")
	else:
		print("you already have level 2 unlocked")
	
	#await get_tree().create_timer(3.4).timeout
	#$Camera2D.apply_shake()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		match slide:
			1:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "hit_tree", "hit_tree_end")
				# apply camera shake for better visuals
				await get_tree().create_timer(0.7).timeout
				$Camera2D.apply_shake()
				slide += 1
				await get_tree().create_timer(0.6).timeout
				_can_continue()
				
			
			2:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "hit_tree_end", "angry")
				slide += 1
				await get_tree().create_timer(3.2).timeout
				_can_continue()
				#
			3:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "angry", "discovered_tree")
				slide += 1
				await get_tree().create_timer(2.6).timeout
				_can_continue()
				
			4:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "discovered_tree", "entering_tree")
				slide += 1
				await get_tree().create_timer(1.3).timeout
				_can_continue()
				
			5:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "entering_tree", "family_1")
				slide += 1
				await get_tree().create_timer(2.0).timeout
				_can_continue()
				
			6:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "family_1", "see_family_2")
				slide += 1
				await get_tree().create_timer(2.1).timeout
				_can_continue()
				
			7:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "see_family_2", "family_2")
				slide += 1
				await get_tree().create_timer(3.1).timeout
				_can_continue()
				
			8:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "family_2", "distracted")
				slide += 1
				await get_tree().create_timer(1.6).timeout
				_can_continue()
				
			9:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "distracted", "shake")
				slide += 1
				await get_tree().create_timer(1.9).timeout
				_can_continue()
				
			10:
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "shake", "leave")
				slide += 1
				await get_tree().create_timer(1.9).timeout
				_can_continue()
				
			11: # end of the cutscene
				_hide_mouse_indicator()
				print("paused animation, slide: ", slide)
				
				Transition.transition()
				await Transition.on_transition_finished
				get_tree().change_scene_to_file("res://levels/level_2.tscn")


	
func _can_continue():
	await get_tree().create_timer(0.2).timeout
	continue_animation_player.play("can_continue") # show the mouse
	await get_tree().create_timer(0.2).timeout
	continue_sprite.play("click")
	
func _hide_mouse_indicator():
	continue_animation_player.play("hide")
