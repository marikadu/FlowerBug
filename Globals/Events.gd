extends Node

# States of the game
signal game_over
signal game_won
signal resume_game
signal ate_tutorial_flower

signal can_continue
signal got_speed_powerup
signal got_pollen_powerup
signal healthChanged
signal has_collected_all_pollen

# Bird/enemy related
signal spawned_bird
signal can_detect_bird
signal cannot_detect_bird
signal caught_by_a_bird
signal no_longer_in_the_bird_area
var is_player_caught: bool = false

# Story related
signal show_flashback_1
signal show_flashback_3
signal flashback_3_finished
var flashback_playing: bool = false
signal bird_chases_the_beetle
signal pansy_flower_1

# Score progress bar shaking effect for the Level 4
signal shaking_1
signal shaking_2
signal shaking_3
signal shaking_4
