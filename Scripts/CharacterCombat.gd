extends KinematicBody2D

signal health_updated(health)
signal shield_updated(shield)
signal max_changed(new_amount)
signal killed()

const UP = Vector2(0,-1)
const GRAVITY = 25
const SPEED = 200
const JUMP = 800
export var stomp_impulse := 300.0

export (int) var max_health = 5
export (int) var max_shield = 5

onready var health = max_health setget set_health
onready var shield = max_shield setget set_shield
onready var invulnerability_timer = $invulnerabilityTimer
onready var effects_animation = $AnimationPlayer
onready var hpbar = $HPBar
onready var shieldbar = $ShieldBar



var motion = Vector2()

var is_dead = false

func _physics_process(delta):
	
	if is_dead == false:
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
		
	
func dead():
	is_dead = true
	motion = Vector2(0, 0)
	$CollisionShape2D.disabled = true
	$death.start()

func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		if shield > 0:
			set_shield(shield - amount)
			ShieldBarUpdate()
		else:
			set_health(health - amount)
			HPBarUpdate()
		print("shield= ", shield)
		print("health= ", health)
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
	shieldbar.value = shieldss
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

func _on_Timer_timeout():
	self.queue_free()


func _on_invulnerabilityTimer_timeout():
	effects_animation.play("rest")
