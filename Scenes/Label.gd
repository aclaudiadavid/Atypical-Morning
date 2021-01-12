extends Label

func _ready():
	var data = Global.read_savegame()
	
	var text = ""
	
	if data.get(1) < 9999:
		var minutes1 = int(data.get(1)) / 60
		var seconds1 = stepify(fmod(data.get(1), 60.0), 1)
		if seconds1 < 10:
			text = "1º " + String(minutes1) + ":0" + String(seconds1) + "\n\n"
		else:
			text = "1º " + String(minutes1) + ":" + String(seconds1) + "\n\n"
	if data.get(2) < 9999:
		var minutes2 = int(data.get(2)) / 60
		var seconds2 = stepify(fmod(data.get(2), 60.0), 1)
		if seconds2 < 10:
			text += "2º " + String(minutes2) + ":0" + String(seconds2) + "\n\n"
		else:
			text += "2º " + String(minutes2) + ":" + String(seconds2) + "\n\n"
	if data.get(3) < 9999:
		var minutes3 = int(data.get(3)) / 60
		var seconds3 = stepify(fmod(data.get(3), 60.0), 1)
		if seconds3 < 10:
			text += "3º " + String(minutes3) + ":0" + String(seconds3) + "\n\n"
		else:
			text += "3º " + String(minutes3) + ":" + String(seconds3) + "\n\n"
	if data.get(4) < 9999:
		var minutes4 = int(data.get(4)) / 60
		var seconds4 = stepify(fmod(data.get(4), 60.0), 1)
		if seconds4 < 10:
			text += "4º " + String(minutes4) + ":0" + String(seconds4) + "\n\n"
		else:
			text += "4º " + String(minutes4) + ":" + String(seconds4) + "\n\n"
	if data.get(5) < 9999:
		var minutes5 = int(data.get(5)) / 60
		var seconds5 = stepify(fmod(data.get(5), 60.0), 1)
		if seconds5 < 10:
			text += "5º " + String(minutes5) + ":0" + String(seconds5) + "\n\n"
		else:
			text += "5º " + String(minutes5) + ":" + String(seconds5) + "\n\n"
	
	self.text = text
