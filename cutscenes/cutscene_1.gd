extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var slide: int = 0

# what if I add the feature of manually turning the pages/pannels
func _ready() -> void:
	if Engine.time_scale < 1.0:
		Engine.time_scale = 1.0
	
	animation_player.play("start_2")
	await get_tree().create_timer(2.4801).timeout
	animation_player.pause()
	slide += 1
	print("paused animation, slide: ", slide)
	
	#await get_tree().create_timer(3.4).timeout
	#$Camera2D.apply_shake()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		match slide:
			1:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "hit_tree", "hit_tree_end")
				# apply camera shake for better visuals
				await get_tree().create_timer(0.7).timeout
				$Camera2D.apply_shake()
				slide += 1
			
			2:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "hit_tree_end", "angry")
				slide += 1
				#
			3:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "angry", "discovered_tree")
				slide += 1
				
			4:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "discovered_tree", "entering_tree")
				slide += 1
				
			5:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "entering_tree", "family_1")
				slide += 1
				
			6:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "family_1", "see_family_2")
				slide += 1
				
			7:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "see_family_2", "family_2")
				slide += 1
				
			8:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "family_2", "distracted")
				slide += 1
				
			9:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "distracted", "shake")
				slide += 1
				
			10:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("start_2", "shake", "leave")
				slide += 1
				
			11: # end of the cutscene
				print("paused animation, slide: ", slide)
				
				Transition.transition()
				await Transition.on_transition_finished
				get_tree().change_scene_to_file("res://levels/level_2.tscn")
