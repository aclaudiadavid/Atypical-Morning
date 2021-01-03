extends KinematicBody2D
class_name EnemyRanged

const SHOT = preload("res://Scenes/Enemy_projectile.tscn")
const GRAVITY = 10
const SPEED = 100
const UP = Vector2(0,-1)

export var stomp_impulse := 600.0

var velocity = Vector2()
var direction = 1 #to the right
var is_dead = false
var limit = false


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
		if direction == 1:
			$Aim.set_rotation(0)
		else:
			$Aim.set_rotation(PI)
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
			
		if $Aim.is_colliding() == true:
			if limit == false:
				$Aim/Limiter.start()
				limit = true
				var shot = SHOT.instance()
				shot.global_position = self.position + Vector2(50, 0) * direction
				shot.speed_x = shot.speed_x * direction
				shot.flip(direction)
				get_parent().add_child(shot)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Character" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.damage(1)
			


func _on_Timer_timeout():
	self.queue_free()


func _on_Limiter_timeout():
	limit = false
