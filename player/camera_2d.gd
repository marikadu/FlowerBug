extends Camera2D
# camera is disabled, in the properties

@export var camera_lerp_speed: float = 0.1
@export var random_shake_strength: float = 30.0
@export var shake_decay_rate: float = 5.0
@export var noise_shake_speed: float = 30.0
@export var noise_shake_strength: float = 60.0


var rng = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()

var noise_i: float = 0.0
var shake_strength: float = 0.0

func _ready() -> void:
	rng.randomize()
	
	noise.seed = rng.randi()
	noise.frequency = 0.5

# camera follows the cursor
func _process(delta: float) -> void:
	#cameraUpdate()
	#pass
	
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	self.offset = get_noise_offset(delta)
		
func cameraUpdate():
	var target_cam_position = get_viewport().get_mouse_position()/10
	global_position = global_position.lerp(target_cam_position, camera_lerp_speed)


func apply_shake() -> void:
	shake_strength = noise_shake_strength


func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed
	
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)

func get_random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
