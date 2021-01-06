extends Label


func _ready():
	var minutes = stepify(Global.time / 60, 1)
	var seconds = stepify(fmod(Global.time, 60.0), 1)
	self.text = String(minutes) + ":" + String(seconds)
