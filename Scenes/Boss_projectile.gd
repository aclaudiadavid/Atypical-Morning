extends RigidBody2D
signal hit(dmg)

const SNOT_SPEED = 330

var speed_x = 1
var speed_y = 0

func _ready():
	self.connect("hit", get_node("../Character"), "damage")

func _physics_process(delta):
	var motion = Vector2(speed_x, speed_y) * SNOT_SPEED
	set_global_position(get_global_position() + motion * delta)

func flip(direction):
	if direction == 1:
		$Sprite.flip_v = false
	else:
		$Sprite.flip_v = true

func _on_Snot_body_entered(body):
	if body.get_name() == "Character":
		emit_signal("hit",1)
	queue_free()
