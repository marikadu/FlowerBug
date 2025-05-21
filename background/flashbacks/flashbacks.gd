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
@onready var continue_sprite: AnimatedSprite2D = $CanContinue/ContinueSprite
@onready var continue_animation_player: AnimationPlayer = $CanContinue/ContinueAnimationPlayer

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
	if Input.is_action_just_pressed("eat"):
		if animation_1_playing:
			match slide:
				1:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_1", "slide1", "slide2")
					slide += 1
					await get_tree().create_timer(0.7,).timeout
					_can_continue()
					
				2:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_1", "slide2", "slide3")
					slide += 1
					await get_tree().create_timer(0.7,).timeout
					_can_continue()
				
				3:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_1", "slide3", "flashback_1_end")
					slide += 1
					await get_tree().create_timer(0.7,).timeout
					_can_continue()
					_on_show_flashback_2()

		if animation_2_playing:
			match slide:
				4:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_2", "start_flashback_2", "slide4")
					slide += 1
					await get_tree().create_timer(1.5,).timeout
					_can_continue()
					
				5:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_2", "slide4", "slide5")
					slide += 1
					await get_tree().create_timer(0.7,).timeout
					_can_continue()
					
				6:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_2", "slide5", "slide6")
					slide += 1
					await get_tree().create_timer(0.7,).timeout
					_can_continue()
				
				7:
					_hide_mouse_indicator()
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_2", "slide6", "flashback_2_end")
					slide += 1
					await get_tree().create_timer(0.2,).timeout
					get_tree().paused = false
					animation_2_playing = false
					Events.flashback_playing = false
					AudioManager.music_volume_normal()
					
					
		if animation_3_playing:
			match slide:
				1:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_3", "slide7", "slide8")
					slide += 1
					
				2:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_3", "slide8", "slide9")
					slide += 1
				
				3:
					print("paused animation, slide: ", slide)
					animation_player.play_section_with_markers("flashback_3", "slide9", "flashback_3_end")
					slide += 1
					
					await get_tree().create_timer(0.2,).timeout
					get_tree().paused = false
					animation_3_playing = false
					Events.flashback_playing = false
					AudioManager.music_volume_normal()
					_hide_mouse_indicator()



func _on_show_flashback_1():
	Events.flashback_playing = true
	animation_1_playing = true
	f1.visible = true
	f2.visible = true
	f3.visible = true
	animation_player.play("flashback_1")
	await get_tree().create_timer(0.3996, false).timeout
	get_tree().paused = true # Pausing the game for the player to focus on the flashback
	print("starting animation 1")
	animation_player.pause()# Pause after showing the first frame
	slide += 1 # +1 to the slide counter
	_can_continue()
	
	print("paused animation, slide: ", slide)


func _on_show_flashback_2():
	_hide_mouse_indicator()
	print("starting animation 2")
	animation_2_playing = true
	animation_1_playing = false
	f4.visible = true
	f5.visible = true
	f6.visible = true
	animation_player.play("flashback_2")
	await get_tree().create_timer(0.3996, false).timeout
	_can_continue()
	
	f1.visible = false
	f2.visible = false
	f3.visible = false


func _on_show_flashback_3():
	Events.flashback_playing = true
	animation_3_playing = true
	f7.visible = true
	f8.visible = true
	f9.visible = true
	animation_player.play("flashback_3")
	
	await get_tree().create_timer(0.3677, false).timeout
	get_tree().paused = true # Pausing the game for the player to focus on the flashback
	print("starting animation 3")
	animation_player.pause()# Pause after showing the first frame
	slide += 1 # +1 to the slide counter
	_can_continue()
	
	print("paused animation, slide: ", slide)


func _can_continue():
	await get_tree().create_timer(0.2, false).timeout
	#continue_animation_player.play("can_continue") # Show the mouse
	await get_tree().create_timer(0.2, false).timeout
	continue_sprite.play("click")
	
func _hide_mouse_indicator():
	#continue_animation_player.stop("can_continue")
	#continue_animation_player.play("hide")
	continue_animation_player.play_backwards("can_continue")
	pass
