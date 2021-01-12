extends Label

func _ready():
	var data = Global.read_savegame()
	
	var text
	
	if data.get(1) < 9999:
		var minutes1 = stepify(data.get(1) / 60, 1)
		var seconds1 = stepify(fmod(data.get(1), 60.0), 1)
		text = "1º " + String(minutes1) + ":" + String(seconds1) + "\n\n"
	if data.get(2) < 9999:
		var minutes2 = stepify(data.get(2) / 60, 1)
		var seconds2 = stepify(fmod(data.get(2), 60.0), 1)
		text += "2º " + String(minutes2) + ":" + String(seconds2) + "\n\n"
	if data.get(3) < 9999:
		var minutes3 = stepify(data.get(3) / 60, 1)
		var seconds3 = stepify(fmod(data.get(3), 60.0), 1)
		text += "3º " + String(minutes3) + ":" + String(seconds3) + "\n\n"
	if data.get(4) < 9999:
		var minutes4 = stepify(data.get(4) / 60, 1)
		var seconds4 = stepify(fmod(data.get(4), 60.0), 1)
		text += "4º " + String(minutes4) + ":" + String(seconds4) + "\n\n"
	if data.get(5) < 9999:
		var minutes5 = stepify(data.get(5) / 60, 1)
		var seconds5 = stepify(fmod(data.get(5), 60.0), 1)
		text += "5º " + String(minutes5) + ":" + String(seconds5) + "\n\n"
		
	self.text = text
