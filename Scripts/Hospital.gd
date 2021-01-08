extends Area2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

func on_click():
	Global.lastScene = "Hospital"
	get_tree().change_scene("res://Scenes/Hospital.tscn")
