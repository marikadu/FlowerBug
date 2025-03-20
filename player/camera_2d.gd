extends Camera2D
# camera is disabled, in the properties

@export var camera_lerp_speed: float = 0.1

# camera follows the cursor
func _process(_delta: float) -> void:
	cameraUpdate()
		
func cameraUpdate():
	var target_cam_position = get_viewport().get_mouse_position()
	global_position = global_position.lerp(target_cam_position, camera_lerp_speed)
