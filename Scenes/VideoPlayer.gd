extends VideoPlayer


func _ready():
	pass


func _on_VideoPlayer_finished():
	get_tree().change_scene("res://Scenes/First.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		get_tree().change_scene("res://Scenes/First.tscn")
