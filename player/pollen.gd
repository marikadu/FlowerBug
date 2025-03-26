extends Control

@onready var pollen_animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	self.visible = false
	Events.shaking_4.connect(_on_shaking_4)
	
func _on_shaking_4():
	pollen_animation_player.play("filled_with_pollen")
	# wait a frame before loading
	await get_tree().process_frame
	self.visible = true
