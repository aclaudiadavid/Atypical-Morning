extends Button

func _on_RetryButton_pressed():
	Global.time = 0.0
	Global.lastScene = "First"
	get_tree().change_scene("res://Scenes/First.tscn")
