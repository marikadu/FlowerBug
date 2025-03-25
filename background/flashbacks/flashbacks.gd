extends Control

@onready var f1: Sprite2D = $"1"
@onready var f2: Sprite2D = $"2"
@onready var f3: Sprite2D = $"3"

@onready var f4: Sprite2D = $"4"
@onready var f5: Sprite2D = $"5"
@onready var f6: Sprite2D = $"6"

@onready var f7: Sprite2D = $"7"
@onready var f8: Sprite2D = $"8"
@onready var f9: Sprite2D = $"9"


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Events.show_flashback_1.connect(_on_show_flashback_1)
	Events.show_flashback_2.connect(_on_show_flashback_2)
	Events.show_flashback_3.connect(_on_show_flashback_3)
	
	f1.visible = false
	f2.visible = false
	f3.visible = false
	
	f4.visible = false
	f5.visible = false
	f6.visible = false
	
	f7.visible = false
	f8.visible = false
	f9.visible = false


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("1_debugging"):
		print("starting animation")
		animation_player.play("flashback_1")
		f1.visible = true
		f2.visible = true
		f3.visible = true


func _on_show_flashback_1():
	await get_tree().create_timer(2.5).timeout # do not show the flashback right away
	print("starting animation 1")
	animation_player.play("flashback_1")
	f1.visible = true
	f2.visible = true
	f3.visible = true


func _on_show_flashback_2():
	await get_tree().create_timer(2.5).timeout # do not show the flashback right away
	print("starting animation 2")
	animation_player.play("flashback_2")
	f4.visible = true
	f5.visible = true
	f6.visible = true


func _on_show_flashback_3():
	await get_tree().create_timer(2.5).timeout # do not show the flashback right away
	print("starting animation 3")
	animation_player.play("flashback_3")
	f7.visible = true
	f8.visible = true
	f9.visible = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flashback_1":
		print("animation 1 has finished")
		f1.visible = false
		f2.visible = false
		f3.visible = false
		await get_tree().create_timer(2.5).timeout
		_on_show_flashback_2()
		
	elif anim_name == "flashback_2":
		print("animation 2 has finished")
		f4.visible = false
		f5.visible = false
		f6.visible = false
		
	elif anim_name == "flashback_3":
		print("animation 3 has finished")
		f7.visible = false
		f8.visible = false
		f9.visible = false
