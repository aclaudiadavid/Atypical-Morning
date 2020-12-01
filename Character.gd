extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
const SPEED = 200
const JUMP = 500

var motion = Vector2()
<<<<<<< HEAD
=======
var hp = 10
>>>>>>> 0f48ff56ee6e50bba5536e9269fafd8ce668b6b7

func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed(("ui_right")):
		motion.x = SPEED;
	elif Input.is_action_pressed(("ui_left")):
		motion.x = -SPEED
	else:
		motion.x = 0
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP
			
	motion = move_and_slide(motion, UP)
	pass
<<<<<<< HEAD
=======



func _on_Pill_collect():
	hp += 5
>>>>>>> 0f48ff56ee6e50bba5536e9269fafd8ce668b6b7
