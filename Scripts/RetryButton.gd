extends Button

func _on_RetryButton_pressed():
	Global.Time = 0
	get_tree().change_scene("res://Scenes/First.tscn")
