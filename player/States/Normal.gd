extends State
class_name PlayerNormal

@export var max_speed = 710.0


func _ready() -> void:
	Events.got_speed_powerup.connect(_on_collected_speed)
	Events.got_pollen_powerup.connect(_on_collected_pollen)


func _on_collected_speed():
	# changing the state, adding to the new_state list
	Transitioned.emit(self, "SpeedPowerUp")


func _on_collected_pollen():
	# changing the state, adding to the new_state list
	Transitioned.emit(self, "PollenPowerUp")
