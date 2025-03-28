extends Node2D

# the source of the sound is written nearby the function of this sound

# created in Bfxr
func play_hit():
	$hit.play()

# https://freesound.org/people/straget/sounds/418102/
func play_bird_spawned():
	$bird_spawned.play()

# https://freesound.org/people/dynamique/sounds/554561/
func collect_pollen():
	$collect_pollen.play()
