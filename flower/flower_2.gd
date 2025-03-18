extends CharacterBody2D

@onready var flower_area_2d: Area2D = $FlowerArea2D


var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#player = get_tree().root.get_node("main/insect")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



#func _on_flower_area_2d_body_entered(body: Node2D) -> void:
	#if body == player:
		#print("near flower")
		#
		#if Input.is_action_just_pressed("eat"):
			#print("eatt!")
		
		
