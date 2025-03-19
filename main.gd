extends Node2D

@onready var spawn_area: Control = $SpawnArea

@export var min_flower_distance = 180.0 # adding a distance for the flowers to not overlap

# preloading a list of possible flowers to spawn
var flower_list = [
	preload("res://flowers/flower_1.tscn"),
	preload("res://flowers/flower_2.tscn")
	]
var flower_instances = [] # making an array empty from the start of the game

var carnivorous_list = [
	preload("res://flowers/flower_3.tscn")
	]
var carn_flower_instances = []

# preloading a list of possible power-ups to spawn
var powerup_list = [
	preload("res://powerUp/powerUp.tscn")
]
var powerup_instances = [] # making an array empty from the start of the game


var screen_size


func _ready() -> void:
	var player = preload("res://player/insect.tscn")
	var player_instance = player.instantiate()
	player_instance.position = get_viewport_rect().size/2
	add_child(player_instance)
	
	screen_size = get_viewport().get_visible_rect().size
	
	# randomizing the timer of spawning the flowers
	$Flower_Spawn_Timer.start(randi_range(3,6)) 


func spawn_flower():
	var random_position: Vector2
	var valid_position = false
	var spawn_flower_attempts = 10 # preventing a loop
	
	# flower spawning area
	var flower_area_2d = spawn_area.get_node("Area2D")
	var spawn_shape = flower_area_2d.get_node("CollisionShape2D")
	
	var rect = spawn_shape.shape.extents * 1.5 # spawning area for the flowers
	
	
	while not valid_position and spawn_flower_attempts > 0:
		# getting a random position
		var random_x = randf_range(-rect.x / 2, rect.x / 2)
		var random_y = randf_range(-rect.y / 2, rect.y / 2)
		random_position = spawn_area.global_position + Vector2(random_x, random_y)
		
		valid_position = true
		for flower in flower_instances:
			if flower.position.distance_to(random_position) < min_flower_distance:
				valid_position = false
				break 
	
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
		print("spawned flower")
	
	else:
		# choosing a random carnivorous flower from the list
		var random_carn_flower = carnivorous_list[randi() % carnivorous_list.size()]
		var carn_flower_instance = random_carn_flower.instantiate()
		
		carn_flower_instance.position = random_position
		carn_flower_instances.append(carn_flower_instance)
		carn_flower_instance.add_to_group("carnivorous")
		
		add_child(carn_flower_instance)
		print("spawned carnivorous flower")


func _on_flower_spawn_timer_timeout() -> void:
	$Flower_Spawn_Timer.start(randi_range(3,6)) 
	# limit of flowers on screen
	if flower_instances.size() + carn_flower_instances.size() < 10:
		spawn_flower()
	else:
		print("too many flowers, don't spawn")
		#$Flower_Spawn_Timer.stop()
		# ideally, stop the timer unless there are less than 10 flowers
		

# removing a flower when eaten
func remove_flower(flower: Node2D) -> void:
	if flower:
		flower_instances.erase(flower)
		flower.queue_free()
		print("removed flower: ", flower)


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
