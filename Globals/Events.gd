extends Node

#signal game_over
#signal resume_game

signal got_speed_powerup

# bird/enemy related
signal spawned_bird
signal can_detect_bird
signal cannot_detect_bird
signal caught_by_a_bird
var is_player_caught: bool = false
signal no_longer_in_the_bird_area

signal healthChanged
