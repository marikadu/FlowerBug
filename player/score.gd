extends Control

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var arrow: Sprite2D = $Arrow
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var shaking = false
var shake_intensity = 1.0
var original_position: Vector2 # saving the original position, so the score does not fly off screen
var infinite_mode: bool = false
var arrow_appeared: bool = false


func _ready() -> void:
	
	Events.can_continue.connect(_on_can_continue)
	
	Events.shaking_1.connect(_on_shake_1)
	Events.shaking_2.connect(_on_shake_2)
	Events.shaking_3.connect(_on_shake_3)
	
	$Label.visible = false
	arrow.visible = false
	arrow_appeared = false
	
	# wait a frame before loading
	await get_tree().process_frame
	
	if Global.current_scene_name == 5:
		infinite_mode = true
		$Label.visible = true


func _process(_delta: float) -> void:
	
	if not infinite_mode: # if the story mode
		# setting the value of the progress bar to be the score
		progress_bar.value = Global.score
	
	else: # if the infinite mode
		$Label.text = str(Global.score)


func _on_texture_progress_bar_value_changed(value: float) -> void:
	# setting the label as the score
	$Label.text = str(Global.score)
	
	if not infinite_mode:
		# finished filling the bar signal
		if Global.score >= progress_bar.max_value:
			Events.has_collected_all_pollen.emit()
			print("score: progress bar complete!")


func start_shaking():
	original_position = global_position
	shaking = true
	shake()


func stop_shaking():
	shaking = false
	global_position = original_position


func shake():
	if shaking:
		var offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		var tween = create_tween()
		#tween.tween_property(self, "position", global_position + offset, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "position", original_position + offset, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_callback(shake)


# progress bar shaking
func _on_shake_1():
	shake_intensity = 1.0
	start_shaking()
	
func _on_shake_2():
	if not shaking:
		start_shaking()
	shake_intensity = 3.0
	
func _on_shake_3():
	if not shaking:
		start_shaking()
	shake_intensity = 6.0
	

func _on_can_continue():
	# arrow only appears on levels 1, 2, 3
	if not Global.current_scene_name == 4 and not Global.current_scene_name == 5:
		if not arrow_appeared:
			arrow_appeared = true
			print("can continue!")
			arrow.visible = true
			animation_player.play("arrow_appear")
			await get_tree().create_timer(0.5, false).timeout
			animation_player.play("arrow_loop")
