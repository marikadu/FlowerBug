@icon("res://icons/player_icon.png")
# custom player icon for the Godot editor

extends CharacterBody2D


@onready var insect_area_2d: Area2D = $InsectArea2D
@onready var eating_timer: Timer = $EatingTimer
@onready var eating_bar: TextureProgressBar = $EatingBar
@onready var speed_power_up_timer: Timer = $SpeedPowerUpTimer
@onready var score_power_up_timer: Timer = $ScorePowerUpTimer
@onready var trapped_timer: Timer = $TrappedTimer
@onready var trapped_bar: TextureProgressBar = $TrappedBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D2
@onready var clean_sprite: AnimatedSprite2D = $CleanSprite2D
@onready var hit_flash: AnimationPlayer = $HitFlashAnimationPlayer

@onready var camera_control = get_tree().root.get_node("main/Camera2D")

# movement related
@export var max_speed = 760.0
@export var min_speed = 50.0
@export var lerp_factor = 0.2
@export var cursor_threshold = 5.0

@export var bites_required: int = 0 # how many times the player would need to click in order to collect the flower pollen
#@export var max_distance_for_the_flower = 100
@export var border_margin: int = 50 # for the player to not be able to move the beetle outside of the viewport
@export var can_continue_score: int = 10 # for debugging it's 20, but it should be 100

#var flower_to_eat: Node2D = null # variable for the detected flower
var normal_flower_to_eat: Node2D = null # variable for the detected flower
var carnivorous_flower_to_eat: Node2D = null # variable for the detected flower


var powerup_to_get: Node2D = null # variable for the detected power-up

#var near_flower: bool
#var near_carnivorous_flower: bool
var is_eating: bool =  false
var is_trapped: bool = false
var insect_can_eat: bool
var follow_cursor: bool
var see_mouse: bool
var can_detect_bird: bool
var is_caught = false
var is_shaking: bool # shake effect for when the bird appears
var voulnerable: bool # doesn't constantly gets dameged if close to the bird
var continue_scene: bool # can continue after collecting the needed pollen
var is_alive: bool = true
var has_collected_all_pollen: bool = false

var rng: RandomNumberGenerator
var rng_clicks: RandomNumberGenerator

var identify_flower: String = ""
# storing the flowers nearby to prevent mistakes in getting to the wrong flower
#var flowers_near: Array = [] 
var hearts_list: Array[TextureRect]
var max_health = 3
var current_health: int

var current_bite_counter : int = 0
var shake_strength: float = 1.2

func _ready() -> void:
	
	Events.can_detect_bird.connect(_on_can_detect_bird)
	Events.cannot_detect_bird.connect(_on_stop_detect_bird)
	Events.spawned_bird.connect(_on_spawned_bird)
	Events.has_collected_all_pollen.connect(_on_has_filled_pollen_bar)
	
	eating_bar.hide()
	trapped_bar.hide()
	follow_cursor = true
	see_mouse = true
	insect_can_eat = true
	can_detect_bird = false
	is_shaking = false
	voulnerable = true
	continue_scene = false
	
	rng = RandomNumberGenerator.new() # to randomize score or "pollen"
	rng_clicks = RandomNumberGenerator.new() # to randomize amount of clicks required
	
	current_health = max_health # setting current health to be maximum from start
	current_health = clamp(current_health, 0, max_health) # health can't go less than 0 and more than 3
	
	#$Bird.global_position.x = clamp($Bird.global_position.x, bounds_bw, bounds_fw)
	#self.global_position.x = clamp

	
	await get_tree().process_frame # wait a frame before loading
	
	if Global.paint_was_washed_off: # if in story the paint is washed off
		#print("paint has been washed off")
		$CleanSprite2D.visible = true
		animated_sprite.visible = false
		$CleanSprite2D.play("flying")
		animated_sprite = $CleanSprite2D
	else:
		#print("paint is on")
		$CleanSprite2D.visible = false
		animated_sprite.visible = true
		animated_sprite.play("flying")
		animated_sprite = $AnimatedSprite2D2
	
	#animated_sprite.play("flying")
	#animated_sprite.visible = true
	#$CleanSprite2D.visible = false
	
