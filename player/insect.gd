@icon("res://icons/player_icon.png")
# custom player icon for the Godot editor

extends CharacterBody2D


@onready var insect_area_2d: Area2D = $InsectArea2D
@onready var eating_timer: Timer = $EatingTimer
@onready var eating_bar: ProgressBar = $EatingBar
@onready var speed_power_up_timer: Timer = $SpeedPowerUpTimer
@onready var trapped_timer: Timer = $TrappedTimer
@onready var trapped_bar: ProgressBar = $TrappedBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_flash: AnimationPlayer = $HitFlashAnimationPlayer
#@onready var h_box: HBoxContainer = $CanvasLayer/HBoxContainer
#@onready var hearts_container: HBoxContainer = $CanvasLayer/HeartsContainer


@export var max_speed = 760.0
@export var min_speed = 50.0
@export var lerp_factor = 0.2
@export var cursor_threshold = 5.0
@export var bites_required: int = 4


var near_flower: bool
var near_carnivorous_flower: bool
var flower_to_eat: Node2D = null
var powerup_to_get: Node2D = null
var is_eating: bool =  false
var is_trapped: bool = false
var insect_can_eat: bool
var follow_cursor: bool
var see_mouse: bool
var can_detect_bird: bool
var is_caught = false
var voulnerable: bool # doesn't constantly gets dameged if close to the bird

var identify_flower: String = ""
# storing the flowers nearby to prevent mistakes in getting to the wrong flower
var flowers_near: Array = [] 
var hearts_list: Array[TextureRect]
var max_health = 3
var current_health: int

var current_bite_counter : int = 0

func _ready() -> void:
	
	Events.can_detect_bird.connect(_on_can_detect_bird)
	Events.cannot_detect_bird.connect(_on_stop_detect_bird)
	
	eating_bar.hide()
	trapped_bar.hide()
	follow_cursor = true
	see_mouse = true
	insect_can_eat = true
	can_detect_bird = false
	voulnerable = true
	animated_sprite.play("flying")
	
	# setting current health to be maximum from start
	current_health = max_health
	# health can't go less than 0 and more than 3
	current_health = clamp(current_health, 0, max_health)
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_MAX)
	
func _physics_process(_delta: float) -> void:
	
	# character stops when it is eating
	if is_eating and flower_to_eat:
		follow_cursor = false
		global_position = global_position.lerp(flower_to_eat.global_position, 0.1)
		#velocity = Vector2.ZERO
		#velocity = velocity.lerp(Vector2.ZERO, 0.5)
		#move_and_slide()
		return
		
	if is_trapped and flower_to_eat:
		follow_cursor = false
		global_position = global_position.lerp(flower_to_eat.global_position, 0.1)
	
	# the character follows the mouse cursor
	#var target_position = get_global_mouse_position()
	if see_mouse:
		if follow_cursor:
			var target_position = get_viewport().get_mouse_position()
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
			$AnimatedSprite2D.look_at(target_position)
			#look_at(target_position)
	
	# eating a flower
	if Input.is_action_just_pressed("eat") and insect_can_eat:
		if near_flower:
			if flower_to_eat:
				if flower_to_eat.is_in_group("flower") and flower_to_eat.can_be_eaten:
					animated_sprite.play("eating")
					print("eating...")
					is_eating = true
					flower_to_eat.is_being_eaten = true
					flower_to_eat.start_eating()
					#eating_timer.start()
					eating_bar.value = 0 # resetting the progress bar value
					eating_bar.show()
					print("is eating: ", is_eating)
				
				if flower_to_eat.is_in_group("carnivorous"):
					var bounce_animation_count = 0 # resetting
					# changing the sprite to being trapped
					flower_to_eat.animation_player.play("bounce")
					flower_to_eat.animated_sprite.play("trapped")
					# creating an illusion of sprite changing
					# by hiding the sprite, since the insect has already 
					# been drawn on the flower's sprite
					$AnimatedSprite2D.hide() 
					print("received damage!!")
					is_trapped = true
					insect_can_eat = false
					can_detect_bird = false
					flower_to_eat.is_being_eaten = true
					flower_to_eat.trap_the_player()
					trapped_timer.start()
					trapped_bar.value = 0
					trapped_bar.show()
					# bouncing animation when the player is trapped
					# creating an effect of the character trying to get out
					while bounce_animation_count < 7:
						flower_to_eat.animation_player.play("bounce")
						bounce_animation_count += 1
						await get_tree().create_timer(0.4).timeout
						#print(i)
					
			
		else:
			print("can't eat")
			
			

func _process(_delta: float) -> void:
	if is_eating:
		if Input.is_action_just_pressed("eat"):
			current_bite_counter += 1 
			eating_bar.value = (current_bite_counter / float(bites_required)) * 100
			#print("eating progress: ", eating_bar.value)
			
			if current_bite_counter >= bites_required:
				ate_the_flower()
				current_bite_counter = 0 # resetting the counter
				
		if Input.is_action_just_pressed("stop_eating"):
			stop_eating_the_flower()
		
	if is_trapped:
		var percentage = (trapped_timer.time_left / trapped_timer.wait_time) * 100
		trapped_bar.value = 100 - percentage
		
	# couldn't find a better solution, so now
	# the player always checks if they are in
	# the body area
	if not is_caught:
		for body in $InsectArea2D.get_overlapping_bodies():
			if body.is_in_group("enemy"):
				if can_detect_bird:
					print("insect: detected bird!")
					Events.caught_by_a_bird.emit()
					Events.is_player_caught = true
					take_damage()

