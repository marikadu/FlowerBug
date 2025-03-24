extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# different background depending on the current level
	if Global.current_scene_name == 1:
		$BgSky.frame = 0
		
	elif Global.current_scene_name == 2:
		$BgSky.frame = 1
		
	elif Global.current_scene_name == 3:
		$BgSky.frame = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