func _physics_process(_delta: float) -> void:
	if is_alive: # moving only when alive
	
		# restricting the player from moving outside of the borders of the game
		# getting the viewport sizes
		var viewport = get_viewport()
		var viewport_rect = viewport.get_visible_rect()
		# clamping the position
		var clamped_position = global_position
		clamped_position.x = clamp(global_position.x, viewport_rect.position.x + border_margin, viewport_rect.position.x + viewport_rect.size.x - border_margin)
		clamped_position.y = clamp(global_position.y, viewport_rect.position.y + border_margin, viewport_rect.position.y + viewport_rect.size.y - border_margin)
		
		global_position = clamped_position
		
		# beetle stops following the cursor when it is eating/collecting pollen
		if is_eating and normal_flower_to_eat:
			follow_cursor = false
			# smoothly stops at the centre of the flower
			global_position = global_position.lerp(normal_flower_to_eat.global_position, 0.1)
			#return
		
		# the beetle does not follow the cursor when it is trapped
		if is_trapped and carnivorous_flower_to_eat:
			follow_cursor = false
			# smoothly stops at the centre of the flower
			global_position = global_position.lerp(carnivorous_flower_to_eat.global_position, 0.1)
		
		# the character follows the mouse cursor
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
			
				move_and_slide() # telling CharacterBody2D to respond to the movement
				animated_sprite.look_at(target_position) # the sprite rotates towards the player's mouse cursor
		
		# eating a flower
		if Input.is_action_just_pressed("eat") and insect_can_eat:
			if normal_flower_to_eat: # if the flower is normal
				if normal_flower_to_eat.is_in_group("flower") and normal_flower_to_eat.can_be_eaten:
					# changing the sprite depending whether the player has collected the needed pollen or not
					if has_collected_all_pollen:
						animated_sprite.play("eating_full")
					else:
						animated_sprite.play("eating")
					
					is_eating = true
					normal_flower_to_eat.is_being_eaten = true
					normal_flower_to_eat.start_eating()
					eating_bar.value = 0 # resetting the EatingBar value
					eating_bar.show()
					#print("is eating: ", normal_flower_to_eat)
					#print("eating...")
					
					
			# if the flower is carnivorous
			if carnivorous_flower_to_eat:
				if carnivorous_flower_to_eat.is_in_group("carnivorous") and carnivorous_flower_to_eat.can_be_eaten:
					var bounce_animation_count = 0 # resetting the bounce count
					AudioManager.play_got_trapped()
					carnivorous_flower_to_eat.animation_player.play("bounce")
					carnivorous_flower_to_eat.animated_sprite.play("trapped")
					# creating an illusion of sprite changing
					# by hiding the sprite, since the insect has already 
					# been drawn on the flower's sprite
					animated_sprite.hide()
					is_trapped = true
					# restricting the beetle from eating that flower
					# since it would reset the TrappedBar every time
					insect_can_eat = false 
					can_detect_bird = false
					carnivorous_flower_to_eat.is_being_eaten = true
					carnivorous_flower_to_eat.trap_the_player()
					trapped_timer.start()
					trapped_bar.value = 0 # resetting the "TrappedBar" value
					trapped_bar.show()
					# bouncing animation when the player is trapped
					# creating an effect of the beetle trying to get out
					while bounce_animation_count < 7:
						carnivorous_flower_to_eat.animation_player.play("bounce")
						bounce_animation_count += 1
						await get_tree().create_timer(0.4, false).timeout
			#else:
				#print("can't eat")


