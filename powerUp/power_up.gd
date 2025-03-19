extends CharacterBody2D

var player


func _ready() -> void:
	player = preload("res://player/insect.tscn")

#func _on_power_up_body_entered(body: Node2D) -> void:
	##if body == player:
	#if body.is_in_group("player"):
		#print("detected player")
		##queue_free()
