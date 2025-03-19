extends State
class_name PlayerNormal

@export var max_speed = 710.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.got_speed_powerup.connect(_on_collected_speed)


func _on_collected_speed():
	# changing the state
	Transitioned.emit(self, "SpeedPowerUp")
