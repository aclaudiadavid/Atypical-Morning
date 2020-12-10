extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
const SPEED = 300
const JUMP = 500

var motion = Vector2()
var hp = 10

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

func _process(_delta):
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.stop()

func _on_Pill_collect():
	hp += 5
