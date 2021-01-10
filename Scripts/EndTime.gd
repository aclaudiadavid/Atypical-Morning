extends Label


func _ready():
	var new = Global.check_if_better(Global.time)
	
	if new:
		get_tree().get_node("HighScore").visible()
	
	var minutes = stepify(Global.time / 60, 1)
	var seconds = stepify(fmod(Global.time, 60.0), 1)
	self.text = String(minutes) + ":" + String(seconds)
