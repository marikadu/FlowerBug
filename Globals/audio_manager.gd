extends Node2D

# the source of the sound is written nearby the function of this sound
@onready var rain_sound: AudioStreamPlayer = $rain

func _ready() -> void:
	Events.game_over.connect(_on_game_over)
	Events.game_won.connect(_on_game_won)


# created in Bfxr
func play_hit():
	$hit.play()

# created in Bfxr
func play_pick_up():
	$pick_up.play()
	
# mix of the following:
# created in Bfxr
# https://freesound.org/people/Sadiquecat/sounds/742955/
# https://freesound.org/people/Nightflame/sounds/422495/
func play_speed_power_up():
	$speed_power_up.play()
	
# mix of the following:
# created in Bfxr
# https://freesound.org/people/Sadiquecat/sounds/742955/
func play_pollen_power_up():
	$pollen_power_up.play()
	
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

## --- music ---
func play_game_theme():
	$GameTheme.play()
	
	
func silence_music():
	$GameTheme.volume_db = -10.0
	
	
func music_volume_normal():
	$GameTheme.volume_db = -3.0
	
	
func on_start_playing_the_game():
	$GameTheme["parameters/switch_to_clip"] = "Loop"
	
	
func on_main_menu():
	$GameTheme["parameters/switch_to_clip"] = "MainMenu"
	
	
func _on_game_won():
	$GameTheme["parameters/switch_to_clip"] = "GameWon"
	
	
func _on_game_over():
	#if not Global.is_game_over:
	$GameTheme["parameters/switch_to_clip"] = "GameOver"
	

func cutscene_start():
	$GameTheme["parameters/switch_to_clip"] = "Silence"


## --- cutscene related ---

# created in Bfxr
func play_notices():
	$notices.play()
	
# https://freesound.org/people/konstati/sounds/646849/
func play_eating():
	$eating.play()

# created in Bfxr
func angry_bee():
	$angry_bee.play()

# https://freesound.org/people/naturenotesuk/sounds/510996/
func angry_bird_play():
	$angry_bird.play()
	
# https://freesound.org/people/xkeril/sounds/609772/
func water_drop_play():
	$water_dtop.play()

# generated noice in Audacity and slowed it down
func empty_play():
	$empty.play()
	
# https://freesound.org/people/PostProdDog/sounds/578491/
func door_opening():
	$door_opening.play()
