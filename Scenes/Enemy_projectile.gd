extends RigidBody2D
signal hit

const SNOT_SPEED = 300

var speed_x = 1
var speed_y = 0

func _ready():
	pass
	
func _physics_process(delta):
	var motion = Vector2(speed_x, speed_y) * SNOT_SPEED
	set_global_position(get_global_position() + motion * delta)

func flip(direction):
	if direction == 1:
		$Sprite.flip_v = false
	else:
		$Sprite.flip_v = true

func _on_Snot_body_entered(body):
	emit_signal("hit")
	queue_free()

