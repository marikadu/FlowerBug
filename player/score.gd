extends Control


func _process(_delta: float) -> void:
#	setting the label as the score
	self.text = str(Global.score)
