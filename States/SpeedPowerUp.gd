extends State
class_name SpeedPowerUp

@export var speed_multiplier: float = 1.8

var player: CharacterBody2D

func Enter():
	player = owner
	player.max_speed *= speed_multiplier # increasing the speed
	print("powerup: speed, max speed: ", player.max_speed)
	$"../../SpeedPowerUpTimer".start()


func Exit():
	# exiting the state, changing the speed back to normal
	player.max_speed /= speed_multiplier
	print("powerup expired, max speed: ", player.max_speed)


func _on_speed_power_up_timer_timeout() -> void:
	print("expired, bye")
	#Exit()
	Transitioned.emit(self, "PlayerNormal")
	$"../../SpeedPowerUpTimer".stop()
	