func _on_insect_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("flower") or body.is_in_group("carnivorous"):
		flowers_near.append(body) # adding the nearby flowers to the group
		choose_closest_flower() # choosing the closest flower
		#flower_to_eat = body # detecting this specific flower
		#print("area: ", near_flower)
		
	if body.is_in_group("powerup"):
		powerup_to_get = body # detecting this specific power-up
		get_parent().remove_powerup(powerup_to_get)
		Events.got_speed_powerup.emit()
		
	#if body.is_in_group("enemy"):
		#if body.can_detect_player:
		#if body not in enemy_near:
			#enemy_near.append(body)
		#if can_detect_bird and body.can_detect_player:
			#print("on body entered insect: detected bird!")
			#Events.caught_by_a_bird.emit()
			#take_damage()
			
	#for body_b in $InsectArea2D.get_overlapping_bodies():
		##if body_b.is_in_group("enemy"):
			##if body_b not in enemy_near:
				##enemy_near.append(body_b)
				##print("seeing a bird:", body_b)
				#
		#if body_b and body_b.can_detect_player:
			#print("insect: detected bird!")
			#Events.caught_by_a_bird.emit()
			#take_damage()


func _on_insect_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("flower"):
		#near_flower = false
		flowers_near.erase(body) # remove the nearby flower from the list
		choose_closest_flower()
		flower_to_eat = null # clearing stored flower
		#print("area: ", near_flower)
		
	if body.is_in_group("carnivorous"):
		near_flower = false
		flower_to_eat = body # detecting this specific flower


func _on_eating_timer_timeout() -> void:
	ate_the_flower()


func ate_the_flower():
	if is_instance_valid(flower_to_eat):
		var flower_type = flower_to_eat.flower_type
		
		get_parent().remove_flower(flower_to_eat) # removing the flower
		#print("ate!")
		animated_sprite.play("flying")
		
		identifyFlower(flower_type)
		#print("score: ", Global.score)
		
	eating_bar.hide() # hiding the progress bar
	near_flower = false
	is_eating = false
	follow_cursor = true
	

func stop_eating_the_flower():
	if is_instance_valid(flower_to_eat):
		#var flower_type = flower_to_eat.flower_type
		
		#get_parent().remove_flower(flower_to_eat) # removing the flower
		print("stopped eating!")
		animated_sprite.play("flying")
		
		
	eating_bar.hide() # hiding the progress bar
	near_flower = false
	is_eating = false
	follow_cursor = true
	current_bite_counter = 0 # resetting the counter
	flower_to_eat.stop_eating()


func _on_trapped_timer_timeout() -> void:
	#if flower_to_eat:
	if is_instance_valid(flower_to_eat): 
		get_parent().remove_flower(flower_to_eat)
		
	trapped_bar.hide()
	near_flower = false
	is_trapped = false
	insect_can_eat = true
	
	## if the player is trapped
	## and the bird is near,
	## also take damage from the bird
	#can_detect_bird = true 

	$AnimatedSprite2D.show()
	follow_cursor = true
	print("no longer trapped!")
	choose_closest_flower() # finding another closest flower
	take_damage()

func choose_closest_flower():
	# removing invalid flowers
	flowers_near = flowers_near.filter(func(flower): return is_instance_valid(flower))
	# if no nearby flowers, clear the list
	if flowers_near.is_empty():
		flower_to_eat = null
		near_flower = false
		return
	
	var closest_flower = flowers_near[0] # the first flower
	var min_distance = global_position.distance_to(closest_flower.global_position)
	
	for flower in flowers_near:
		var distance = global_position.distance_to(flower.global_position)
		if distance < min_distance:
			closest_flower = flower
			min_distance = distance
		
	flower_to_eat = closest_flower
	near_flower = true

# adding different point to the score depending on the flower type
func identifyFlower(flower_type: String):
	match flower_type:
		"n_flower_1":
			Global.score += 10
		
		"n_flower_2":
			Global.score += 20
			
		"n_flower_3":
			Global.score += 20
			
		"n_flower_4":
			Global.score += 20
			
		"c_flower_1", "c_flower_2", "c_flower_3":
			print("damaged! flower")
			#take_damage()
			
		"_":
			print("insect: unknown flower type")


func take_damage():
	if voulnerable: # only receive damage when voulnerable
	# ensuring it doesn't go less than 0
		if current_health > 0:
			AudioManager.play_hit()
			hit_flash.play("hit_flash")
			current_health -= 1
			Events.healthChanged.emit(current_health)
			print("current health: ", current_health)
			voulnerable = false
			$VoulnerableTimer.start()
			# game over when current health reaches 0
			if current_health == 0:
				# don't instantly send the signal
				# add a death animation
				await get_tree().create_timer(0.02).timeout
				print("game over!")
			
			
func _on_can_detect_bird():
	can_detect_bird = true
	print("can detect: ", can_detect_bird)
	
func _on_stop_detect_bird():
	can_detect_bird = false
	print("can detect: ", can_detect_bird)


func _on_voulnerable_timer_timeout() -> void:
	voulnerable = true
