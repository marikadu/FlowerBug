extends Node2D

# level 3

@onready var spawn_area: Control = $SpawnArea
@onready var hearts_container: HBoxContainer = $CanvasLayer/HeartsContainer
@onready var continue_collision: CollisionShape2D = $ContinueArea2D/CollisionShape2D
@onready var game_over_screen: ColorRect = $CanvasLayer/GameOver

@export var min_flower_distance = 170.0 # adding a distance for the flowers to not overlap

# preloading a list of possible flowers to spawn
var flower_list = [
	preload("res://flowers/n_flower_1.tscn"),
	preload("res://flowers/n_flower_2.tscn"),
	preload("res://flowers/n_flower_3.tscn"),
	preload("res://flowers/n_flower_4.tscn")]
var flower_instances = [] # making an array empty from the start of the game

var carnivorous_list = [
	preload("res://flowers/c_flower_1.tscn"),
	preload("res://flowers/c_flower_2.tscn"),
	preload("res://flowers/c_flower_3.tscn")]
var carn_flower_instances = []

# preloading a list of possible power-ups to spawn
var powerup_list = [
	preload("res://powerUp/powerup_speed.tscn"),
	preload("res://powerUp/powerup_pollen.tscn")
]
var powerup_instances = [] # making an array empty from the start of the game

var screen_size
var can_spawn_bird: bool
var bird_already_present: bool
var bird_spawned_count: int = 0
var pansy_spawn_count: int = 0

func _ready() -> void:
	
	Events.cannot_detect_bird.connect(_on_enemy_left)
	Events.can_continue.connect(_on_can_continue)
	Events.has_collected_all_pollen.connect(_on_has_filled_pollen_bar)
	Events.bird_chases_the_beetle.connect(_on_bird_chases_the_beetle)
	Events.game_over.connect(_on_game_over)
	#Events.show_flashback_3.connect(_on_show_flashback_3)
	#Events.flashback_3_finished.connect(_on_flashback_3_finished)
	
	Global.current_scene_name = 3
	Global.is_game_over = false
	Global.score = 0 # resetting the score
	
	bird_already_present = false
	can_spawn_bird = true
	
	continue_collision.disabled = true # can't continue
	
	$RainGPUParticles2D.emitting = false
	
	var player = preload("res://player/insect.tscn")
	var player_instance = player.instantiate()
	player_instance.position = get_viewport_rect().size/2
	player_instance.add_to_group("player")
	add_child(player_instance)
	
	# positioning the spawn area to the centre of the screen
	#$SpawnArea.position = get_viewport_rect().size/2
	$Camera2D.position = get_viewport_rect().size/2
	
	# storing the player instance in Global
	Global.player_instance = player_instance
	
	screen_size = get_viewport().get_visible_rect().size
	
	# randomizing the timer of spawning the flowers
	$Flower_Spawn_Timer.wait_time = randi_range(1,2) 
	
	# randomizing the enemy spawn timer
	$Enemy_Spawn_Timer.wait_time = randi_range(11,17) 
	
	# from the start, setting the amount of hearts based on the max health
	hearts_container.setMaxHearts(player_instance.max_health)
	hearts_container.updateHearts(player_instance.current_health)
	Events.healthChanged.connect(hearts_container.updateHearts)


	AudioManager.play_game_theme() # start playing music
	AudioManager.on_start_playing_the_game()

func spawn_flower():
	var random_position: Vector2
	var valid_position = false
	var spawn_flower_attempts = 10 # preventing a loop
	
	# flower spawning area
	var flower_area_2d = spawn_area.get_node("Area2D")
	var spawn_shape = flower_area_2d.get_node("CollisionShape2D")
	
	var rect = spawn_shape.shape.extents * 1.5 # spawning area for the flowers
	
	# removing any invalid flower instances
	flower_instances = flower_instances.filter(is_instance_valid)
	carn_flower_instances = carn_flower_instances.filter(is_instance_valid)
	
	while not valid_position and spawn_flower_attempts > 0:
		# getting a random position
		var random_x = randf_range(-rect.x / 2, rect.x / 2)
		var random_y = randf_range(-rect.y / 2, rect.y / 2)
		random_position = spawn_area.global_position + Vector2(random_x, random_y)
		
		valid_position = true
		# checking the position for normal flowers
		# if no valid position is found, chaning valid_position to false
		# and breaking out of the for loop to try again in the while loop
		for flower in flower_instances:
			if flower.position.distance_to(random_position) < min_flower_distance:
				valid_position = false
				break 
		
		# checking the position for carnivorous flowers
		for carn_flower in carn_flower_instances:
			if carn_flower.position.distance_to(random_position) < min_flower_distance:
				valid_position = false
				break 
				
		spawn_flower_attempts -= 1  # reducing the number of attemps
		
		
	if not valid_position:
		print("can't find a position for the flower")
		return
	
	# randomly choosing a normal or carnivorous flower
	# 70% normal flower, 30% carnivorous
	if randf() < 0.7:
		# choosing a random normal flower from the list
		var random_flower = flower_list[randi() % flower_list.size()]
		var flower_instance = random_flower.instantiate()
		
		flower_instance.position = random_position
		flower_instances.append(flower_instance) # store the instance in the list
		flower_instance.add_to_group("flower") # add to the flower group
	
		add_child(flower_instance)
		#print("spawned flower")
	
	else:
		# choosing a random carnivorous flower from the list
		var random_carn_flower = carnivorous_list[randi() % carnivorous_list.size()]
		var carn_flower_instance = random_carn_flower.instantiate()
		
		carn_flower_instance.position = random_position
		carn_flower_instances.append(carn_flower_instance)
		carn_flower_instance.add_to_group("carnivorous")
		
		add_child(carn_flower_instance)
		#print("spawned carnivorous flower")


