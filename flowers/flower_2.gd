extends CharacterBody2D

#@onready var flower_area_2d: Area2D = $FlowerArea2D
@export var flower_type: String = "flower_2"

var player: CharacterBody2D

func _ready() -> void:
	pass # Replace with function body.
	#player = get_tree().root.get_node("main/insect")


#func _on_flower_area_2d_body_entered(body: Node2D) -> void:
	#if body == player:
		#print("near flower")
		#
		#if Input.is_action_just_pressed("eat"):
			#print("eatt!")
		
		
