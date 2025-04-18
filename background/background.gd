extends Control


@onready var clouds_morning: TextureRect = $Clouds_morning
@onready var clouds_noon: TextureRect = $Clouds_noon
@onready var clouds_evening: TextureRect = $Clouds_evening
@onready var clouds_infinite: TextureRect = $Clouds_infinite


func _ready() -> void:
	clouds_morning.visible = false
	clouds_noon.visible = false
	clouds_evening.visible = false
	clouds_infinite.visible = false
	
	# Wait a frame before loading
	await get_tree().process_frame
	
	# Different background depending on the current level
	if Global.current_scene_name == 1:
		$BgSky.frame = 0
		clouds_morning.visible = true
		
	elif Global.current_scene_name == 2:
		$BgSky.frame = 1
		clouds_noon.visible = true
		
	elif Global.current_scene_name == 3:
		$BgSky.frame = 2
		clouds_evening.visible = true
		
	elif Global.current_scene_name == 5:
		clouds_infinite.visible = true
