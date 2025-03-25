extends Control

@onready var progress_bar: TextureProgressBar = $TextureProgressBar


func _process(_delta: float) -> void:
	# setting the value of the progress bar to be the score
	progress_bar.value = Global.score


func _on_texture_progress_bar_value_changed(value: float) -> void:
	# setting the label as the score
	$Label.text = str(Global.score)
	
	# finished filling the bar signal
	if Global.score >= progress_bar.max_value:
		Events.has_collected_all_pollen.emit()
		print("score: progress bar complete!")
