extends CharacterBody2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = preload("res://player/insect.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_body_entered(body: Node2D) -> void:
	#if body == player:
		#print("detected player")
		#queue_free()
#
#
#func _on_area_entered(area: Area2D) -> void:
	#if area == player:
		#print("detected player")
		#queue_free()
	#pass # Replace with function body.


func _on_power_up_body_entered(body: Node2D) -> void:
	#if body == player:
	if body.is_in_group("player"):
		print("detected player")
		#queue_free()
