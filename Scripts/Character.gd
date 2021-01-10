extends KinematicBody2D

signal health_updated(health)
signal shield_updated(shield)
#signal max_changed(new_amount)
signal killed()


const UP = Vector2(0,-1)
const GRAVITY = 10.5
const SPEED = 300
const JUMP = 500
const SANITAZER = preload("res://Scenes/Sanitizer.tscn")
const BOOMERANG = preload("res://Scenes/boomerang.tscn")
var floating_text = preload("res://Scenes/FloatingText.tscn")
export var stomp_impulse := 300.0
var motion = Vector2()
var is_dead = false
var medicine_taken = false
var dmg_time = 0.0
var time_mult = 1
var paused = false

#sanitizer
#var sanitizerON = false
#var san_vel = 1
#var san_damage = 1
#var san_count = 1

#sword
#var swordON = false
var isAttacking = false
#var sword_range = 1
#var sword_damage = 1

#boomerang
var boomerang_count = 0
#var max_boom = 1
#var boomerangON = false
#var boom_distance = 1
#var boom_vel = 1

onready var invulnerability_timer = $invulnerabilityTimer
onready var effects_animation = $AnimationPlayer
onready var hpbar = $HPBar
onready var shieldbar = $ShieldBar

onready var walk = $PlayerWalkSound

func _ready():
	ShieldBarUpdate()
	HPBarUpdate()
	set_process(true)


func _physics_process(delta):
	if not paused:
		Global.time += delta * time_mult
	
	if is_dead == false:
		if Input.is_action_pressed("ui_right") and isAttacking == false:
			motion.x = SPEED
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = false
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
				$AttackArea/CollisionShape2D.position.x = $AttackArea/CollisionShape2D.position.x * -1
		elif Input.is_action_pressed("ui_left") and isAttacking == false:
			motion.x = -SPEED
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
				$AttackArea/CollisionShape2D.position.x = $AttackArea/CollisionShape2D.position.x * -1
		else:
			if isAttacking == false:
				$AnimatedSprite.play("idle")
		
		if not is_on_floor() and isAttacking == false:
			$AnimatedSprite.play("jump")

		if motion.x != 0 and is_on_floor():
			if !walk.playing:
				walk.play()
		elif walk.playing:
			walk.stop()
		
		motion.y += GRAVITY
		
		
		if position.y > 950:
			dead()
		
		if Input.is_action_just_pressed("ui_up") and is_on_floor() && isAttacking == false:
				motion.y = -JUMP
		
		if Input.is_action_just_pressed("Attack"):
			if PlayerVars.sanitizerON:	
				var sanitizer = SANITAZER.instance()
				sanitizer.damage = PlayerVars.san_damage
				sanitizer.speed = sanitizer.speed * PlayerVars.san_vel
				if sign($Position2D.position.x) == 1:
					sanitizer.set_p_direction(1)
				else:
					sanitizer.set_p_direction(-1)
				get_parent().add_child(sanitizer)
				sanitizer.position = $Position2D.global_position
			elif PlayerVars.boomerangON and boomerang_count < PlayerVars.max_boom:
				var boomerang = BOOMERANG.instance()
				boomerang.max_dist *= PlayerVars.boom_distance
				boomerang.vel *= PlayerVars.boom_vel
				if sign($Position2D.position.x) == 1:
					boomerang.set_p_direction(Vector2(1, 0))
				else:
					boomerang.set_p_direction(Vector2(-1, 0))
				boomerang.global_position = global_position
				boomerang.thrower = self
				get_parent().add_child(boomerang)
				boomerang_count += 1
			
			elif PlayerVars.swordON:
				if not is_on_floor():
					$AnimatedSprite.play("jumpSlash")
				else:
					$AnimatedSprite.play("Slash")
				isAttacking = true
				$AttackArea/CollisionShape2D.disabled = false
				
		motion = move_and_slide(motion, UP)
		
		motion.x = lerp(motion.x, 0, 0.2)
		
		for i in get_slide_count():
			var collision := get_slide_collision(i)
			var collider := collision.collider
			var is_stomping := (
				(collider is Enemy or collider is ChildEnemy or collider is EnemyRanged) and
				is_on_floor() and
				collision.normal.is_equal_approx(Vector2.UP)
			)
			
			if collision.collider.has_method("collide_with"):
				collision.collider.collide_with(collision, collider)
			
			if is_stomping and collider is Enemy:
				motion.y = -stomp_impulse
				(collider as Enemy).dead()				
			elif is_stomping and collider is ChildEnemy:
				motion.y = -stomp_impulse
				(collider as ChildEnemy).dead()
			elif is_stomping and collider is EnemyRanged:
				motion.y = -stomp_impulse
				(collider as EnemyRanged).dead()
			elif "enemy2" in get_slide_collision(i).collider.name:
				damage(1)
			elif "FEnd" in get_slide_collision(i).collider.name:
				paused = true
				get_tree().change_scene("res://Scenes/Winning.tscn")
			elif "End" in get_slide_collision(i).collider.name:
				paused = true
				get_tree().change_scene("res://Scenes/Menu.tscn")				
			elif "endbarrier" in get_slide_collision(i).collider.name:
				get_node("../finalcam").make_current()
				get_node("../endbarrier/CollisionShape2D").disabled = true
		
		
		if not medicine_taken && Global.shield == 0:
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
		if Global.shield <= 0 && not medicine_taken:
			set_health(Global.health - amount)
			var text = floating_text.instance()
			text.amount = amount
			text.type = "Sickness"
			add_child(text)
			HPBarUpdate()
			effects_animation.play("damage")



