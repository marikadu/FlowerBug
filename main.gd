extends Node2D

@onready var spawn_area: Control = $SpawnArea

@export var min_flower_distance = 90.0 # in order for the flowers to not overlap

var flower_list = [
	preload("res://flower/flower_1.tscn"),
	preload("res://flower/flower_2.tscn")]
var flower_instances = []

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = preload("res://player/insect.tscn")
	var player_instance = player.instantiate()
	player_instance.position = get_viewport_rect().size/2
	add_child(player_instance)
	
	screen_size = get_viewport().get_visible_rect().size



## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func spawn_flower():
	var valid_position = false
	
	# flower spawning area
	var flower_area_2d = spawn_area.get_node("Area2D")
	var spawn_shape = flower_area_2d.get_node("CollisionShape2D")
	
	var rect = spawn_shape.shape.extents * 1.5
	var random_position: Vector2
	
	while not valid_position:
		# getting a random position
		var random_x = randf_range(-rect.x / 2, rect.x / 2)
		var random_y = randf_range(-rect.y / 2, rect.y / 2)
		random_position = spawn_area.global_position + Vector2(random_x, random_y)
		
		valid_position = true
		for flower in flower_instances:
			if flower.position.distance_to(random_position) < min_flower_distance:
				valid_position = false
				break 
	
	# choosing a random flower from the list
	var random_flower = flower_list[randi() % flower_list.size()]
	var flower_instance = random_flower.instantiate()
	
	flower_instance.position = random_position
	flower_instances.append(flower_instance) # store the instance in the list
	flower_instance.add_to_group("flower") # add to the flower group
	
	add_child(flower_instance)
	print("spawned flower")


func _on_flower_spawn_timer_timeout() -> void:
	if flower_instances.size() < 10:
		spawn_flower()
	else:
		print("too many flowers, don't spawn")
		$Flower_Spawn_Timer.stop()
		# ideally, stop the timer unless there are less than 10 flowers
		

# removing a flower when eaten
func remove_flower(flower: Node2D) -> void:
	if flower:
		flower_instances.erase(flower)
		flower.queue_free()
		print("removed flower: ", flower)
