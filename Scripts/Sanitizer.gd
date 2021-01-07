extends Area2D

const SPEED = 550
var velocity = Vector2()
var direction = 1

func _ready():
	pass # Replace with function body.

func set_p_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
		$CollisionShape2D.position.x *= -1

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Sanitizer_body_entered(body):
	if body.name != "Character":
		queue_free()
	if "enemy" in body.name:
		body.dead()
		queue_free()

