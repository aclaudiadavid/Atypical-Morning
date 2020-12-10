extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
const SPEED = 300
const JUMP = 500

var motion = Vector2()
var hp = 10

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED;
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("idle")
	
	if not is_on_floor():
		$AnimatedSprite.play("jump")
	
	motion.y += GRAVITY
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
			motion.y = -JUMP
			
	motion = move_and_slide(motion, UP)
	
	motion.x = lerp(motion.x, 0, 0.2)

func _on_Pill_collect():
	hp += 5
