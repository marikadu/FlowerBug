extends CharacterBody2D

@onready var insect_area_2d: Area2D = $InsectArea2D

#@export var speed = 400.0
@export var max_speed = 690.0
@export var min_speed = 50.0
@export var lerp_factor = 0.2
@export var cursor_threshold = 5.0

var near_flower: bool
	
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


func _on_insect_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("flower"):
		print("insect: near flower")
		near_flower = true
		
		if Input.is_action_just_pressed("eat"):
			print("eatt!")
		
	else:
		near_flower = false
	#pass # Replace with function body.
