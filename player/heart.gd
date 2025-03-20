extends TextureRect

@onready var sprite = $HeartSprite

func update(whole: bool):
	if whole:
		sprite.frame = 0
	else:
		sprite.frame = 1
