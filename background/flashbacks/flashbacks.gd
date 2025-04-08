extends Control

@onready var f1: Sprite2D = $"1"
@onready var f2: Sprite2D = $"2"
@onready var f3: Sprite2D = $"3"

@onready var f4: Sprite2D = $"4"
@onready var f5: Sprite2D = $"5"
@onready var f6: Sprite2D = $"6"

@onready var f7: Sprite2D = $"7"
@onready var f8: Sprite2D = $"8"
@onready var f9: Sprite2D = $"9"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var slide: int = 0
var animation_1_playing: bool = false
var animation_2_playing: bool = false
var animation_3_playing: bool = false


func _ready() -> void:
	Events.show_flashback_1.connect(_on_show_flashback_1)
	Events.show_flashback_3.connect(_on_show_flashback_3)
	
	f1.visible = false
	f2.visible = false
	f3.visible = false
	
	f4.visible = false
	f5.visible = false
	f6.visible = false
	
	f7.visible = false
	f8.visible = false
	f9.visible = false


func _physics_process(_delta: float) -> void:
	#if Input.is_action_just_pressed("1_debugging"):
		#print("starting animation")
		#animation_player.play("flashback_1")
		#f1.visible = true
		#f2.visible = true
		#f3.visible = true
		
	if Input.is_action_just_pressed("eat"):
		if animation_1_playing:
			match slide:
				1:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_1", "slide1", "slide2")
					# apply camera shake for better visuals
					#await get_tree().create_timer(0.7).timeout
					#$Camera2D.apply_shake()
					slide += 1
					
				2:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_1", "slide2", "slide3")
					slide += 1
				
				3:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_1", "slide3", "flashback_1_end")
					slide += 1
					
					_on_show_flashback_2()

		if animation_2_playing:
			match slide:
				4:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_2", "start_flashback_2", "slide4")
					# apply camera shake for better visuals
					#await get_tree().create_timer(0.7).timeout
					#$Camera2D.apply_shake()
					slide += 1
					
				5:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_2", "slide4", "slide5")
					slide += 1
					
				6:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_2", "slide5", "slide6")
					slide += 1
				
				7:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_2", "slide6", "flashback_2_end")
					slide += 1
					await get_tree().create_timer(0.2).timeout
					get_tree().paused = false
					animation_2_playing = false
					Events.flashback_playing = false
					AudioManager.music_volume_normal()
					
					
		if animation_3_playing:
			match slide:
				1:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_3", "slide7", "slide8")
					# apply camera shake for better visuals
					#await get_tree().create_timer(0.7).timeout
					#$Camera2D.apply_shake()
					slide += 1
					
				2:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_3", "slide8", "slide9")
					slide += 1
				
				3:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_3", "slide9", "flashback_3_end")
					slide += 1
					
					await get_tree().create_timer(0.2).timeout
					get_tree().paused = false
					animation_3_playing = false
					Events.flashback_playing = false
					AudioManager.music_volume_normal()



func _on_show_flashback_1():
	Events.flashback_playing = true
	animation_1_playing = true
	f1.visible = true
	f2.visible = true
	f3.visible = true
	animation_player.play("flashback_1")
	await get_tree().create_timer(0.3996).timeout
	get_tree().paused = true # pausing the game for the player to focus on the flashback
	print("starting animation 1")
	#animation_player.play("flashback_1")
	animation_player.pause()# pause after showing the first frame
	slide += 1 # +1 to the slide counter
	
	print("paused animation, slide: ", slide)


func _on_show_flashback_2():
	print("starting animation 2")
	animation_2_playing = true
	animation_1_playing = false
	f4.visible = true
	f5.visible = true
	f6.visible = true
	animation_player.play("flashback_2")
	
	f1.visible = false
	f2.visible = false
	f3.visible = false


func _on_show_flashback_3():
	#await get_tree().create_timer(2.5).timeout # do not show the flashback right away
	Events.flashback_playing = true
	animation_3_playing = true
	f7.visible = true
	f8.visible = true
	f9.visible = true
	animation_player.play("flashback_3")
	
	await get_tree().create_timer(0.3677).timeout
	#Engine.time_scale = 0.55
	get_tree().paused = true # pausing the game for the player to focus on the flashback
	print("starting animation 3")
	#animation_player.play("flashback_1")
	animation_player.pause()# pause after showing the first frame
	slide += 1 # +1 to the slide counter
	
	print("paused animation, slide: ", slide)


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "flashback_1":
		#print("animation 1 has finished")
		#f1.visible = false
		#f2.visible = false
		#f3.visible = false
		##_on_show_flashback_2()
		#
	#elif anim_name == "flashback_2":
		#print("animation 2 has finished")
		#Events.flashback_2_finished.emit()
		#f4.visible = false
		#f5.visible = false
		#f6.visible = false
		#Engine.time_scale = 1.0
		#
	#elif anim_name == "flashback_3":
		#print("animation 3 has finished")
		#Events.flashback_3_finished.emit()
		#f7.visible = false
		#f8.visible = false
		#f9.visible = false
		#Engine.time_scale = 1.0
