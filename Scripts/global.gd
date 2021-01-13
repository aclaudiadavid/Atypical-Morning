extends Node

#Time
var time = 0
var lastScene = "First"

#health
var max_health = 10
var max_shield = 5
var max_speed = 290
var health = max_health
var shield = max_shield
var s_level = 0
var speed = max_speed
var slowed_down = false

#Weapons
var sanitizerON = false
var swordON = false
var boomerangON = false

#Saving functions
var savegame = File.new() #file
var save_path = "user://savegame.save" #place of the file
var save_data = {1: 9999, 2: 9999, 3: 9999, 4: 9999, 5: 9999} #variable to store data

func create_save():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func check_if_better(time):
	var new = false
	save_data = read_savegame()
	for x in save_data:
		if time < save_data[x]:
			if x == 1:
				new = true
			var y = 5
			while x < y:
				save_data[y] = save_data[y-1]
				y -= 1
			save_data[x] = time
			
			save()
			break
	return new

func _ready():
	if not savegame.file_exists(save_path):
		create_save()

func save():
	savegame.open(save_path, File.WRITE) #open file to write
	savegame.store_var(save_data) #store the data
	savegame.close() # close the file

func read_savegame():
	savegame.open(save_path, File.READ) #open the file
	save_data = savegame.get_var() #get the value
	savegame.close() #close the file
	return save_data #return the value
