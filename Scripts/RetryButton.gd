extends Button

func _on_RetryButton_pressed():
	Global.time = 0.0
	Global.lastScene = "First"
	Global.health = Global.max_health
	Global.shield = Global.max_shield
	PlayerVars.sanitizerON = false
	PlayerVars.swordON = false
	PlayerVars.boomerangON = false
	get_tree().change_scene("res://Scenes/First.tscn")
