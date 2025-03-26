extends Control

var player: CharacterBody2D

func _ready() -> void:
	player = Global.player_instance


func _on_mouse_entered() -> void:
	print("mouse_inside")
	#player.see_mouse = true
	#pass # Replace with function body.


func _on_mouse_exited() -> void:
	print("mouse_outside")
	#player.see_mouse = false
	#pass # Replace with function body.