func _on_flower_spawn_timer_timeout() -> void:
	$Flower_Spawn_Timer.wait_time = randi_range(1,2) 
	$Flower_Spawn_Timer.start()
	# limit of flowers on screen
	if flower_instances.size() + carn_flower_instances.size() < 10:
		spawn_flower()
	else:
		print("too many flowers, don't spawn")
		#$Flower_Spawn_Timer.stop()
		# ideally, stop the timer unless there are less than 10 flowers
		

# removing a flower when eaten
func remove_flower(flower: Node2D) -> void:
	#if flower:
	if flower and is_instance_valid(flower):
		if flower.is_in_group("flower"):
			flower_instances.erase(flower)
		elif flower.is_in_group("carnivorous"):
			carn_flower_instances.erase(flower)
		
		flower.queue_free()
		#print("removed flower: ", flower)


func remove_powerup(powerup: Node2D) -> void:
	if powerup:
		powerup_instances.erase(powerup)
		powerup.queue_free()
		print("got powerup: ", powerup)
		

func spawn_powerup():
	var powerup_area2d = spawn_area.get_node("Area2D")
	var spawn_shape = powerup_area2d.get_node("CollisionShape2D")
	
	var rect = spawn_shape.shape.extents * 1.5
	var random_position: Vector2
	
	var random_x = randf_range(-rect.x / 2, rect.x / 2)
	var random_y = randf_range(-rect.y / 2, rect.y / 2)
	random_position = spawn_area.global_position + Vector2(random_x, random_y)
	
	var random_powerup = powerup_list[randi() % powerup_list.size()]
	var powerup_instance = random_powerup.instantiate()
	
	powerup_instance.position = random_position
	powerup_instances.append(powerup_instance) # store the instance in the list
	powerup_instance.add_to_group("powerup") # add to the powerup group
	
	add_child(powerup_instance)
	#print("powerup: spawned")
	

func _on_power_up_spawn_timer_timeout() -> void:
	spawn_powerup()
	

func spawn_enemy():
	if not Global.is_game_over: # do not spawn a bird when game over
		if can_spawn_bird: # preventing the bird from spawning when the pollen is collected
			#if bird_spawned_count < 1:
				#print("show flashback")
				#Events.show_flashback_3.emit()
				
			#else:
				#print ("don't show the flashback")
			
			if not bird_already_present:
				bird_spawned_count += 1
				Events.spawned_bird.emit()
				AudioManager.play_bird_spawned()
				bird_already_present = true
				var enemy = preload("res://enemy/enemy.tscn")
				var enemy_instance = enemy.instantiate()
				enemy_instance.position = get_viewport_rect().size
				enemy_instance.add_to_group("enemy")
				add_child(enemy_instance)
				await get_tree().create_timer(6, false).timeout # do not spawn pansy right away
				spawn_pansy()
				print("spawn pansy!!")
			else:
				print("don't spawn bird, already present")


func _on_timer_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()
	$Enemy_Spawn_Timer.wait_time = randi_range(11,17) 
	$Enemy_Spawn_Timer.start()
	#$Enemy_Spawn_Timer.stop()

func _on_enemy_left():
	bird_already_present = false


func _on_can_continue():
	continue_collision.disabled = false
	
func _on_has_filled_pollen_bar():
	can_spawn_bird = false
	bird_already_present = false
	$Enemy_Spawn_Timer.stop() # stopping the bird spawn timer
	$RainGPUParticles2D.emitting = true # rain starts
	AudioManager.rain_sound.volume_db = -30.0
	AudioManager.rain_play()
	await get_tree().create_timer(0.4).timeout
	AudioManager.rain_sound.volume_db = -25.0
	await get_tree().create_timer(0.4).timeout
	AudioManager.rain_sound.volume_db = -20.0

	
	
func _on_bird_chases_the_beetle():
	can_spawn_bird = true
	#spawn_enemy()
	call_deferred("spawn_enemy")
	#set_deferred("can_spawn_bird", true)


# time slows down when the flashback appears
#func _on_show_flashback_3():
	#$Flower_Spawn_Timer.wait_time = randi_range(14,18) 
#
#
#func _on_flashback_3_finished():
	#await get_tree().create_timer(0.6, false).timeout
	#print("start spawning")
	#$Flower_Spawn_Timer.wait_time = randi_range(1,2) 


func spawn_pansy():
	print("pansy has spawned!!")
	if pansy_spawn_count < 1:
		pansy_spawn_count += 1
		print("pansy spawned")
		var pansy = preload("res://flowers/n_flower_5.tscn")
		var pansy_instance = pansy.instantiate()
		pansy_instance.position = Vector2(1074, 269)
		pansy_instance.add_to_group("flower")
		add_child(pansy_instance)
		

func _on_game_over():
	game_over_screen.show()
	Global.is_game_over = true
