extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer2
var slide: int = 0

# what if I add the feature of manually turning the pages/pannels
func _ready() -> void:
	animation_player.play("cutscene_2")
	await get_tree().create_timer(0.1333).timeout
	animation_player.pause()
	slide += 1
	print("paused animation, slide: ", slide)
	
	#await get_tree().create_timer(3.4).timeout
	#$Camera2D.apply_shake()


func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		match slide:
			1:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "start1", "start2")
				# apply camera shake for better visuals
				
				slide += 1
			
			2:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "start2", "into_bee")
				await get_tree().create_timer(0.8).timeout
				$Camera2D.apply_shake()
				slide += 1
				#
			3:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "into_bee", "no_pollen")
				slide += 1
				
			4:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "no_pollen", "is_sorry")
				slide += 1
				
			5:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "is_sorry", "notices")
				slide += 1
				
			6:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "notices", "angry_bee")
				await get_tree().create_timer(0.5).timeout
				$Camera2D.apply_shake()
				slide += 1
				
			7:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "angry_bee", "hat1")
				slide += 1
				
			8:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "hat1", "hat2")
				slide += 1
				
			9:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "hat2", "grandma_bee")
				slide += 1
				
			10:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "grandma_bee", "honey1")
				slide += 1
				
			11:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "honey1", "honey2")
				slide += 1
				
			12:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "honey2", "honey3")
				slide += 1
				
			13:
				print("paused animation, slide: ", slide)
				animation_player.play_section_with_markers("cutscene_2", "honey3", "end")
				slide += 1
				
			14: # end of the cutscene
				print("paused animation, slide: ", slide)
				Transition.transition()
				await Transition.on_transition_finished
				get_tree().change_scene_to_file("res://levels/level_3.tscn")
