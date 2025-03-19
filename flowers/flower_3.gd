extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var flower_type: String = "flower_3"
var player: CharacterBody2D
var is_being_eaten: bool = false
var can_be_eaten: bool
var is_blooming: bool

signal is_eaten_status_3(is_eaten: bool)

func _ready() -> void:
	# for the variety, either have the sprite be flipped horizontally or not
	if randf() < 0.5:
		animated_sprite.flip_h = true
	# bouncing animations for better visuals
	animated_sprite.play("blooming")
	animation_player.play("bounce")
	player = Global.player_instance
	can_be_eaten = false

func _on_disappear_timer_timeout() -> void:
	if not is_being_eaten:
		#self.queue_free()
		get_parent().remove_flower(self)
		
func trap_the_player():
	$DisappearTimer.stop()
	is_being_eaten = true
	is_eaten_status_3.emit(true)


func _on_animated_sprite_2d_animation_finished() -> void:
	is_blooming = false
	animation_player.play("bounce")
	animated_sprite.play("bloomed")
	can_be_eaten = true
	$DisappearTimer.start()


# every frame change, the bouncing animation is played
# therefore for every flower "state", it has an animation of the bounce
func _on_animated_sprite_2d_frame_changed() -> void:
	if is_blooming:
		animation_player.play("bounce")
