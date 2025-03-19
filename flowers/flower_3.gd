extends CharacterBody2D

@export var flower_type: String = "flower_3"
var player: CharacterBody2D
var is_being_eaten: bool = false

signal is_eaten_status(is_eaten: bool)

func _ready() -> void:
	$DisappearTimer.start()
	player = Global.player_instance

func _on_disappear_timer_timeout() -> void:
	if not is_being_eaten:
		self.queue_free()
		
func trap_the_player():
	$DisappearTimer.stop()
	is_being_eaten = true
	is_eaten_status.emit(true)
