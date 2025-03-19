extends Node

var player_instance
var is_game_over : bool

var score = 0
var personal_best = 0

# update personal best score
func update_personal_best():
	if score > personal_best:
		personal_best = score
