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
#var is_chasing_cutscene: bool = false

signal has_landed
signal leaving
signal caught_bug

func _ready() -> void:
	
	Events.caught_by_a_bird.connect(_on_caught_by_a_bird)

	# for the variety, either have the sprite be flipped horizontally or not
	if randf() < 0.5:
		bird_sprite.flip_h = true
	
	bird_sprite.frame = 0
	leaving_count = 0
	can_move = true
	can_detect_player = false
	player = Global.player_instance
	#player = get_tree().get_first_node_in_group("player")
	$BirdAppearTimer.start()
	#collision.disabled = true
	#bird.play("landing")
	
	
func _physics_process(_delta: float) -> void:
	
	for area in $Area2D.get_overlapping_areas():
		#if area == $BirdCantLandArea2D:
		if area.is_in_group("prevent_land"):
			#print("don't land area detected!")
			pass
	
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
		#look_at(player.position)
		
	else:
		#move_and_slide()
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
		
	move_and_slide()
	
	#if is_chasing_cutscene:
		#print("bird_physics: chase starts")
		#velocity.x = -max_speed # bird flies to the left of the screen


func _on_bird_appear_timer_timeout() -> void:
	var can_land = true
	for area in $Area2D.get_overlapping_areas():
		if area.is_in_group("prevent_land"):
			#print("don't land!")
			can_land = false
			break # stop
			
	# if can land -> land
	if can_land:
		print("landing")
		_landing()
	
	# if cannot land -> continue following the player until the bird can land
	else:
		#print("can't land, delaying the timer")
		_delay_timer()
	
	#for body in $Area2D.get_overlapping_bodies():
		#if body == player and can_detect_player:
			#print("got player immediately!")
			#emit_signal("caught_bug")
			#_on_area_2d_body_entered(player)
			#
		#if body.is_in_group("player") and can_detect_player:
			#print("bird group: got player!")
			#emit_signal("caught_bug")
			#_on_area_2d_body_entered(player)
	
	
func _delay_timer():
	print("delaying the timer")
	$BirdAppearTimer.set_wait_time(3, false) # waiting for 3 more seconds
	# maybe add some sort of sound here


func _landing():
	print("landing")
	$BirdAppearTimer.paused = true
	can_move = false
	await get_tree().create_timer(1.2, false).timeout
	shadow.play("coming")
	bird.play("landing")
	
	# has landed
	#print("landed")
	await get_tree().create_timer(0.9, false).timeout
	emit_signal("has_landed")
	Events.can_detect_bird.emit()
	bird_sprite.frame = 1
	AudioManager.play_bird_landed()
	#collision.disabled = false
	await get_tree().create_timer(0.2, false).timeout
	can_detect_player = true
	
	# when doesn't catch the player
	if not caught_bug_bool:
		bird_sprite.play("not_caught")
		await get_tree().create_timer(1.7, false).timeout
		leaving_scene()
		# if the bug wasn't detected after landing
		if not caught_bug_bool:
			leaving_scene()
			$BirdAppearTimer.paused = true
	
	
func _on_has_landed() -> void:
	#print("landed, true!")
	pass


func _on_leaving() -> void:
	#print("leaving, true!")
	shadow.play("fly_away")
	#collision.disabled = true
	can_detect_player = false
	await get_tree().create_timer(1.1, false).timeout
	queue_free()


func _on_bird_sprite_frame_changed() -> void:
	bird.play("bounce")


func _on_caught_by_a_bird():
	if Events.is_player_caught:
		caught_bug_bool = true
		#print("catch player! catch player!")
		bird_sprite.play("caught")
		await get_tree().create_timer(0.8).timeout
		
		# if the bug is not in the area:
		bird_sprite.play("not_caught")
		await get_tree().create_timer(1.7).timeout
		# if the bug wasn't detected after landing
		leaving_scene()
		
		# but if bug is in the area:
		# bird_sprite.play("caught")
		
		
#func _on_no_longer_in_the_bird_area():
	#bird_sprite.play("not_caught")
	#await get_tree().create_timer(1.7).timeout
	## if the bug wasn't detected after landing
	#leaving_scene()
	

func leaving_scene():
	if leaving_count < 1:
		if bird_sprite.frame == 3:
			#print("time to leave")
			#print("leaving")
			bird.play("fly_away")
			AudioManager.play_bird_flying_away()
			AudioManager.play_bird_wings()
			Events.cannot_detect_bird.emit()
			Events.is_player_caught = false # back to false
			#await get_tree().create_timer(1).timeout
			emit_signal("leaving")
			leaving_count += 1
			
			
#func _on_bird_chases_the_beetle():
	#can_move = false
	#is_chasing_cutscene = true
	#print("chase starts")
	
