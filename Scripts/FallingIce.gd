extends KinematicBody2D

onready var timer = $FallTimer

var velocity = Vector2()
const GRAVITY = 10.5

var is_triggered = false

func _ready():
	timer.set_wait_time(1.0)
	timer.connect("timeout", self, "_onFallTimer_timeout")
	set_physics_process(false)

func _physics_process(delta):
	velocity.y = GRAVITY / 2
	position += velocity

func collide_with(collision : KinematicCollision2D, collider : KinematicBody2D):
	if !is_triggered:
		is_triggered = true
		timer.start(1.0)

func _onFallTimer_timeout():
	set_physics_process(true)
	
