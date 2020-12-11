extends KinematicBody2D

signal health_updated(health)
signal shield_updated(shield)
#signal max_changed(new_amount)
signal killed()


const UP = Vector2(0,-1)
const GRAVITY = 10
const SPEED = 300
const JUMP = 800
export var stomp_impulse := 300.0
var motion = Vector2()
var is_dead = false
var medicine_taken = false
var dmg_time = 0.0

export (int) var max_health = 10
export (int) var max_shield = 5


onready var health = max_health setget set_health
onready var shield = max_shield setget set_shield
onready var invulnerability_timer = $invulnerabilityTimer
onready var effects_animation = $AnimationPlayer
onready var hpbar = $HPBar
onready var shieldbar = $ShieldBar

func _physics_process(delta):
	if is_dead == false:
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
		
		for i in get_slide_count():
			var collision := get_slide_collision(i)
			var collider := collision.collider
			var is_stomping := (
				collider is Enemy and
				is_on_floor() and
				collision.normal.is_equal_approx(Vector2.UP)
			)
			if is_stomping:
				motion.y = -stomp_impulse
				(collider as Enemy).dead()
			elif "enemy2" in get_slide_collision(i).collider.name:
				damage(1)
		
		
		if not medicine_taken && shield == 0:
			dmg_time += delta;
		
		if dmg_time >= 3.0:
			dmg_time = 0.0
			infection(1)
			
		
func dead():
	is_dead = true
	motion = Vector2(0, 0)
	$AnimatedSprite.play("idle")
	$CollisionShape2D.disabled = true
	$death.start()


func infection(amount):
		if shield <= 0 && not medicine_taken:
			set_health(health - amount)
			HPBarUpdate()
			effects_animation.play("damage")



func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		if shield > 0:
			set_shield(shield - amount)
			ShieldBarUpdate()
			effects_animation.play("damageS")
		else:
			set_health(health - amount)
			HPBarUpdate()
			effects_animation.play("damage")

		effects_animation.play("flash")

func HPBarUpdate():
	hpbar.get_node("Tween").interpolate_property(hpbar, "value", hpbar.value, health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hpbar.get_node("Tween").start()
	hpbar.value = health
	if health == 0:
		hpbar.hide()

func ShieldBarUpdate():
	if shield > 0:
		hpbar.hide()
	shieldbar.get_node("Tween").interpolate_property(shieldbar, "value", shieldbar.value, shield, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	shieldbar.get_node("Tween").start()
	shieldbar.value = shield
	if shield == 0:
		shieldbar.hide()
		hpbar.show()

func set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			dead()
			emit_signal("killed")

func set_shield(value):
	var prev_shield = shield
	shield = clamp(value, 0, max_shield)
	if shield != prev_shield:
		emit_signal("shield_updated", shield)


func _on_invulnerabilityTimer_timeout():
	effects_animation.play("rest")


func _on_Pill_collect():
	set_health(health + 5)
	HPBarUpdate()
	medicine_taken = true
	print(medicine_taken)


func _on_death_timeout():
	self.queue_free()
