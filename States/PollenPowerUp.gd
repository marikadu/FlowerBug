extends State
class_name PollenPowerUp

@export var pollen_multiplier: float = 2

var player: CharacterBody2D

func Enter():
	player = owner
	Global.is_score_multiplied = true # activating
	Global.current_multiplier = pollen_multiplier
	#player.max_speed *= pollen_multiplier # increasing the speed
	print("powerup: pollen, multiplier")
	$"../../ScorePowerUpTimer".start()


func Exit():
	# exiting the state, changing the speed back to normal
	Global.is_score_multiplied = false
	Global.current_multiplier = 1.0 # resetting
	print("powerup expired, max speed: ", player.max_speed)


func _on_score_power_up_timer_timeout() -> void:
	#print("expired, bye")
	Transitioned.emit(self, "PlayerNormal") # back to the normal state
	$"../../ScorePowerUpTimer".stop()