func _process(_delta: float) -> void:
	# the player is eating/collecting the pollen by clicking the mouse multiple times
	if is_eating:
		
		if bites_required == 0: # every time getting the new number, since the initial number is 0
			
			# different ranges of bites required to collect pollen for each level
			if Global.current_scene_name == 1:
				bites_required = rng_clicks.randi_range(3, 6)
				print("bites_required: ", bites_required)
				
			if Global.current_scene_name == 2:
				bites_required = rng_clicks.randi_range(2, 15)
				print("bites_required: ", bites_required)
				
			if Global.current_scene_name == 3:
				bites_required = rng_clicks.randi_range(3, 9)
				print("bites_required: ", bites_required)
				
			if Global.current_scene_name == 4:
				bites_required = rng_clicks.randi_range(3, 11)
				print("bites_required: ", bites_required)
				
			if Global.current_scene_name == 5:
				bites_required = rng_clicks.randi_range(2, 13)
				print("bites_required: ", bites_required)
		
		if Input.is_action_just_pressed("eat"):
			AudioManager.collect_pollen()
			current_bite_counter += 1 
			#Camera2D.zoom_camera_in()
			camera_control.zoom_camera_in()
	
			eating_bar.value = (current_bite_counter / float(bites_required)) * 100
			
			if current_bite_counter >= bites_required:
				ate_the_flower()
				current_bite_counter = 0 # resetting the counter
				bites_required = 0 # resetting the number of clicks required
				
		if Input.is_action_just_pressed("stop_eating"):
			stop_eating_the_flower()
		
	if is_trapped:
		# the TrapperBar is a timer and the player has to wait if they get trapped
		var percentage = (trapped_timer.time_left / trapped_timer.wait_time) * 100
		trapped_bar.value = 100 - percentage
		
	# couldn't find a better solution, so now
	# the player always checks if they are in
	# the body area
	if not is_caught:
		for body in $InsectArea2D.get_overlapping_bodies():
			if body.is_in_group("enemy"):
				if can_detect_bird:
					#print("insect: detected bird!")
					Events.caught_by_a_bird.emit()
					Events.is_player_caught = true
					take_damage()
					
	# the insect starts to shake when the bird spawns
	if is_alive and is_shaking and not is_trapped:
		var shake_offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
		global_position += shake_offset * 3


# when the beetle enters the body collission
func _on_insect_area_2d_body_entered(body: Node2D) -> void:
	# --- flowers ---
	if body.is_in_group("flower"):
		normal_flower_to_eat = body # detecting this specific normal flower
		print("noticed body: ", normal_flower_to_eat)
		
	if body.is_in_group("carnivorous"):
		carnivorous_flower_to_eat = body # detecting this specific carnivorous flower
		print("noticed carnivorous body: ", carnivorous_flower_to_eat)
		
	# --- power-ups ---
	if body.is_in_group("powerup"):
		powerup_to_get = body # detecting this specific power-up
		AudioManager.play_pick_up() # play sound
		# if the player picks up the speed power-up
		if powerup_to_get.powerup_type == "speed":
			AudioManager.play_speed_power_up()
			get_parent().remove_powerup(powerup_to_get)
			Events.got_speed_powerup.emit()
			# if the player gets the speed power-up again
			if speed_power_up_timer.time_left > 0:
				speed_power_up_timer.start(13) 
			# if the player does not have a speed boost and gets the speed power-up
			else:
				Events.got_speed_powerup.emit()
				# entering the state of speed boost
				$StateMachine.enter_state($StateMachine.states["SpeedPowerUp"])
			
		# same for the pollen multiplier power-up
		elif powerup_to_get.powerup_type == "pollen":
			AudioManager.play_pollen_power_up()
			get_parent().remove_powerup(powerup_to_get)
			Events.got_pollen_powerup.emit()
			if score_power_up_timer.time_left > 0:
				score_power_up_timer.start(10) 
			else:
				Events.got_pollen_powerup.emit()
				# entering the state of pollen/score multiplier
				$StateMachine.enter_state($StateMachine.states["PollenPowerUp"])
		
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


