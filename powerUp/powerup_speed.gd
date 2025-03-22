extends CharacterBody2D

@export var powerup_type: String = "speed"

var rng: RandomNumberGenerator

func _ready() -> void:
	# random rotation of the power-up
	rng = RandomNumberGenerator.new()
	var random_rotation = rng.randi_range(-101, 10)
	$PowerUpSprite.rotation = random_rotation
	
	# for the variety,
	# either have the sprite be flipped horizontally or not
	if randf() < 0.5:
		$PowerUpSprite.flip_h = true
