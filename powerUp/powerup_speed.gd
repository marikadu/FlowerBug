extends CharacterBody2D

@export var powerup_type: String = "speed"

var rng: RandomNumberGenerator

func _ready() -> void:
	# Random rotation of the power-up
	rng = RandomNumberGenerator.new()
	var random_rotation = rng.randi_range(-101, 10)
	$PowerUpSprite.rotation = random_rotation
	
	# For the variety,
	# either have the sprite be flipped horizontally or not
	if randf() < 0.5:
		$PowerUpSprite.flip_h = true


func _on_disappear_timer_timeout() -> void:
	if self:
		get_parent().remove_flower(self)
