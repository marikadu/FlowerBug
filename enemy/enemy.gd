extends CharacterBody2D

@onready var flying_sprite: Sprite2D = $Flying_Sprite
@onready var shadow: AnimationPlayer = $shadow
@onready var bird: AnimationPlayer = $bird
@onready var bird_sprite: AnimatedSprite2D = $Bird_Sprite

@export var max_speed = 260.0
@export var min_speed = 50.0
@export var lerp_factor = 0.2
@export var cursor_threshold = 5.0

var player: CharacterBody2D
var can_move: bool

signal has_landed
signal leaving

func _ready() -> void:
	bird_sprite.frame = 0
	can_move = true
	player = Global.player_instance
	#player = get_tree().get_first_node_in_group("player")
	$BirdAppearTimer.start()
	
func _physics_process(_delta: float) -> void:
	#if player == null:
		#return
	
	if can_move:
		var target_position = player.global_position
		var distance = global_position.distance_to(target_position)
		
		# prevent character shaking when very close to the cursor
		if distance < cursor_threshold:
			velocity = velocity.lerp(Vector2.ZERO, 0.2)
		
		else:
			# smooth movement
			# ensuring the character does not shake when close to cursor
			var speed = lerp(min_speed, max_speed, distance / 50.0)
			speed = clamp(speed, min_speed, max_speed)
			
			var direction = (target_position - global_position).normalized()
			var target_velocity = direction * speed
			velocity = velocity.lerp(target_velocity, lerp_factor)

		#move_and_slide()
		#flying_sprite.look_at(target_position)
		#look_at(target_position)
		
	else:
		#move_and_slide()
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
		
	move_and_slide()


func _on_bird_appear_timer_timeout() -> void:
	can_move = false
	await get_tree().create_timer(1.2).timeout
	shadow.play("coming")
	bird.play("landing")
	
	# has landed
	print("landed")
	await get_tree().create_timer(0.9).timeout
	emit_signal("has_landed")
	bird_sprite.frame = 1
	
	bird_sprite.play("not_caught")
	await get_tree().create_timer(1.7).timeout
	#$AnimationPlayer.play("fly_away")
	#$AnimationPlayer.play("leaving")
	print("leaving")
	bird.play("fly_away")
	#await get_tree().create_timer(1).timeout
	emit_signal("leaving")



func _on_has_landed() -> void:
	print("landed, true!")
	pass # Replace with function body.


func _on_leaving() -> void:
	print("leaving, true!")
	#await get_tree().create_timer(0.3).timeout
	shadow.play("fly_away")
	await get_tree().create_timer(1.1).timeout
	queue_free()
	pass # Replace with function body.



func _on_bird_sprite_frame_changed() -> void:
	bird.play("bounce")
