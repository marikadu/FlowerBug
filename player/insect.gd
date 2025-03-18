extends CharacterBody2D

@onready var insect_area_2d: Area2D = $InsectArea2D

#@export var speed = 400.0
@export var max_speed = 690.0
@export var min_speed = 50.0
@export var lerp_factor = 0.2
@export var cursor_threshold = 5.0

var near_flower: bool
var flower_to_eat: Node2D = null
	
func _physics_process(_delta: float) -> void:
	var target_position = get_global_mouse_position()
	var distance = global_position.distance_to(target_position)
	
	if distance < cursor_threshold:
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
	
	else:
		var speed = lerp(min_speed, max_speed, distance / 50.0)
		speed = clamp(speed, min_speed, max_speed)
		
		var direction = (target_position - global_position).normalized()
		var target_velocity = direction * speed
	
	#if velocity.length() > 50:
		#velocity = velocity.normalized() * speed
		#
	
		velocity = velocity.lerp(target_velocity, lerp_factor)
	
	move_and_slide()
	#look_at(target_position)
	
	# eating a flower
	if Input.is_action_just_pressed("eat"):
		if near_flower:
			print("eat!")
			#eat_flower(flower_to_eat)
			get_parent().remove_flower(flower_to_eat)
			near_flower = false
		else:
			print("can't eat")


#func eat_flower(flower: Node2D) -> void:
	#if flower:
		#print("ate flower:", flower)
		#flower.queue_free()  # removing the flower from the scene


func _on_insect_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("flower"):
		near_flower = true
		flower_to_eat = body # detecting this specific flower
		#print("area: near flower")
		print("area: ", near_flower)


func _on_insect_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("flower"):
		near_flower = false
		flower_to_eat = null # clearing stored flower
		print("area: ", near_flower)
