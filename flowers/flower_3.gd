extends CharacterBody2D

@export var flower_type: String = "flower_3"
var player: CharacterBody2D
var is_being_eaten: bool = false
var can_be_eaten: bool

signal is_eaten_status_3(is_eaten: bool)

func _ready() -> void:
	$DisappearTimer.start()
	player = Global.player_instance
	can_be_eaten = false

func _on_disappear_timer_timeout() -> void:
	if not is_being_eaten:
		#self.queue_free()
		get_parent().remove_flower(self)
		
func trap_the_player():
	$DisappearTimer.stop()
	is_being_eaten = true
	is_eaten_status_3.emit(true)
