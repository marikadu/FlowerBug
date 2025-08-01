extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skew_effect: AnimationPlayer = $SkewEffect


@export var flower_type: String = "n_flower_1"
var player: CharacterBody2D
var is_being_eaten: bool = false
var can_be_eaten: bool
var is_blooming: bool

signal is_eaten_status_1(is_eaten: bool)

func _ready() -> void:
	# For the variety, either have the sprite be flipped horizontally or not
	if randf() < 0.5:
		animated_sprite.flip_h = true
	# Bouncing animations for better visuals
	animated_sprite.play("blooming")
	animation_player.play("bounce")
	player = Global.player_instance
	can_be_eaten = false
	is_blooming = true
	skew_effect.play("skew")


func _on_disappear_timer_timeout() -> void:
	if not is_being_eaten:
		get_parent().remove_flower(self)
		
func start_eating():
	$DisappearTimer.paused = true
	is_being_eaten = true
	is_eaten_status_1.emit(true)
	skew_effect.stop()
	
	
func stop_eating():
	$DisappearTimer.paused = false
	is_being_eaten = false
	is_eaten_status_1.emit(false)
	skew_effect.play("skew")


func _on_animated_sprite_2d_animation_finished() -> void:
	is_blooming = false
	animation_player.play("bounce")
	AudioManager.flower_bloomed()
	animated_sprite.play("bloomed")
	can_be_eaten = true
	$DisappearTimer.start()


# Every frame change, the bouncing animation is played
# Therefore for every flower "state", it has an animation of the bounce
func _on_animated_sprite_2d_frame_changed() -> void:
	if is_blooming:
		animation_player.play("bounce")
