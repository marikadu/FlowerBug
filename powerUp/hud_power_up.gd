extends Control


@onready var speed_time: Label = %SpeedTime
@onready var score_time: Label = %ScoreTime
@onready var speed_sprite: Sprite2D = $SpeedSprite
@onready var score_sprite: Sprite2D = $ScoreSprite

var player: CharacterBody2D
var timer_speed: Timer
var timer_pollen: Timer


func _ready() -> void:
	await get_tree().process_frame # waiting before getting the player instance and the timer
	player = Global.player_instance
	
	# getting the timer nodes from the player
	timer_speed = player.get_node("SpeedPowerUpTimer") 
	timer_pollen = player.get_node("ScorePowerUpTimer")
	
	# from the start of the game, the timers are hidden
	speed_time.visible = false
	score_time.visible = false
	# so are the sprites
	speed_sprite.visible = false
	score_sprite.visible = false
	
	update_timer_display()
	
	timer_speed.timeout.connect(_on_timer_speed_timeout)
	timer_pollen.timeout.connect(_on_timer_pollen_timeout)
	
func _process(delta: float) -> void:
	update_timer_display()
	
func update_timer_display():
	#var seconds = int(timer_speed.time_left) # saving seconds to integar
	#speed_time.text = "%02d" % [seconds]
	
	# for the speed power-up, show when active
	if timer_speed and timer_speed.time_left > 0:
		speed_time.text = "%02d" % int(timer_speed.time_left)
		speed_time.visible = true
		speed_sprite.visible = true
	else:
		speed_time.visible = false
		speed_sprite.visible = false
		
	# for the pollen power-up, show when active
	if timer_pollen and timer_pollen.time_left > 0:
		score_time.text = "%02d" % int(timer_pollen.time_left)
		#score_time.text = str(int(timer_pollen.time_left)) # showing the time as a string
		score_time.visible = true
		score_sprite.visible = true
	else:
		score_time.visible = false
		score_sprite.visible = false
	
func _on_timer_speed_timeout():
	speed_time.visible = false
	speed_sprite.visible = false
	print("timer ends")
	
func _on_timer_pollen_timeout():
	score_time.visible = false
	score_sprite.visible = false
	print("timer ends")
