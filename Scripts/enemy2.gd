extends KinematicBody2D
class_name Enemy

const GRAVITY = 10
const SPEED = 100
const UP = Vector2(0,-1)

export var stomp_impulse := 600.0

var velocity = Vector2()
var direction = 1 #to the right
var is_dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")

func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("dead")
#	$CollisionShape2D.disabled = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()

func _physics_process(delta):
	if is_dead == false:
		velocity.x = SPEED * direction
		$AnimatedSprite.play("walk")
		
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, UP)
		
		if is_on_wall():
			direction = direction * -1
			$RayCast2D.position.x *= -1
		
		if $RayCast2D.is_colliding() == false:
			direction = direction * -1
			$RayCast2D.position.x *= -1
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Character" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.damage(1)


func _on_Timer_timeout():
	self.queue_free()