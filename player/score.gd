extends Control


func _process(_delta: float) -> void:
#	setting the label as the score
	$Label.text = str(Global.score)
	$TextureProgressBar.value = Global.score
