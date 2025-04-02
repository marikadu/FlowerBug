extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var slide: int = 0

# what if I add the feature of manually turning the pages/pannels
func _ready() -> void:
	animation_player.play("cutscene4")
	await get_tree().create_timer(0.4651).timeout
	#await get_tree().process_frame
	animation_player.pause()
	slide += 1
	print("paused animation, slide: ", slide)
	
	if Global.unlocked_levels < 5 : # unlocking level 5, infinite mode
		Global.unlocked_levels = 5
		print("unlocked level 5!")
	else:
		print("you already have level 5 unlocked")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		match slide:
			1:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "morning1", "morning2")
				# apply camera shake for better visuals
				
				slide += 1
			
			2:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "morning2", "door1")
				#await get_tree().create_timer(0.8).timeout
				#$Camera2D.apply_shake()
				slide += 1
				#
			3:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "door1", "door2")
				slide += 1
				
			4:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "door2", "sleepy1")
				slide += 1
				
				
			5:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "sleepy1", "sleepy2")
				slide += 1
				
			6:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "sleepy2", "sleepy3")
				slide += 1
				
			7:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "sleepy3", "office")
				slide += 1
				
			8:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "office", "hug1")
				slide += 1
				
			9:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "hug1", "hug2")
				slide += 1
				
			10:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "hug2", "end1")
				slide += 1
				
			11:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "end1", "end2")
				slide += 1
				
			12:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene4", "end2", "end3")
				slide += 1
				#########################
				
			13: # end of the cutscene
				print("paused animation, slide: ", slide)
				Transition.transition()
				await Transition.on_transition_finished
				get_tree().change_scene_to_file("res://menus/WinMenu.tscn")