# when the beetle exits the body collission of the flowers
func _on_insect_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("flower"):
		print("left body: ", normal_flower_to_eat)
		normal_flower_to_eat = null # clearing stored flower
		
	if body.is_in_group("carnivorous"):
		print("left carnivorous body: ", carnivorous_flower_to_eat)
		carnivorous_flower_to_eat = null # clearing stored flower
		
		# there is a problem present that when the player overlaps with the new
		# flower and exits the previous flower, the beetle clears the
		# stored flower and thus it cannot see the collision of the
		# next flower
		# to fix that, the distance of the flowers was increased in the
		# scripts of the levels

func _on_eating_timer_timeout() -> void:
	ate_the_flower()

# when the beetle finishes eating/collecting the pollen from the flower
func ate_the_flower():
	if is_instance_valid(normal_flower_to_eat):
		var flower_type = normal_flower_to_eat.flower_type
		#
		get_parent().remove_flower(normal_flower_to_eat) # removing the flower
		AudioManager.collected_pollen() # playing the sound
		identifyFlower(flower_type) # identifying the flower type
		print("ate!")
		camera_control.reset_zoom()
		# changing the sprite depending whether the player has collected all the pollen
		if has_collected_all_pollen:
			animated_sprite.play("flying_full")
		else:
			animated_sprite.play("flying")

		#print("score: ", Global.score)
	eating_bar.hide() # hiding the progress bar
	#near_flower = false
	is_eating = false
	follow_cursor = true
	

func stop_eating_the_flower():
	pass
	#if is_instance_valid(flower_to_eat):
		##var flower_type = flower_to_eat.flower_type
		#
		##get_parent().remove_flower(flower_to_eat) # removing the flower
		##print("stopped eating!")
		#if has_collected_all_pollen:
			#animated_sprite.play("flying_full")
		#else:
			#animated_sprite.play("flying")
		#
		#
	#eating_bar.hide() # hiding the progress bar
	#near_flower = false
	#is_eating = false
	#follow_cursor = true
	#current_bite_counter = 0 # resetting the counter
	#flower_to_eat.stop_eating()


func _on_trapped_timer_timeout() -> void:
	if is_instance_valid(carnivorous_flower_to_eat): # if the carnivorous flower is valid
		get_parent().remove_flower(carnivorous_flower_to_eat) # removing the flower from the scene
		identifyFlower(carnivorous_flower_to_eat.flower_type) # identifying the flower
		
	trapped_bar.hide()
	is_trapped = false # beetle is no longer trapped
	insect_can_eat = true # beetle can eat again
	follow_cursor = true
	
	## if the player is trapped
	## and the bird is near,
	## also take damage from the bird
	#can_detect_bird = true 

	animated_sprite.show() # showing the sprite again
	print("no longer trapped!")
	take_damage()


# adding different point to the score depending on the flower type
func identifyFlower(flower_type: String):
	var random_pollen_amount = rng.randi_range(1, 6) # initial score
	#var random_pollen_amount = rng.randi_range(20, 40) # for debugging
	match flower_type:
		"n_flower_1", "n_flower_2", "n_flower_3", "n_flower_4":
			# the insect earns pollen
			Global.add_score(random_pollen_amount)
			if Global.score >= can_continue_score:
				level_4_system() # level 4 system is called but only executed if the level is 4
				#print("win!")
				if not Events.flashback_playing:
					Events.can_continue.emit()
				
		"n_flower_5":
			Global.add_score(20)
			if Global.current_scene_name == 2:
				Events.show_flashback_1.emit()
				AudioManager.silence_music()
				if Global.score >= can_continue_score:
					if not Events.flashback_playing:
						Events.can_continue.emit()
						
			elif Global.current_scene_name == 3:
				Global.add_score(25)
				print("emit flashback 3!")
				Events.show_flashback_3.emit()
				if Global.score >= can_continue_score:
					if not Events.flashback_playing:
						Events.can_continue.emit()
			
		"c_flower_1", "c_flower_2", "c_flower_3":
			#print("damaged! flower")
			# the insect loses the polen when hit
			Global.score -= random_pollen_amount
			#take_damage()
			
		"n_flower_1_tutorial":
			Global.add_score(16)
			Events.ate_tutorial_flower.emit()
			
		"_":
			print("insect: unknown flower type")


