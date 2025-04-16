extends Control

@onready var player_logo: AnimationPlayer = $AnimationPlayerLogo
@onready var player_beetle: AnimationPlayer = $AnimationPlayerBeetle
@onready var player_bird: AnimationPlayer = $AnimationPlayerBird
@onready var level_selection: Control = $LevelSelection/LevelSelectionList
@onready var pb_score: Label = $LevelSelection/PersonalBest/PBScore


# Main menu + Level selection

func _ready() -> void:
	player_logo.play("Logo")
	player_beetle.play("beetle")
	player_bird.play("bird")
	
	if Global.paint_was_washed_off: # If the paint is washed off due to the story
		$Beetle.play("no_paint")
	else:
		$Beetle.play("with_paint")
		
	for level in level_selection.get_children():
		 # Connecting the levels to the button hover sound
		if not level.mouse_entered.is_connected(_on_level_hover): # preventing multiple connections
			level.mouse_entered.connect(_on_level_hover.bind(level))
			
		# Enable or disable based on the number of unlocked levels
		var is_unlocked = str_to_var(level.name) in range(Global.unlocked_levels + 1)
		level.disabled = not is_unlocked
		
		if level.disabled:
			level.text = "" # Do not show level name if the level is disabled
			
	# Show personal best score if the infinite day is unlocked
	if Global.unlocked_levels == 5:
		$LevelSelection/PersonalBest.visible = true
	else:
		$LevelSelection/PersonalBest.visible = false
		
	
	AudioManager.play_game_theme()
	AudioManager.on_main_menu()
			
func _process(_delta: float) -> void:
	pb_score.text = str(Global.personal_best)
	
	if Input.is_action_just_pressed("2_debugging"):
		Global.unlocked_levels = 5
	
	

func _on_play_pressed() -> void:
	## When the player first starts the game, the game starts straight to the first level
	#if not Global.has_started_the_game:
		#Global.has_started_the_game = true
		#Transition.transition()
		#await Transition.on_transition_finished
		#get_tree().change_scene_to_file("res://levels/level_1.tscn")

	#else:
	$AnimationPlayerCamera.play("camera")


func _on_exit_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().quit()


# --- Level selection part ---

func _on_back_pressed() -> void:
	$AnimationPlayerCamera.play_backwards("camera")


# Level 1
func _on_morning_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_1.tscn")


# Level 2
func _on_noon_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_2.tscn")


# Level 3
func _on_evening_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_3.tscn")


# Level 4
func _on_dawn_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_4.tscn")


# Level "main", infinite mode
func _on_infinite_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/main.tscn")
	

func _on_level_hover(level: Button) -> void:
	if not level.disabled:  # Playing the sound only when the button is enabled
		#AudioManager.play_button_hover()
		pass
