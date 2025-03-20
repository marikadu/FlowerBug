extends CharacterBody2D


@export var max_speed = 260.0
@export var min_speed = 50.0
@export var lerp_factor = 0.2
@export var cursor_threshold = 5.0

var player: CharacterBody2D

func _ready() -> void:
	player = Global.player_instance
	#player = get_tree().get_first_node_in_group("player")
	
func _physics_process(_delta: float) -> void:
	#if player == null:
		#return
	
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

	move_and_slide()
	#$AnimatedSprite2D.look_at(target_position)
	#look_at(target_position)