func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		if Global.shield > 0:
			set_shield(Global.shield - amount)
			var text = floating_text.instance()
			text.amount = amount
			text.type = "Shield"
			add_child(text)
			ShieldBarUpdate()
			effects_animation.play("damageS")
		else:
			set_health(Global.health - amount)
			var text = floating_text.instance()
			text.amount = amount
			text.type = "Damage"
			add_child(text)
			HPBarUpdate()
			effects_animation.play("damage")

		effects_animation.play("flash")

func HPBarUpdate():
	hpbar.get_node("Tween").interpolate_property(hpbar, "value", hpbar.value, Global.health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hpbar.get_node("Tween").start()
	hpbar.value = Global.health
	if Global.health == 0:
		hpbar.hide()

func ShieldBarUpdate():
	if Global.shield > 0:
		hpbar.hide()
	shieldbar.get_node("Tween").interpolate_property(shieldbar, "value", shieldbar.value, Global.shield, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	shieldbar.get_node("Tween").start()
	shieldbar.value = Global.shield
	if Global.shield == 0:
		shieldbar.hide()
		hpbar.show()

func set_health(value):
	var prev_health = Global.health
	Global.health = clamp(value, 0, Global.max_health)
	if Global.health != prev_health:
		emit_signal("health_updated", Global.health)
		if Global.health == 0:
			dead()
			emit_signal("killed")

func set_shield(value):
	var prev_shield = Global.shield
	Global.shield = clamp(value, 0, Global.max_shield)
	if Global.shield != prev_shield:
		emit_signal("shield_updated", Global.shield)


func _on_invulnerabilityTimer_timeout():
	effects_animation.play("rest")


func _on_Pill_collect():
	dmg_time = 0.0
	set_health(Global.health + 5)
	HPBarUpdate()
	medicine_taken = true


func _on_death_timeout():
	self.queue_free()
	Global.time = 0
	get_tree().change_scene("res://Scenes/GameOver.tscn")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Slash" or $AnimatedSprite.animation == "jumpSlash":
		$AttackArea/CollisionShape2D.disabled = true
		isAttacking = false

func double_boom():
	PlayerVars.max_boom += 1

func pick_san():
	PlayerVars.sanitizerON = true

func pick_boom():
	PlayerVars.boomerangON = true
	
func pick_sword():
	PlayerVars.swordON = true

func boostSanVel():
	PlayerVars.san_vel += 0.2

func boostSanDamage():
	PlayerVars.san_damage += 1

func boostBoomVel():
	PlayerVars.boom_vel += 0.2

func boostBoomDist():
	PlayerVars.boom_distance += 0.2

func boostSwordDist():
	PlayerVars.sword_range += 0.2

func boostSwordDamage():
	PlayerVars.sword_range += 2
