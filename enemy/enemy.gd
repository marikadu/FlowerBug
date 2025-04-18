extends CharacterBody2D

@onready var flying_sprite: Sprite2D = $Flying_Sprite
@onready var shadow: AnimationPlayer = $shadow
@onready var bird: AnimationPlayer = $bird
@onready var bird_sprite: AnimatedSprite2D = $Bird_Sprite
@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D

@export var max_speed = 480.0
@export var slow_down_speed = 100.0
@export var min_speed = 50.0
@export var lerp_factor = 0.6
@export var cursor_threshold = 5.0

var player: CharacterBody2D
var can_move: bool
var can_detect_player: bool
var caught_bug_bool: bool = false
var leaving_count: int

signal has_landed
signal leaving
signal caught_bug

func _ready() -> void:
	
	Events.caught_by_a_bird.connect(_on_caught_by_a_bird)

	# For the variety, either have the sprite be flipped horizontally or not
	if randf() < 0.5:
		bird_sprite.flip_h = true
	
	bird_sprite.frame = 0
	leaving_count = 0
	can_move = true
	can_detect_player = false
	player = Global.player_instance
	$BirdAppearTimer.start()
	
	
func _physics_process(_delta: float) -> void:
	for area in $Area2D.get_overlapping_areas():
		# Do no land if the bird is on top of the sky area
		if area.is_in_group("prevent_land"):
			pass
	
	if can_move:
		var target_position = player.global_position
		var distance = global_position.distance_to(target_position)
		
		# Prevent character shaking when very close to the cursor
		if distance < cursor_threshold:
			velocity = velocity.lerp(Vector2.ZERO, 0.2)
		
		else:
			# Smooth movement
			# Ensuring the character does not shake when close to cursor
			var speed = lerp(min_speed, max_speed, distance / 50.0)
			speed = clamp(speed, min_speed, max_speed)
			
			var direction = (target_position - global_position).normalized()
			var target_velocity = direction * speed
			velocity = velocity.lerp(target_velocity, lerp_factor)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
	
	move_and_slide()
	

func _on_bird_appear_timer_timeout() -> void:
	var can_land = true
	for area in $Area2D.get_overlapping_areas():
		if area.is_in_group("prevent_land"):
			can_land = false
			break # Stop
			
	# If can land -> land
	if can_land:
		print("landing")
		_landing()
	
	# If cannot land -> continue following the player until the bird can land
	else:
		#print("Cannot land, delaying the timer")
		_delay_timer()
	
	
func _delay_timer():
	$BirdAppearTimer.set_wait_time(3) # Waiting for 3 more seconds


func _landing():
	$BirdAppearTimer.paused = true
	can_move = false
	await get_tree().create_timer(1.2, false).timeout
	shadow.play("coming")
	bird.play("landing")
	
	# Has landed
	await get_tree().create_timer(0.9, false).timeout
	emit_signal("has_landed")
	Events.can_detect_bird.emit()
	bird_sprite.frame = 1
	AudioManager.play_bird_landed()
	await get_tree().create_timer(0.2, false).timeout
	can_detect_player = true
	
	# When the bird does not catch the player
	if not caught_bug_bool:
		bird_sprite.play("not_caught")
		await get_tree().create_timer(1.7, false).timeout
		leaving_scene()
		# If the beetle was not detected after landing
		if not caught_bug_bool:
			leaving_scene()
			$BirdAppearTimer.paused = true
	
	
func _on_has_landed() -> void:
	pass


func _on_leaving() -> void:
	shadow.play("fly_away")
	can_detect_player = false
	await get_tree().create_timer(1.1, false).timeout
	queue_free()


# Bounce animation for better visuals
func _on_bird_sprite_frame_changed() -> void:
	bird.play("bounce")


# Detecting a player
func _on_caught_by_a_bird():
	if Events.is_player_caught:
		caught_bug_bool = true
		bird_sprite.play("caught")
		await get_tree().create_timer(0.8, false).timeout
		
		# If the bug is not in the area:
		bird_sprite.play("not_caught")
		await get_tree().create_timer(1.7, false).timeout
		# If the bug was not detected after landing
		leaving_scene()
	

func leaving_scene():
	if leaving_count < 1:
		if bird_sprite.frame == 3:
			bird.play("fly_away")
			AudioManager.play_bird_flying_away()
			AudioManager.play_bird_wings()
			Events.cannot_detect_bird.emit()
			Events.is_player_caught = false # Back to false
			emit_signal("leaving")
			leaving_count += 1
