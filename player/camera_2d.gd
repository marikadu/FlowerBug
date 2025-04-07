extends Camera2D

# camera shake tutorial used: 
# https://www.youtube.com/watch?v=RVtcnkuNUIk

#@export var camera_lerp_speed: float = 0.1 # for the camera following cursor feature
@export var random_shake_strength: float = 30.0
@export var shake_decay_rate: float = 5.0
@export var noise_shake_speed: float = 30.0
@export var noise_shake_strength: float = 60.0

# generating a random number and the noise for the camera shake
var rng = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()

var noise_initial_location: float = 0.0
var shake_strength: float = 0.0

# note:
# zoom_increment := Vector2(1,1)
# is the same as 
# zoom_increment : bool = Vector2(1,1)

var zoom_increment := Vector2(0.01, 0.01) # how much the camera zooms in
var max_zoom := Vector2(1.6, 1.6) # maximum amount of zoom
var min_zoom := Vector2(1, 1) # minimum amount of zoom
var default_zoom = Vector2(1, 1)
var zoom_speed = 5 # speed for the smooth zoom
var target_zoom := Vector2(1, 1) # target zoom

var player: CharacterBody2D
var default_position: Vector2
var is_gameplay: bool


func _ready() -> void:
	
	await get_tree().process_frame # wait a frame before loading
	
	rng.randomize()
	noise.seed = rng.randi()
	noise.frequency = 0.5
	
	zoom = target_zoom # the starting zoom is deafult
	default_position = global_position # saving the default camera position
	
	# enable camera zoom in and zoom out functionality only during gameplay levels
	if Global.current_scene_name == 1 or Global.current_scene_name == 2 or Global.current_scene_name == 3 or Global.current_scene_name == 4 or Global.current_scene_name == 5:
		print("camera: normal level!")
		is_gameplay = true
		player = Global.player_instance # getting the player instance
		
	else:
		print("camera: cutscene")
		is_gameplay = false
		player = null
		
	#if is_gameplay:
		#player = Global.player_instance # getting the player instance
		#
	#else:
		#player = null


func _process(delta: float) -> void:
	#cameraUpdate()
	
	# camera shake
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	self.offset = get_noise_offset(delta)
	
	
	# smooth zooming in and out
	if is_gameplay:
		zoom = zoom.lerp(target_zoom, zoom_speed * delta)
	
	if is_gameplay:
		# if the player is eating, the camera slightly moves towards the player's direction
		if player: # if player exists
			if player.is_eating:
				var direction_to_player = player.position - global_position
				var move_distance = direction_to_player.normalized() * 0.1
				global_position += move_distance
				await get_tree().create_timer(0.3, false).timeout

			# resetting the camera position
			if not player.is_eating:
				var direction_to_default = default_position - global_position
				var move_distance = direction_to_default.normalized() * 0.1
				global_position += move_distance


## camera moves towards the cursor
## right now it does not work properly, making the controls extremely hard
#func cameraUpdate():
	#var target_cam_position = get_viewport().get_mouse_position()/10
	#global_position = global_position.lerp(target_cam_position, camera_lerp_speed)


# --- camera shake ---
func apply_shake() -> void:
	shake_strength = noise_shake_strength


func get_noise_offset(delta: float) -> Vector2:
	noise_initial_location += delta * noise_shake_speed # saving the data of where the camera is for smoother shake
	
	return Vector2(
		noise.get_noise_2d(1, noise_initial_location) * shake_strength,
		noise.get_noise_2d(100, noise_initial_location) * shake_strength
	)


func get_random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)



# --- camera zooming in ---
func zoom_camera_in():
	if is_gameplay:
		target_zoom += zoom_increment
		# restricting the zoom from going beyond the maximum
		target_zoom.x = clamp(target_zoom.x, min_zoom.x, max_zoom.x)
		target_zoom.y = clamp(target_zoom.y, min_zoom.y, max_zoom.y)
		print("target zoom: ", target_zoom)
	
	
func reset_zoom():
	if is_gameplay:
		target_zoom = default_zoom
		global_position = default_position
		print("zoom reset!")