func take_damage():
	if voulnerable: # only receive damage when voulnerable
	# ensuring it doesn't go less than 0
		if current_health > 0:
			var random_pollen_amount = rng.randi_range(2, 7)
			AudioManager.play_hit()
			AudioManager.play_bird_attacking()
			hit_flash.play("hit_flash")
			current_health -= 1
			Events.healthChanged.emit(current_health)
			print("current health: ", current_health)
			voulnerable = false
			$VoulnerableTimer.start()
			# the insect loses some of the pollen, and can't go bellow 0
			Global.score = clamp(Global.score - random_pollen_amount, 0, Global.score)
			# game over when current health reaches 0
			if current_health == 0:
				# don't instantly send the signal
				is_alive = false
				#insect_can_eat = false
				can_detect_bird = false
				voulnerable = false
				Events.game_over.emit()
				await get_tree().create_timer(0.2).timeout
				
				# playing different sprites whether the player has or has not collected the pollen
				if has_collected_all_pollen:
					animated_sprite.play("game_over_full")
					await get_tree().create_timer(1.2).timeout
					animated_sprite.play("game_over_full_loop")
				else:
					animated_sprite.play("game_over")
					await get_tree().create_timer(1.2).timeout
					animated_sprite.play("game_over_loop")
				
				print("game over!")
			
			
func _on_can_detect_bird():
	can_detect_bird = true
	#print("can detect: ", can_detect_bird)
	
func _on_stop_detect_bird():
	can_detect_bird = false
	#print("can detect: ", can_detect_bird)
	is_shaking = false
	# slowly reduce the shake to 0.0 with the weight of 0.01
	shake_strength = lerp(shake_strength, 0.0, 0.01)


func _on_voulnerable_timer_timeout() -> void:
	voulnerable = true

func _on_spawned_bird():
	#print("aa birdv")
	is_shaking = true
	


func _on_insect_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("continue"):
		continue_scene = true
		print("win win!")
		
		# loading different cutscenes depending on the current level
		if Global.current_scene_name == 1:
			# transition to the new scene
			Transition.transition()
			await Transition.on_transition_finished
			get_tree().change_scene_to_file("res://cutscenes/cutscene_1.tscn")
			
		elif Global.current_scene_name == 2:
			# transition to the new scene
			Transition.transition()
			await Transition.on_transition_finished
			get_tree().change_scene_to_file("res://cutscenes/cutscene_2.tscn")
			
		elif Global.current_scene_name == 3:
			# bird chases after the beetle
			Events.bird_chases_the_beetle.emit()
			await get_tree().create_timer(0.5).timeout
			# transition to the new scene
			Transition.transition()
			await Transition.on_transition_finished
			get_tree().change_scene_to_file("res://cutscenes/cutscene_3.tscn")
			
			#Transition.transition()
			#await Transition.on_transition_finished
			#get_tree().change_scene_to_file("res://cutscenes/cutscene_3.tscn")
			
		else:
			print("playing inside the 'main'!")


func _on_has_filled_pollen_bar():
	if not Global.current_scene_name == 5: # if not the infinite mode
		print("insect: has filled the bar!")
		has_collected_all_pollen = true
	
	
func level_4_system():
	if Global.current_scene_name == 4: # only in the level 4
		print("insect: level 4 system!")
		
		if Global.score > 120 and Global.score < 140:
			print("!!! shake!")
			Events.shaking_1.emit()
			
		elif Global.score > 140 and Global.score < 160:
			print("!!! shake! more")
			Events.shaking_2.emit()
		
		elif Global.score > 160 and Global.score < 185:
			print("!!! shake! MORE")
			Events.shaking_3.emit()
			
		elif Global.score > 185:
			print("!!!!! explode!")
			Events.shaking_4.emit()
