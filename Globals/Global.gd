extends Node

var player_instance
var is_game_over: bool
var is_game_won: bool

var score: int = 0
var personal_best = 0
var current_scene_name: int

var levels = []
var unlocked_levels = 1

var is_score_multiplied: bool = false
var current_multiplier = 1.0 # Default multiplier

var speed_power_up_active: bool  = false

var has_started_the_game: bool = false
var paint_was_washed_off: bool = false
var has_completed_the_game: bool = false

var is_music_mute: bool = false
var is_sound_mute: bool = false

# Update personal best score
func update_personal_best():
	if score > personal_best:
		personal_best = score


func add_score(pollen: int):
	var final_pollen: int = pollen * current_multiplier
	score += final_pollen
	score = max(score, 0) # The score does not go bellow 0
