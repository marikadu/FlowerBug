extends CharacterBody2D

@onready var insect_area_2d: Area2D = $InsectArea2D
@onready var eating_timer: Timer = $EatingTimer
@onready var eating_bar: ProgressBar = $EatingBar
@onready var speed_power_up_timer: Timer = $SpeedPowerUpTimer
@onready var trapped_timer: Timer = $TrappedTimer
@onready var trapped_bar: ProgressBar = $TrappedBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



#@export var speed = 400.0
@export var max_speed = 760.0
@export var min_speed = 50.0
@export var lerp_factor = 0.2
@export var cursor_threshold = 5.0

var near_flower: bool
var near_carnivorous_flower: bool
var flower_to_eat: Node2D = null
var powerup_to_get: Node2D = null
var is_eating: bool =  false
var is_trapped: bool = false
var follow_cursor: bool
var see_mouse: bool
var identify_flower: String = ""
# storing the flowers nearby to prevent mistakes in getting to the wrong flower
var flowers_near: Array = [] 

func _ready() -> void:
	eating_bar.hide()
	trapped_bar.hide()
	follow_cursor = true
	see_mouse = true
	animated_sprite.play("flying")
	
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
	if Input.is_action_just_pressed("eat"):
		if near_flower:
			if flower_to_eat:
				if flower_to_eat.is_in_group("flower") and flower_to_eat.can_be_eaten:
					animated_sprite.play("eating")
					print("eating...")
					is_eating = true
					flower_to_eat.is_being_eaten = true
					flower_to_eat.start_eating()
					eating_timer.start()
					eating_bar.value = 0 # resetting the progress bar value
					eating_bar.show()
				
				if flower_to_eat.is_in_group("carnivorous"):
					print("received damage!!")
					is_trapped = true
					flower_to_eat.is_being_eaten = true
					flower_to_eat.trap_the_player()
					trapped_timer.start()
					trapped_bar.value = 0
					trapped_bar.show()
					
			
		else:
			print("can't eat")
			

func _process(_delta: float) -> void:
	if is_eating:
		var percentage = (eating_timer.time_left / eating_timer.wait_time) * 100
		eating_bar.value = 100 - percentage
		
	if is_trapped:
		var percentage = (trapped_timer.time_left / trapped_timer.wait_time) * 100
		trapped_bar.value = 100 - percentage

func _on_insect_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("flower") or body.is_in_group("carnivorous"):
		#near_flower = true
		flowers_near.append(body) # adding the nearby flowers to the group
		choose_closest_flower() # choosing the closest flower
		#flower_to_eat = body # detecting this specific flower
		#print("area: ", near_flower)
		
	if body.is_in_group("powerup"):
		powerup_to_get = body # detecting this specific flower
		get_parent().remove_powerup(powerup_to_get)
		Events.got_speed_powerup.emit()


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
	if is_instance_valid(flower_to_eat):
	#if flower_to_eat:
		var flower_type = flower_to_eat.flower_type
		
		get_parent().remove_flower(flower_to_eat) # removing the flower
		print("ate!")
		animated_sprite.play("flying")
		
		identifyFlower(flower_type)
		print("score: ", Global.score)
		
	eating_bar.hide() # hiding the progress bar
	near_flower = false
	is_eating = false
	follow_cursor = true
	
	choose_closest_flower() # finding another closest flower


func _on_trapped_timer_timeout() -> void:
	#if flower_to_eat:
	if is_instance_valid(flower_to_eat): 
		get_parent().remove_flower(flower_to_eat)
		
	trapped_bar.hide()
	near_flower = false
	is_trapped = false
	follow_cursor = true
	print("no longer trapped!")
	choose_closest_flower() # finding another closest flower

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
		"flower_1":
			Global.score += 10
		
		"flower_2":
			Global.score += 20
			
		"flower_3":
			print("damaged!")
			
		"_":
			print("insect: unknown flower type")
