extends Button

func _on_HighScoreButton_pressed():
	$Label.visible = true


func _on_Button_pressed():
	$Label.visible = false


func _on_Label_ready():
	var data = Global.read_savegame()
	print(data)
