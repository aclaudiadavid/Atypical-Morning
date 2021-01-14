extends StaticBody2D
class_name Boss

const GRAVITY = 10
const UP = Vector2(0,-1)
const SHOT = preload("res://Scenes/Boss_projectile.tscn")

export var stomp_impulse := 600.0
export (int) var hp = 10

var velocity = Vector2()
var direction = 1 #to the right
var is_dead = false
var floating_text = preload("res://Scenes/FloatingText.tscn")
var limit = false
var shot_pos = 125

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")

func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("dead")
	$DeathAudio.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/DamageArea.set_deferred("disabled", true)
	$Timer.start()
	
func damage(dmg):
	hp -= dmg
	var text = floating_text.instance()
	text.amount = dmg
	text.type = "Damage"
	add_child(text)
	if hp <= 0:
		dead()

func _physics_process(delta):
	if is_dead == false:
		#$AnimatedSprite.play("walk")
		
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		if $Aim.is_colliding() == true:
			if limit == false:
				var shot = SHOT.instance()
				shot.global_position = self.position + Vector2(150, shot_pos) * direction
				shot.speed_x = shot.speed_x * direction
				get_parent().add_child(shot)
				$Aim/Limiter.start()
				limit = true
				


func _on_Timer_timeout():
	self.queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword"):
		damage(PlayerVars.sword_damage)


func _on_Limiter_timeout():
	var shot = SHOT.instance()
	shot_pos = 125 - randi() % 121
	#shot_pos -= 60
	#if shot_pos == -55:
		#shot_pos = 125
	shot.global_position = self.position + Vector2(150, shot_pos) * direction
	shot.speed_x = shot.speed_x * direction
	get_parent().add_child(shot)
	$Aim/Limiter.start()
