extends Node2D

# the source of the sound is written nearby the function of this sound
@onready var rain_sound: AudioStreamPlayer = $rain


# created in Bfxr
func play_hit():
	$hit.play()

# https://freesound.org/people/straget/sounds/418102/
func play_bird_spawned():
	$bird_spawned.play()
	
# https://freesound.org/people/shatterstars/sounds/651319/
func play_bird_landed():
	$bird_landed.play()
	
func play_bird_attacking():
	$bird_attacking_beak.play()

# same source as the previous sound
func play_bird_flying_away():
	$bird_flying_away.play()
	
# https://freesound.org/people/ChuckleNutsDev/sounds/718668/
func play_bird_wings():
	$bird_wings.play()

# https://freesound.org/people/dynamique/sounds/554561/
func collect_pollen():
	$collect_pollen.play()
	
# https://freesound.org/people/Mateusz_Chenc/sounds/504139/
func collected_pollen():
	$collected_pollen.play()
	
# https://freesound.org/people/benniknop/sounds/317848/
func flower_bloomed():
	$flower_bloomed.play()
	
# https://freesound.org/people/watercool/sounds/403898/
func play_got_trapped():
	$got_trapped.play()
	
	
	
# https://freesound.org/people/sagamusix/sounds/700358/
func rain_play():
	$rain.play()


## cutscene related

# https://freesound.org/people/naturenotesuk/sounds/510996/
func angry_bird_play():
	$angry_bird.play()
	
# https://freesound.org/people/xkeril/sounds/609772/
func water_drop_play():
	$water_dtop.play()

# generated noice in Audacity and slowed it down
func empty_play():
	$empty.play
