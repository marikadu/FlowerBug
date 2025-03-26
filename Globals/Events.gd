extends Node

#signal game_over
signal resume_game

signal can_continue

signal got_speed_powerup
signal got_pollen_powerup
signal healthChanged

signal has_collected_all_pollen

# bird/enemy related
signal spawned_bird
signal can_detect_bird
signal cannot_detect_bird
signal caught_by_a_bird
var is_player_caught: bool = false
signal no_longer_in_the_bird_area

signal bird_chases_the_beetle

signal show_flashback_1
signal show_flashback_2
signal show_flashback_3


# score progress bar shaking
signal shaking_1
signal shaking_2
signal shaking_3
signal shaking_4
