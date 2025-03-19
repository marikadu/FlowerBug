extends CharacterBody2D

@onready var insect_area_2d: Area2D = $InsectArea2D
@onready var eating_timer: Timer = $EatingTimer
@onready var eating_bar: ProgressBar = $EatingBar
@onready var speed_power_up_timer: Timer = $SpeedPowerUpTimer


#@export var speed = 400.0
@export var max_speed = 760.0
@export var min_speed = 50.0
@export var lerp_factor = 0.2
@export var cursor_threshold = 5.0

var near_flower: bool
var flower_to_eat: Node2D = null
var powerup_to_get: Node2D = null
var is_eating: bool =  false
var identify_flower: String = ""

func _ready() -> void:
	eating_bar.hide()
	
func _physics_process(_delta: float) -> void:
	# character stops when it is eating
	if is_eating:
		#velocity = Vector2.ZERO
		velocity = velocity.lerp(Vector2.ZERO, 0.5)
		move_and_slide()
		return
	
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
			print("eating...")
			is_eating = true
			eating_timer.start()
			eating_bar.value = 0 # resetting the progress bar value
			eating_bar.show()
			#eat_flower(flower_to_eat)
			
		else:
			print("can't eat")
			

func _process(_delta: float) -> void:
	if is_eating:
		var percentage = (eating_timer.time_left / eating_timer.wait_time) * 100
		eating_bar.value = 100 - percentage

func _on_insect_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("flower"):
		near_flower = true
		flower_to_eat = body # detecting this specific flower
		#print("area: near flower")
		#print("area: ", near_flower)
		
	if body.is_in_group("powerup"):
		powerup_to_get = body # detecting this specific flower
		get_parent().remove_powerup(powerup_to_get)
		Events.got_speed_powerup.emit()


func _on_insect_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("flower"):
		near_flower = false
		flower_to_eat = null # clearing stored flower
		#print("area: ", near_flower)


func _on_eating_timer_timeout() -> void:
	if flower_to_eat:
		var flower_type = flower_to_eat.flower_type
		
		get_parent().remove_flower(flower_to_eat) # removing the flower
		print("ate!")
		
		eating_bar.hide() # hiding the progress bar
		near_flower = false
		is_eating = false
		
		identifyFlower(flower_type)
		print("score: ", Global.score)
		
		
#func _on_player_collected_power_up():
	## switching the state
	#Transitioned.emit(self, "SpeedPowerUp")
	#pass
	#_on_child_transition(current_state, "SpeedPowerUp")
	
# adding different point to the score depending on the flower type
func identifyFlower(flower_type: String):
	match flower_type:
		"flower_1":
			Global.score += 10
		
		"flower_2":
			Global.score += 20
			
		"_":
			print("insect: unknown flower type")
